## Create user package library location
vagrantLib <- .Library.site[1]
## select http://cran.stat.auckland.ac.nz for CRAN mirror
chooseCRANmirror(
    ind=which(getCRANmirrors()[,"URL"] == "http://cran.stat.auckland.ac.nz/"))
## selecte CRAN, BioConductor, R-Forge for repos
setRepositories(ind=c(1,2,8))

## install packages from repos
packages <- c("XML", "RCurl", "graph", "RBGL", "Rgraphviz", "gridGraphviz", 
              "devtools")
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
if (!require(conduit)) {
  devtools::install_github("anhinton/conduit", ref="develop", lib=vagrantLib)
}
