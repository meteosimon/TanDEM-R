\name{download_TanDEM}
\alias{download_TanDEM}
\title{Download TanDEM-X}
\description{A download tool to retrieve TanDEM-X data.}
\usage{
download_TanDEM(lon = c(7, 16), lat = c(45, 49), fact = 5, usr = "", pwd = "",
                return.raster = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{lon}{numeric vector of length two indicating the longitude range.}
  \item{lat}{numeric vector of length two indicating the latitude range.}
  \item{fact}{numeric. Aggregation factor.}
  \item{usr}{character. username.}
  \item{pwd}{character. password.}
  \item{return.raster}{logical. should a raster-object be returned.}
}
\details{
Download of tiles using \code{wget} from https.
}
\value{
A raster object with the merged tiles.
}

\examples{
\dontrun{
require("raster")
x <- download_TanDEM(lon = c(7, 16), lat = c(45, 49), fact = 5, usr = "xxx", pwd = "xxx")
plot(x)
}
}
\keyword{data}
