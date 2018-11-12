download_TanDEM <- function( lon = c(9.7,13.3), lat = c(46.4,48.0), fact = 20, usr = "", pwd = "") {
 
    # ----------------------------------------------------------------
    # Loading required packages. Stop if not able to load.
    # ----------------------------------------------------------------
 #   cat(sprintf("   SRTM data set not available on disc: start automatic download\n"))
 #   library('raster')
 #   library('rgdal')
 #   library('sp')
 
    # ----------------------------------------------------------------
    # SRTM is available in segments, 1 times 1 degree each.
    # Expanding lon/lat as required for downloading each segment
    # ----------------------------------------------------------------
    ll  <- expand.grid(min(floor(lon)):max(floor(lon)), min(floor(lat)):max(floor(lat)))
    names(ll) <- c('lon','lat')
    baseurl <- "https://download.geoservice.dlr.de/TDM90/files/"
    dir.create("~/tmp/TDM90", showWarnings = FALSE)
    DEM.segments <- list()
    for ( i in 1:nrow(ll) ) {
        ## TODO: distinction between N and S, W and E
        file <- sprintf("TDM1_DEM__30_N%02dE%03d.zip", ll$lat[i], ll$lon[i])
        url  <- sprintf("%sN%02d/E%03d/", baseurl, ll$lat[i], round(ll$lon[i], -1) - 10)

        ## cat(sprintf("   Downloading %s\n",file))
        if ( file.exists(sprintf("~tmp/TDM90/%s", file)) ) next
        download.file(sprintf("%s%s", url, file),
                      sprintf("~/tmp/TDM90/%s",file),
                      method = "wget",
                      extra  = sprintf("--user=%s --password=%s", usr, pwd))
        system(sprintf("cd TOPO; unzip %s.zip; rm %s.zip",file,file))
    }
 
    # ----------------------------------------------------------------
    # - Reading the hgt files now
    # ----------------------------------------------------------------
#    hgtfiles <- list.files('TOPO','.*(.hgt)$')
#    cat(sprintf("   Found %d \'hgt\' files on disc. Read and merge them now ...\n",length(hgtfiles)))
#    DEM <- NULL
#    for ( file in hgtfiles ) {
#        tmp <- raster( sprintf('TOPO/%s',file) )
#        tmp <- aggregate(tmp,fact=fact)
#        if ( is.null(DEM) ) { DEM <- tmp; next }
#        DEM <- merge(DEM,tmp)
#    }
# 
    # ----------------------------------------------------------------
    # Return Raster object
    # ----------------------------------------------------------------
#     return( DEM )
 
}





