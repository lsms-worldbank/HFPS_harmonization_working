
This package contains Stata syntax to construct an analysis dataset from the High Frequency Phone Survey program. 

The raw data are not included in the package, but are assumed to be downloaded to the user's computer from the Microdata Library. 
https://microdata.worldbank.org/index.php/catalog/?page=1&collection%5B%5D=hfps&ps=15
In the case of Ethiopia Round 15, the syntax currently make use of data that are not publicly available. References to non-public
data will be removed when this is in the public Microdata Library. 
The syntax also makes use of "Round 0" data, which are the LSMS surveys from which the sample frames were construted for the HFPS. 


The Stata syntax are managed by the commander do-file, do_Harmonized HFPS Commander.do. The user who wishes to run the 
entire package should first download the data and then inform Stata about the location of the files. 

Component datasets are stored in a single local storage, with country and in some cases round specific folders. The panel folder contains
panel datasets identified by a universal household id variable, a country code, and a survey round identifier.
The contents of Final Datasets are combined from the contents of the Temporary Datasets folder, and are intended as final versions to 
be used for analysis. 

The repository is titled as working because 
1- Syntax and datasets will be updated as new rounds of the HFPS become publicly available 
2- The content are still under development, and is expected to expand beyond the current scope 
3- Errors or inconsistencies may remain. If you find errors or inconsistencies, please e-mail lsms_hfps@worldbankgroup.org
 
<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->


