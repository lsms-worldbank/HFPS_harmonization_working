
This package contains Stata syntax to construct an analysis dataset from the LSMS High Frequency Phone Survey (HFPS) program. 
THe final datasets can be downloaded from Final datasets, where; 
 - HH_ 4 Dec 2024.zip contains the household analysis dataset
 - Ind_ 4 Dec 2024.zip contains the individual level dataset
 - Oth_ 4 Dec 2024.zip contains datasets identified at other levels, mainly items or services

The raw data are not included in the package, but are assumed to be downloaded to the user's computer from the Microdata Library. 
https://microdata.worldbank.org/index.php/catalog/?page=1&collection%5B%5D=hfps&ps=15

In the case of Uganda individual data roster, the syntax currently make use of data that are not publicly available. References to non-public
data will be removed when this is in the public Microdata Library. 
The syntax also makes use of "Round 0" data, which are the LSMS surveys from which the sample frames were construted for the HFPS. 

The Stata syntax are managed by the commander do-file, /Stata syntax/Harmonized HFPS Commander.do. The user who wishes to run the 
entire package should first download the data and then inform Stata about the location of the files. 

Temporary datasets are stored in a local storage folder to be identified by the analyst within the commander do-file. Basic syntax is included therein to construct sub-folders. 

The repository is titled as working because 
1- Syntax and datasets will be updated as new rounds of the HFPS become publicly available 
2- The content are still under development, and is expected to expand beyond the current scope 
3- Errors or inconsistencies may remain. If you find errors or inconsistencies, please e-mail lsms_hfps@worldbankgroup.org
 
<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->


