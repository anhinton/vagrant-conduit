## Create user package library location
vagrantLib <- .Library.site[1]
## select http://cran.stat.auckland.ac.nz for CRAN mirror
chooseCRANmirror(
    ind=which(getCRANmirrors()[,"URL"] == "http://cran.stat.auckland.ac.nz/"))
## selecte CRAN, BioConductor, R-Forge for repos
setRepositories(ind=c(1,2,8))

## install packages from repos
packages <- c("RCurl", "XML", "graph", "RBGL", "Rgraphviz", "gridGraphviz", 
              "devtools", "R2HTML", "ggplot2", "data.table", "git2r",
              "lattice", "classInt")
installIfRequired <- function(pkg) {
    if (!require(package=pkg, character.only=TRUE)) {
        install.packages(pkgs=pkg, lib=vagrantLib)
    }
}
for (i in packages) {
    installIfRequired(i)
}
while (!require("gridGraphviz")) {
  install.packages("gridGraphviz", lib=vagrantLib)
}

## Install conduit
devtools::install_github("anhinton/conduit", ref="develop", lib=vagrantLib)
