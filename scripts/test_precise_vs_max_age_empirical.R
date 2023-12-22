data(Galapagos_datatable, package = "DAISIE")
Galapagos_datatable

epss_default <- DAISIE::DAISIE_dataprep(
  datatable = Galapagos_datatable,
  island_age = 4,
  M = 1000,
  epss = 1e-5
)

epss_smaller <- DAISIE::DAISIE_dataprep(
  datatable = Galapagos_datatable,
  island_age = 4,
  M = 1000,
  epss = 1e-6
)

epss_larger <- DAISIE::DAISIE_dataprep(
  datatable = Galapagos_datatable,
  island_age = 4,
  M = 1000,
  epss = 1.1e-5
)

DAISIE::DAISIE_ML_CS(
  datalist = epss_default,
  initparsopt = c(1, 1, 50, 0.1, 1, 0.1),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  jitter = 1e-5
)

DAISIE::DAISIE_ML_CS(
  datalist = epss_smaller,
  initparsopt = c(1, 1, 50, 0.1, 1, 0.1),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  jitter = 1e-5
)

DAISIE::DAISIE_ML_CS(
  datalist = epss_larger,
  initparsopt = c(1, 1, 50, 0.1, 1, 0.1),
  idparsopt = 1:6,
  parsfix = NULL,
  idparsfix = NULL,
  ddmodel = 11,
  jitter = 1e-5
)
