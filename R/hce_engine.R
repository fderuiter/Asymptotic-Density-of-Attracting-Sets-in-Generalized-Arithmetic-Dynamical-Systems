# ==============================================================================
# METADATA-DRIVEN HCE WIN RATIO ENGINE (BASE R)
# Methodology: Unmatched Pairwise Generalized Comparisons
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. THE ABSTRACTION: S3 Constructors for Clinical Tiers
# ------------------------------------------------------------------------------
# These functions allow the statistician to define their clinical hierarchy modularly.
# They store the rules for evaluating the tier without hardcoding the math.

#' Define a Time-to-Event (TTE) Tier (e.g., Mortality, Hospitalization)
hce_tier_tte <- function(name, time_col, stat_col) {
  structure(
    list(name = name, time_col = time_col, stat_col = stat_col),
    class = c("hce_tier_tte", "hce_tier")
  )
}

#' Define a Continuous/Subjective Tier (e.g., Quality of Life, Tumor Size)
hce_tier_cont <- function(name, val_col, margin = 0.0, higher_is_better = TRUE) {
  structure(
    list(
      name = name,
      val_col = val_col,
      margin = margin,
      direction = ifelse(higher_is_better, 1, -1)
    ),
    class = c("hce_tier_cont", "hce_tier")
  )
}

# ------------------------------------------------------------------------------
# 2. THE EVALUATORS: S3 Generics for Matrix Vectorized Pairwise Comparisons
# ------------------------------------------------------------------------------
# Instead of slow nested 'for' loops or memory-heavy 'expand.grid()' dataframes,
# we broadcast the vectors into perpendicular N x M matrices natively.

evaluate_tier <- function(tier, trt_df, ctrl_df) {
  UseMethod("evaluate_tier")
}

#' S3 Method for Evaluating Time-to-Event Data (Strict Right-Censoring Logic)
evaluate_tier.hce_tier_tte <- function(tier, trt_df, ctrl_df) {
  t_time <- trt_df[[tier$time_col]]
  t_stat <- trt_df[[tier$stat_col]]

  c_time <- ctrl_df[[tier$time_col]]
  c_stat <- ctrl_df[[tier$stat_col]]

  # Broadcast using outer() to create N x M logical matrices instantly
  time_win_mat  <- outer(t_time, c_time, ">")
  time_loss_mat <- outer(t_time, c_time, "<")

  # Expand status arrays to match the matrix dimensions
  c_stat_mat <- matrix(c_stat == 1, nrow = length(t_time), ncol = length(c_time), byrow = TRUE)
  t_stat_mat <- matrix(t_stat == 1, nrow = length(t_time), ncol = length(c_time), byrow = FALSE)

  # TRUE if Control had the event & Treatment survived strictly longer
  wins   <- c_stat_mat & time_win_mat
  # TRUE if Treatment had the event & Control survived strictly longer
  losses <- t_stat_mat & time_loss_mat

  # ITT Safeguard: Safely handle missing data (NAs cannot be wins/losses)
  wins[is.na(wins)] <- FALSE
  losses[is.na(losses)] <- FALSE

  list(wins = wins, losses = losses)
}

#' S3 Method for Evaluating Continuous Data (Clinical Equivalence Margins)
evaluate_tier.hce_tier_cont <- function(tier, trt_df, ctrl_df) {
  t_val <- trt_df[[tier$val_col]]
  c_val <- ctrl_df[[tier$val_col]]

  # Multiply difference by direction (+1 or -1) to standardize mathematical logic
  diff_mat <- outer(t_val, c_val, "-") * tier$direction

  wins   <- diff_mat >= tier$margin
  losses <- diff_mat <= -tier$margin

  wins[is.na(wins)] <- FALSE
  losses[is.na(losses)] <- FALSE

  list(wins = wins, losses = losses)
}

