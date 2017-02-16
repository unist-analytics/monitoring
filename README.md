***Before running a code, be sure that you have installed all related packages.***

list.of.packages <- c("xx", "yy") # replace xx and yy with package names
packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(packages)) install.packages(packages) 
lapply(packages, require, character.only=T)
***The code above is auto-installation of necessary packages.***

1st way:

On MS Windows:
1.Choose Install Packages from the Packages menu.
2.Select a CRAN Mirror. (e.g. Norway)
3.Type in package that you want to installed. (e.g. boot)
4.Then use the library(package) function to load it for use. (e.g. library(boot))

On Linux:
Download the package of interest as a compressed file.
At the command prompt, install it using 
R CMD INSTALL [options] [l-lib] pkgs
Use the library(package) function within R to load it for use in the session.

2nd way:
In console of R you can type in:

install.packages("the package's name that you want to install") Then
library(package's name)


***Recommendation***
I would recommend to open two seperate folders as: input and output folder. In input folder you can store all related data and code to run your script and save outputs(plots,graphs,etc...) in specific output folder. 

***Steps to use R script in command prompt:***
http://shashiasrblog.blogspot.kr/2013/10/vba-front-end-for-r.html Here is a link to set enviromental variables and let command prompt to know the path of R program. 

After you set R program's path -> Open command prompt(find in through windows panel or by run function as "cmd") 

Type "R CMD BATCH + directory where you want to store your rout file + name_of_your.R file and press ENTER. 

For instance: R CMD BATCH "E:/opencode/output/CBR_code.R"

***But be sure that directory where you want to store your file in command propmt is same with directory in R script, otherwise you will get an error.*** 

***you can run R code from any directory of your system.***


