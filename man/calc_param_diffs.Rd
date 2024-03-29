% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_param_diffs.R
\name{calc_param_diffs}
\alias{calc_param_diffs}
\title{Calculates the differences in parameter estimates (cladogenesis, extinction,
carrying capacity, colonisation, and anagenesis) from the DAISIE maximum
likelihood model fitted to the ideal and empirical data sets simulated from
\code{\link[=sim_continental_island]{sim_continental_island()}}}
\usage{
calc_param_diffs(ml, param_set)
}
\arguments{
\item{ml}{A list of DAISIE data lists \code{\link[DAISIE:DAISIE_ML]{DAISIE::DAISIE_ML_CS()}} to calculate
the difference in parameter estimates}

\item{param_set}{A single row \code{data.frame} with the parameters used for the
simulation (i.e. one parameter set from the parameter space)}
}
\value{
A list of five numeric vectors
}
\description{
Calculates the differences in parameter estimates (cladogenesis, extinction,
carrying capacity, colonisation, and anagenesis) from the DAISIE maximum
likelihood model fitted to the ideal and empirical data sets simulated from
\code{\link[=sim_continental_island]{sim_continental_island()}}
}
