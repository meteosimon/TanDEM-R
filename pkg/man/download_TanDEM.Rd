\name{download_TanDEM}
\alias{download_TanDEM}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
download_TanDEM(lon = c(7, 16), lat = c(45, 49), fact = 5, usr = "", pwd = "")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{lon}{
%%     ~~Describe \code{lon} here~~
}
  \item{lat}{
%%     ~~Describe \code{lat} here~~
}
  \item{fact}{
%%     ~~Describe \code{fact} here~~
}
  \item{usr}{
%%     ~~Describe \code{usr} here~~
}
  \item{pwd}{
%%     ~~Describe \code{pwd} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (lon = c(7, 16), lat = c(45, 49), fact = 5, usr = "", 
    pwd = "") 
{
    require("raster")
    ll <- expand.grid(min(floor(lon)):max(floor(lon)), min(floor(lat)):max(floor(lat)))
    names(ll) <- c("lon", "lat")
    baseurl <- "download.geoservice.dlr.de/TDM90/files/"
    dir.create("~/tmp/TDM90", showWarnings = FALSE)
    DEM.segments <- list()
    for (i in 1:nrow(ll)) {
        file <- sprintf("TDM1_DEM__30_N\%02dE\%03d", ll$lat[i], 
            ll$lon[i])
        url <- sprintf("\%sN\%02d/E\%03d/", baseurl, ll$lat[i], 
            (ll$lon[i]\%/\%10) * 10)
        if (file.exists(sprintf("~tmp/TDM90/\%s_DEM.tif", file))) 
            next
        download.file(url = sprintf("https://\%s\%s.zip", url, 
            file), destfile = sprintf("~/tmp/TDM90/\%s.zip", file), 
            method = "wget", extra = sprintf("--auth-no-challenge --user=\%s --password=\%s", 
                usr, pwd))
        system(sprintf("cd ~/tmp/TDM90; unzip \%s.zip; rm \%s.zip; cp \%s_V01_C/DEM/\%s_DEM.tif .; rm -r \%s_V01_C/", 
            file, file, file, file, file))
    }
    geoFiles <- list.files("~/tmp/TDM90", ".*(.tif)$")
    DEM <- NULL
    for (file in geoFiles) {
        tmp <- raster(sprintf("~/tmp/TDM90/\%s", file))
        NAvalue(tmp) <- -32767
        tmp <- aggregate(tmp, fact = fact)
        if (is.null(DEM)) {
            DEM <- tmp
            next
        }
        DEM <- merge(DEM, tmp)
    }
    return(DEM)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
