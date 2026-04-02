# R Implementation: Regulatory-Grade Win Ratio Architecture

To create a professional, regulatory-grade R implementation, we must bridge the gap between Python’s Object-Oriented design and SAS’s macro-driven logic.
In clinical package development (the tools biostatisticians build for FDA submissions), developers avoid writing hardcoded scripts or slow for loops. Instead, they build a Functional S3 Architecture using Base R.
Furthermore, unlike SAS which defaults to Cartesian cross-joins on the hard drive, R operates in RAM. If you blindly cross-join a trial of 2,000 patients using R's expand.grid(), you create a dense 4,000,000-row dataframe that can instantly crash your R session. Therefore, this framework utilizes Matrix Broadcasting via outer() to evaluate all patient duels simultaneously in underlying C-level memory, taking milliseconds.

## Why this Architecture is the R "Gold Standard"

* **Matrix Broadcasting (`outer()`) vs. `expand.grid()`:**
  Many R developers default to mapping pairwise data using `expand.grid(trt_df, ctrl_df)` or `dplyr::cross_join()`. If a Phase III trial has 2,000 patients per arm, that creates a dense 4,000,000-row dataframe, instantly choking R's RAM footprint.
  This framework instead utilizes Base R's `outer()` function. It takes two one-dimensional vectors and crosses them perpendicularly, computing $N \times M$ matrix computations dynamically in highly optimized, native C code, requiring barely any memory.

* **The "R Missing Data Trap" Handled Safely:**
  In standard R logic, calculating differences with missing values evaluates to `NA`. If a script blindly checks `if (diff >= 3)`, R will crash with the error: “missing value where TRUE/FALSE needed.” By declaring `wins[is.na(wins)] <- FALSE` directly on the vectorized matrices, the framework securely enforces standard FDA Intention-to-Treat (ITT) guidelines. Missing survey data naturally fails to win or lose, appropriately punting the patient down to an "Unresolved Tie" without dropping them from the trial denominator.

* **S3 Generic Extensibility (`UseMethod`):**
  This natively replicates the Python Object-Oriented paradigm. If a sponsor requests a new endpoint for a trial—such as evaluating Recurrent Events (count data like total asthma exacerbations over a year)—you don’t need to hack apart the main `run_hce_analysis` engine. You simply build a new constructor `hce_tier_count()` and define its specific math logic via an S3 method `evaluate_tier.hce_tier_count()`. The main loop will automatically inherit and dispatch the new logic perfectly.

* **Clinical Directionality:**
  In the continuous S3 constructor, `higher_is_better = TRUE` is exposed as an argument. This means the exact same analysis pipeline can be used for a Cardiology trial (where high QoL scores are good) and an Oncology trial (where evaluating Tumor Size means lower scores are better) simply by flipping one boolean flag.
