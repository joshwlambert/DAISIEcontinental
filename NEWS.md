# DAISIEcontinental 0.2.0

Second minor release of _DAISIEcontinental_ R package contains a range of updates and new functionality.

## New features

* A new vicariance analysis is added to the package, this includes:
  - A `plot_vicariance_scatter()` function
  - A `post_process_vicariance_results()` function
  - A `run_vicariance_analysis.R` R script
  - A `run_vicariance_analysis.sh` bash script
  - A `vicariance_scatter.png` plot

* Markdown formatting is enabled for roxygen2 documentation.

## Updated features

* `sim_continental_island()` now has an `epss` argument for colonisation max ages of vicariant species. Default is `0`.
* GitHub actions continuous integration now installs from renv lock file (using `r-lib/actions/setup-r@v2`) instead of installing the newest version of required dependencies (using `r-lib/actions/setup-r-dependencies@v2`).
* `ggplot2::annotate(geom = "point")` is used over `ggplot2::geom_point()` when plotting a single point in `plot_param_diffs()`.
* `plot_vicariance_scatter()` call is added to `data_vis.R` script.
* `post_process_vicariance_results()` call is added to `post_process.R` script.
* Analyses use `simplex` optimisation method instead of `subplex`.
* The `test-continental-daisie.Rmd` vignette is updated.
* Parameter estimate plots and empirical plots are updated.
* Post processed data in `inst/` is updated.
* Default plot DPI is changed to 300.

# DAISIEcontinental 0.1.0

The initial release of _DAISIEcontinental_ R package contains functions, scripts, documentation and data for analysing the continental DAISIE inference model. This first release has developed and used functions and scripts for the manuscript Lambert et al. (in prep) on Madagascar tetrapod fauna.
