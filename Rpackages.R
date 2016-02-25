## Create user package library location
vagrantLib <- .Library.site[1]
## select http://cran.stat.auckland.ac.nz for CRAN mirror
chooseCRANmirror(
    ind=which(getCRANmirrors()[,"URL"] == "https://cran.stat.auckland.ac.nz/"))
## selecte CRAN, BioConductor, R-Forge for repos
setRepositories(ind=c(1,2))

## install packages from repos
packages <- c("RCurl", "XML", "graph", "RBGL", "Rgraphviz", "gridGraphviz",
              "testthat", "devtools")
installIfRequired <- function(pkg) {
    if (!require(package=pkg, character.only=TRUE)) {
        install.packages(pkgs=pkg, lib=vagrantLib)
    }
}
for (i in packages) {
    installIfRequired(i)
}

## Install conduit
devtools::install_github("anhinton/conduit", lib=vagrantLib)
