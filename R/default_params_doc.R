#' Documentation for function arguments in the ContinentalTesting package
#'
#' @param signif A numeric specifying how many significant figures the axes
#' labels have when plotting
#' @param scientific A boolean determining whether the axis labels will be
#' converted to scientific notation
#' @param breaks A vector of numerics
#' @param param_set Numeric for the index of the parameter set from the
#' parameter space
#' @param data_folder_path String specifying the directory the data is read
#' from
#' @param output_file_path String specifying the directory the file is saved
#' in, if NULL the file is returned to console and not saved
#' @param transform Either `NULL` or `"ihs"` to specify no transformation of
#' the data or an inverse hyperbolic sine (ihs) transformation
#' @param ml A list of DAISIE data lists [DAISIE::DAISIE_ML_CS()] to calculate
#' the difference in parameter estimates
#' @param total_time Numeric defining the length of the simulation in time
#' units.
#' @param m Numeric defining the size of mainland pool.
#' @param island_pars A numeric vector containing the parameters for the island:
#'   \itemize{
#'     \item{`island_pars[1]`: lambda^c (cladogenesis rate)}
#'     \item{`island_pars[2]`: mu (extinction rate)}
#'     \item{`island_pars[3]`: K (carrying capacity), set K=Inf for
#'     diversity independence.}
#'     \item{`island_pars[4]`: gamma (immigration rate)}
#'     \item{`island_pars[5]`: lambda^a (anagenesis rate)}
#'     }
#' @param nonoceanic_pars A vector of two numerics with the probability of
#' initial presence and the probability of a vicariant species being nonendemic
#' respectively
#' @param replicates Integer specifying number of island replicates to be
#' simulated.
#' @param seed Integer specifying the seed to set before simulating data
#' @param verbose Logical, determining if progress output should be printed
#' during the simulation
#' @param sim_max_age Logical, whether to augment the simulated DAISIE data to
#' convert vicariant species to max age (stacs)
#'
#' @return Nothing
#' @author Joshua W. Lambert
default_params_doc <- function(signif,
                               scientific,
                               breaks,
                               param_set,
                               data_folder_path,
                               output_file_path,
                               transform,
                               ml,
                               total_time,
                               m,
                               island_pars,
                               nonoceanic_pars,
                               replicates,
                               seed,
                               verbose,
                               sim_max_age) {
  # Nothing
}
