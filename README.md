Steps to use R script in command prompt:

1.Suppose you have the R CMD BATCH installed in the following directory: ‘C:\Program Files\R\R-3.3.2\bin\x64’. Copy this path to your clipboard.

2.Configurations in Computer Settings as:
  a. Windows->Control Panel->System and Secuirity-> System ->Advanced system settings ->Enviroment variables
  
  b. Then click New
  
3.In the field ‘Variable Name:’, type PATH
  In the field ‘Variable Value:’, paste the clipboard value, ie ‘C:\Program Files\R\R-3.3.2\bin\x64’. Add a semicolon ‘;’ after that. 
  So ,click on ‘Ok’ button as many times to dismiss all dialog boxes.
  
4.Open command prompt and type ‘R CMD BATCH’ and press ENTER.

5.Now that you have R CMD BATCH on your path, you can run R code from any directory on your system.

Just repeat step 5 by passing any *.R file as argument with full path and it will execute as expected.

In my case: R CMD BATCH E:\opencode\output\CBR_code.R and hit ENTER

Finally CBR_code.rout file will be stored in E:\opencode\output\ directory. But you can choose any directory based on your preference.
