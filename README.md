# gtexture: R Package for the calculation of Haralick texture features for graphs and networks

[![R-CMD-check](https://github.com/rbarkerclarke/gtexture/workflows/R-CMD-check/badge.svg)](https://github.com/rbarkerclarke/gtexture/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CRAN version](http://www.r-pkg.org/badges/version/gtexture)](https://CRAN.R-project.org/package=gtexture)
[![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/gtexture)](https://CRAN.R-project.org/package=gtexture)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Frbarkerclarke%2Fgtexture&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

## Overview

Gray-level co-occurrence matrices (GLCM) have been applied with success in fields such as medical imaging.
However, GLCMs could provide valuable insight when applied to objects other than images.


We believe that the study of fitness landscapes, within the field of evolutionary biology, could benefit from analysis via GLCMs.
To that end, this package generalizes the methodology underlying GLCMs to graph-structured non-imaging data.
The current focus is, as previously mentioned, on application of GLCMs to fitness landscapes. The method is applicable to directed and undirected graphs. 

## Installation

The gtexture R package can be installed as follows:

```r
# install from CRAN (coming soon)
# install.packages("gtexture")

# install using the remotes package
remotes::install_github("rbarkerclarke/gtexture")
```

## Example Usage 

```r
library(gtexture)

# Create adjacency dataframe describing graph 
# This example is a directed graph 
# If the input is undirected, the comatrix will be symmetric

df <- data.frame(from = c("a", "b", "c", "d", "a", "e", "e", "b"), to = c("b", "a", "a", "a", "e", "b", "c", "d"))
g_named = igraph::graph_from_data_frame(df)

# Assign node values
vals_named = 1:5
names(vals_named) = letters[1:5]

# Optional plot igraph object
plot(g_named)

# Get co-occurrence matrix 
comatrix = get_comatrix(g_named, vals_named)

# Compute texture features 
features = gtexture::compute_all_metrics(comatrix)
print(features)
```

## Data Availability 
Data used for the Physics in Medicine and Biology paper (https://iopscience.iop.org/article/10.1088/1361-6560/ace305) was sourced from the Cancer Cell Line Encyclopedia. 
Mahmoud Ghandi, Franklin W. Huang, Judit Jané-Valbuena, Gregory V. Kryukov, ... Todd R. Golub, Levi A. Garraway & William R. Sellers. 2019. Next-generation characterization of the Cancer Cell Line Encyclopedia. Nature 569, 503–508 (2019).

## Citation 

If using this package, please cite the following paper:
> Barker-Clarke R, Weaver DT, Scott JG. Graph 'texture' features as novel metrics that can summarize complex biological graphs. Phys Med Biol. 2023 Aug 22;68(17):174001. doi: 10.1088/1361-6560/ace305. PMID: 37385267; PMCID: PMC10598684.
