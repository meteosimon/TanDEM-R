[![Project Status: Concept – Minimal or no implementation has been done
yet, or the repository is only intended to be a limited example, demo,
or
proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)

TanDEM-R
========

R interface for downloading TanDEM-X data. Information on the data can
be found at [DLR's
geoservice](https://geoservice.dlr.de/web/dataguide/tdm90/ "geoservice.dlr.de").

Basic idea is to enable such a workflow to handle TanDEM-X data:

    options("geoservice.usr" = "Max.Mustermann@mail.com")

    tiffiles <- download_TanDEM()

    library("stars")
    vrt <- st_mosaic(tiffiles)
    x <- read_stars(vrt, proxy = TRUE)
    plot(x)

    ## Loading required package: abind

    ## Loading required package: sf

    ## Linking to GEOS 3.7.1, GDAL 2.4.2, PROJ 5.2.0

![](README_files/figure-markdown_strict/map-1.png)
