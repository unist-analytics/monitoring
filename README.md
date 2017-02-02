Here is code to directly save plot in disk:
"E:/opencode/" is my working directory....

### so the directory of these plots is already set as setwd("E:/opencode/"). setwd("E:/opencode/") is where all of R data files are located
### so by running code below you can save plots in disk. in our case is "E:/opencode/". 

pdf('rplot.pdf')
comparison2=cbind(comparison[,1:2],(comparison[,1]==comparison[,2])+1)
plot(comparison2[,1],ylab="Delay(1) or not(0)",col=3,pch=19)
points(comparison2[,2],col=comparison2[,3],pch=19)
hist(comparison[,3], xlab="The size of similar cases", main="")
dev.off()


Steps to use R script in command prompt:

1.Suppose you have the ‘R.exe’ and ‘RScript.exe’ installed in the following directory: ‘C:\Program Files\R\R-3.3.2\bin\x64’. Copy this path to your clipboard.

2.Configurations in Computer Settings as:
  a. Windows->Control Panel->System and Secuirity-> System ->Advanced system settings ->Enviroment variables
  
  b. Then click New
  
3.In the field ‘Variable Name:’, type PATH
  In the field ‘Variable Value:’, paste the clipboard value, ie ‘C:\Program Files\R\R-3.3.2\bin\x64’. Add a semicolon ‘;’ after that. 
  So ,click on ‘Ok’ button as many times to dismiss all dialog boxes.
  
4.Open command prompt and type ‘Rscript’ and press ENTER.

5.Now that you have Rscript on your path, you can run R code from any directory on your system.

Just repeat step 5 by passing any *.R file as argument with full path and it will execute as expected.

In my case: Rscript E:\opencode\CBR_code.R and hit ENTER
