#' Download TanDEM-X
#' 
#' A download tool to retrieve TanDEM-X data.
#'
#' Download of tiles using \code{wget} from https.
#' A character vector of the downloaded tif files is returned.
#' 
#' @param lon numeric vector of length two indicating the longitude range.
#' @param lat numeric vector of length two indicating the latitude range.
#' @param usr character. username.
#' @param srv character. service.
#' @param dstdir character. destination directory.
#' @examples
#' \dontrun{
#' x <- download_TanDEM(lon = 11.5, lat = 47.5, dstdir = "test")
#' }
#' @aliases download_TanDEM
#' @keywords data
#' @export
download_TanDEM <- function(lon = c(5, 16), lat = c(45, 55),
			    usr = getOption("geoservice.usr"),
			    srv = "geoservice.dlr",
			    dstdir = "TanDEM-X") {

  # ----------------------------------------------------------------
  # TanDEM-X is available in tiles, 1 times 1 degree each.
  # Expanding lon/lat as required for downloading each tile.
  # ----------------------------------------------------------------
  ll <- expand.grid(
    "lon" = min(floor(lon)):max(floor(lon)),
    "lat" = min(floor(lat)):max(floor(lat))
  )
  baseurl <- "https://download.geoservice.dlr.de/TDM90/files"
  dir.create(dstdir, showWarnings = FALSE)
  dstfiles <- character(nrow(ll))
  try_download <- numeric(nrow(ll))
  tmpdir <- tempdir()
  for ( i in seq_along(ll[[1]]) ) {
    url      <- sprintf("%s/%s/%s/", baseurl, lat_dir(ll$lat[i]), lon_dir(ll$lon[i]))
    filebase <- sprintf("TDM1_DEM__30_%s%s", lat_dir(ll$lat[i]), lon_file(ll$lon[i]))
    dstfile  <- sprintf("%s/%s_DEM.tif", dstdir, filebase)
    if(!file.exists(dstfile)) {

      ## TODO: use httr for wget using https or maybe using ftp
      tmpfile <- sprintf("%s/%s.zip", tmpdir, filebase)
      try_download[i] <- tryCatch(
        utils::download.file(
          url      = sprintf("%s%s.zip", url, filebase),
          destfile = tmpfile,
          method   = "wget",
          extra    = sprintf("--auth-no-challenge --user=%s --password=%s",
          		   usr, keyring::key_get(srv, usr))
        ),
	error = function(e) 1
      )

      if (try_download[i] == 0) {
        utils::unzip(
          zipfile   = tmpfile,
          files     = sprintf("%s_V01_C/DEM/%s_DEM.tif", filebase, filebase),
          exdir     = dstdir,
          junkpaths = TRUE
        )
      }

    } else {
      try_download[i] <- 0
    }
    dstfiles[i] <- dstfile
  }

  dstfiles[try_download == 0]
}

lon_file <- function(lon) {
	hs <- if (sign(lon) == -1) "W" else "E"
	lon <- abs(lon)
	sprintf("%s%03d", hs, lon)
}

lon_dir <- function(lon) {
	hs <- if (sign(lon) == -1) "W" else "E"
	lon <- abs(lon)
	lon <- lon %/% 10 * 10
	sprintf("%s%03d", hs, lon)
}

lat_dir <- function(lat) {
	hs <- if (sign(lat) == -1) "S" else "N"
	lat <- abs(lat)
	sprintf("%s%02d", hs, lat)
}


