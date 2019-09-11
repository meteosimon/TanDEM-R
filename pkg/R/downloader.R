download_TanDEM <- function(lon = c(7, 16), lat = c(45, 49), fact = 5, usr = "", pwd = "",
                            return.raster = TRUE, save.netcdf = TRUE) {
 
    # ----------------------------------------------------------------
    # TanDEM-X is available in tiles, 1 times 1 degree each.
    # Expanding lon/lat as required for downloading each tile.
    # ----------------------------------------------------------------
    ll  <- expand.grid(min(floor(lon)):max(floor(lon)), min(floor(lat)):max(floor(lat)))
    names(ll) <- c('lon','lat')
    baseurl <- "download.geoservice.dlr.de/TDM90/files/"
    dir.create("TDM90", showWarnings = FALSE)
    DEM.segments <- list()
    for ( i in 1:nrow(ll) ) {
        ## TODO: distinction between N and S, W and E
        file <- sprintf("TDM1_DEM__30_N%02dE%03d", ll$lat[i], ll$lon[i])
        url  <- sprintf("%sN%02d/E%03d/", baseurl, ll$lat[i], (ll$lon[i] %/% 10) * 10)

        ## cat(sprintf("   Downloading %s\n",file))
        if(!file.exists(sprintf("TDM90/%s_DEM.tif", file))) {

            download.file(url = sprintf("https://%s%s.zip", url, file),
                     destfile = sprintf("TDM90/%s.zip", file),
                     method   = "wget",
                     extra    = sprintf("--auth-no-challenge --user=%s --password=%s", usr, pwd))

            system(sprintf("cd TDM90; unzip %s.zip; rm %s.zip; cp %s_V01_C/DEM/%s_DEM.tif .; rm -r %s_V01_C/", file, file, file, file, file))
        }
    }
 
    # ----------------------------------------------------------------
    # - Read and merge the geotiff files
    # ----------------------------------------------------------------
    DEM <- NULL
    if(return.raster) {
	geoFiles <- list.files("TDM90",'.*(.tif)$')
	for ( file in geoFiles ) {
	    tmp <- raster( sprintf("TDM90/%s", file) )
	    NAvalue(tmp) <- -32767
	    tmp <- aggregate(tmp, fact = fact)
	    if ( is.null(DEM) ) { DEM <- tmp; next }
	    DEM <- merge(DEM, tmp)
	}
    }
    # ----------------------------------------------------------------
    # Save netCDF
    # ----------------------------------------------------------------
    if(save.netcdf) {
        writeRaster(DEM, "TDM90.nc", force_v4 = TRUE, compression = 7)
    }
    # ----------------------------------------------------------------
    # Return Raster object
    # ----------------------------------------------------------------
    return( DEM )
}





