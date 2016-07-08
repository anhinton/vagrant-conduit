## Create user package library location
vagrantLib <- .Library.site[1]
## select http://cran.stat.auckland.ac.nz for CRAN mirror
chooseCRANmirror(
    ind = which(getCRANmirrors()[,"URL"] == "https://cloud.r-project.org/"))
## selecte CRAN, BioConductor, R-Forge for repos
setRepositories(ind=c(1,2))

## install packages from repos
packages <- c("XML", "whisker", "rPython", "Rgraphviz", "gridGraphviz",
              "testthat", "devtools")
installIfRequired <- function(pkg) {
    if (!suppressWarnings(require(package=pkg, character.only=TRUE))) {
        install.packages(pkgs=pkg, lib=vagrantLib)
    }
}
for (i in packages) {
    installIfRequired(i)
}

## Install conduit
devtools::install_github("anhinton/conduit@develop", lib=vagrantLib)
