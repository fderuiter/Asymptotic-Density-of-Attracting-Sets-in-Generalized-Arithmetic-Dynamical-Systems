source("R/hce_engine.R")

# ==============================================================================
# DEMONSTRATION & TESTING
# ==============================================================================
set.seed(2026)

# 1. Simulate Clinical Dataset (400 Patients)
n_pts <- 400
trial_data <- data.frame(
  USUBJID = 1:n_pts,
  TRTP = rep(c("Investigational", "Placebo"), each = n_pts / 2)
)

is_trt <- trial_data$TRTP == "Investigational"

# Simulate Outcomes (Treatment is slightly better on average)
trial_data$DEATH_DY   <- ifelse(is_trt, rexp(200, 1/1200), rexp(200, 1/900))
trial_data$DEATH_EVNT <- ifelse(is_trt, rbinom(200, 1, 0.15), rbinom(200, 1, 0.25))

trial_data$HOSP_DY    <- ifelse(is_trt, rexp(200, 1/600), rexp(200, 1/400))
trial_data$HOSP_EVNT  <- ifelse(is_trt, rbinom(200, 1, 0.25), rbinom(200, 1, 0.35))

trial_data$QOL_SCORE  <- ifelse(is_trt, rnorm(200, 55, 10), rnorm(200, 50, 10))

# Apply 365-Day Study Limits (Right Censoring constraints)
trial_data$DEATH_EVNT[trial_data$DEATH_DY > 365] <- 0
trial_data$DEATH_DY[trial_data$DEATH_DY > 365] <- 365

trial_data$HOSP_EVNT[trial_data$HOSP_DY > trial_data$DEATH_DY] <- 0
trial_data$HOSP_DY[trial_data$HOSP_DY > trial_data$DEATH_DY] <- trial_data$DEATH_DY[trial_data$HOSP_DY > trial_data$DEATH_DY]

trial_data$HOSP_EVNT[trial_data$HOSP_DY > 365] <- 0
trial_data$HOSP_DY[trial_data$HOSP_DY > 365] <- 365

# INJECT MISSING DATA: Simulate 5% missing survey data
trial_data$QOL_SCORE[sample(1:n_pts, 20)] <- NA

# ------------------------------------------------------------------------------
# 2. Define the Hierarchy (Modular and Extensible)
# ------------------------------------------------------------------------------
my_study_rules <- list(
  hce_tier_tte( "1. All-Cause Mortality",   time_col = "DEATH_DY", stat_col = "DEATH_EVNT"),
  hce_tier_tte( "2. First Hospitalization", time_col = "HOSP_DY",  stat_col = "HOSP_EVNT"),
  hce_tier_cont("3. KCCQ Survey Score",     val_col  = "QOL_SCORE", margin = 3.0, higher_is_better = TRUE)
)

# ------------------------------------------------------------------------------
# 3. Run the Analysis
# ------------------------------------------------------------------------------
results <- run_hce_analysis(
  data       = trial_data,
  group_col  = "TRTP",
  trt_label  = "Investigational",
  ctrl_label = "Placebo",
  hierarchy  = my_study_rules
)

# Because we wrote an S3 print method, standard R printing formats perfectly
print(results)