# ------------------------------------------------------------------------------
# 3. THE ENGINE: The Step-Down Sequence Analyzer
# ------------------------------------------------------------------------------
run_hce_analysis <- function(data, group_col, trt_label, ctrl_label, hierarchy) {

  trt_df  <- data[data[[group_col]] == trt_label, , drop = FALSE]
  ctrl_df <- data[data[[group_col]] == ctrl_label, , drop = FALSE]

  N <- nrow(trt_df)
  M <- nrow(ctrl_df)
  total_pairs <- N * M

  if (total_pairs == 0) stop("Error: Treatment or Control arm is empty.")

  # pair_status tracking matrix: 0 = Unresolved Tie, 1 = Trt Win, -1 = Trt Loss
  pair_status <- matrix(0L, nrow = N, ncol = M)

  results <- list()

  # Step through the user-defined hierarchy sequence
  for (tier in hierarchy) {

    # 1. Ask the S3 generic to evaluate the math for this specific data type
    eval_res <- evaluate_tier(tier, trt_df, ctrl_df)

    # 2. Gatekeeper Logic: Wins/Losses ONLY count if the pair is STILL a tie (== 0)
    valid_wins   <- eval_res$wins & (pair_status == 0L)
    valid_losses <- eval_res$losses & (pair_status == 0L)

    # 3. Update status matrix
    pair_status[valid_wins]   <- 1L
    pair_status[valid_losses] <- -1L

    # 4. Save metrics for this tier
    results[[tier$name]] <- data.frame(
      Tier_Name = tier$name,
      Trt_Wins = sum(valid_wins),
      Trt_Losses = sum(valid_losses),
      Remaining_Ties = sum(pair_status == 0L),
      stringsAsFactors = FALSE
    )

    # Optimization: Break out of the loop early if all pairs are resolved
    if (sum(pair_status == 0L) == 0L) break
  }

  # Aggregate final statistics
  summary_df <- do.call(rbind, unname(results))

  tot_w <- sum(pair_status ==  1L)
  tot_l <- sum(pair_status == -1L)
  tot_t <- sum(pair_status ==  0L)

  # Output a standard S3 Class object containing advanced win statistics
  out <- list(
    summary = summary_df,
    stats = list(
      WR = ifelse(tot_l > 0, tot_w / tot_l, NA_real_),
      WO = (tot_w + 0.5 * tot_t) / (tot_l + 0.5 * tot_t),
      NB = ((tot_w - tot_l) / total_pairs) * 100
    ),
    totals = list(Wins = tot_w, Losses = tot_l, Ties = tot_t, Total_Pairs = total_pairs)
  )
  class(out) <- "hce_result"
  return(out)
}

# ------------------------------------------------------------------------------
# 4. S3 PRINT METHOD: Clinical Study Report Formatting
# ------------------------------------------------------------------------------
#' Overrides standard R printing to yield a perfectly formatted console report
print.hce_result <- function(x, ...) {
  cat(rep("=", 75), "\n", sep="")
  cat(sprintf("%-75s\n", " HIERARCHICAL COMPOSITE ENDPOINT (WIN RATIO) ANALYSIS"))
  cat(rep("=", 75), "\n", sep="")
  cat(sprintf("Total Unique Patient Pairs Evaluated: %s\n\n", format(x$totals$Total_Pairs, big.mark=",")))

  # Print Tier Breakdown
  cat(sprintf("%-28s | %-10s | %-10s | %-15s\n", "Hierarchy Level", "Trt Wins", "Trt Losses", "Passed Down (Ties)"))
  cat(rep("-", 75), "\n", sep="")
  for (i in seq_len(nrow(x$summary))) {
    row <- x$summary[i, ]
    cat(sprintf("%-28s | %-10d | %-10d | %-15d\n",
                row$Tier_Name, row$Trt_Wins, row$Trt_Losses, row$Remaining_Ties))
  }
  cat(rep("-", 75), "\n\n", sep="")

  # Print Statistics
  cat("--- Advanced Win Statistics ---\n")
  cat(sprintf("Win Ratio (WR):  %6.2f   <- Ratio of Won pairs to Lost pairs\n", x$stats$WR))
  cat(sprintf("Win Odds (WO):   %6.2f   <- Conservative estimate incorporating ties\n", x$stats$WO))
  cat(sprintf("Net Benefit:     %+6.1f%%  <- Absolute probability of superior outcome\n", x$stats$NB))
  cat(rep("=", 75), "\n", sep="")
  invisible(x)
}
