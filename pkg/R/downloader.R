download_TanDEM <- function(lon = c(5, 16), lat = c(45, 55),
			    usr = getOption("geoservice.usr"),
			    srv = "geoservice.dlr",
			    dstdir = "~/Data/TanDEM-X") {

  # ----------------------------------------------------------------
  # TanDEM-X is available in tiles, 1 times 1 degree each.
  # Expanding lon/lat as required for downloading each tile.
  # ----------------------------------------------------------------
  ll <- expand.grid(
      "lon" = min(floor(lon)):max(floor(lon)),
      "lat" = min(floor(lat)):max(floor(lat))
  )
  baseurl <- "download.geoservice.dlr.de/TDM90/files/"
  dir.create(dstdir, showWarnings = FALSE)
  dstfiles <- character(nrow(ll))
  tmpdir <- tempdir()
  for ( i in 1:nrow(ll) ) {
    ## TODO: distinction between N and S, W and E
    filebase <- sprintf("TDM1_DEM__30_N%02dE%03d", ll$lat[i], ll$lon[i])
    url  <- sprintf("%sN%02d/E%03d/", baseurl, ll$lat[i], (ll$lon[i] %/% 10) * 10)

    ## cat(sprintf("   Downloading %s\n",file))
    dstfile <- sprintf("%s/%s_DEM.tif", dstdir, filebase)
    if(!file.exists(dstfile)) {

      ## TODO: use httr for wget using https or maybe using ftp
      tmpfile <- sprintf("%s/%s.zip", tmpdir, filebase)
      try_download <- tryCatch(
        download.file(
          url      = sprintf("https://%s%s.zip", url, filebase),
          destfile = tmpfile,
          method   = "wget",
          extra    = sprintf("--auth-no-challenge --user=%s --password=%s",
          		   usr, keyring::key_get(srv, usr))
        ),
	error = function(e) NULL
      )

      if (!is.null(try_download)) {
        unzip(
          zipfile   = tmpfile,
          files     = sprintf("%s_V01_C/DEM/%s_DEM.tif", filebase, filebase),
          exdir     = dstdir,
          junkpaths = TRUE
        )
      }

    } else {
      try_download <- 0
    }
    dstfiles[i] <- if (is.null(try_download)) NA_character_ else dstfile
  }

  na.omit(dstfiles)
}

### merge_TanDEM <- function(files, ...) { 
###     # ----------------------------------------------------------------
###     # - Read and merge the geotiff files
###     # ----------------------------------------------------------------
###     DEM <- NULL
###     if(return.raster) {
### 	geoFiles <- list.files("TDM90",'.*(.tif)$')
### 	for ( file in geoFiles ) {
### 	    tmp <- raster( sprintf("TDM90/%s", file) )
### 	    NAvalue(tmp) <- -32767
### 	    tmp <- aggregate(tmp, fact = fact)
### 	    if ( is.null(DEM) ) { DEM <- tmp; next }
### 	    DEM <- merge(DEM, tmp)
### 	}
###     }
###     # ----------------------------------------------------------------
###     # Save netCDF
###     # ----------------------------------------------------------------
###     if(save.netcdf) {
###         writeRaster(DEM, "TDM90.nc", force_v4 = TRUE, compression = 7)
###     }
###     # ----------------------------------------------------------------
###     # Return Raster object
###     # ----------------------------------------------------------------
###     return( DEM )
### }





