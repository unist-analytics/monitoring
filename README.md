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

seq(0.2,0.8,0.05)# this code is proceeded in the same way as done above. 
adjust_result=c()
for(k in c(4:16)){ 
  accuracy=sum(comparison[,k]==comparison[,2])/nrow(comparison)
  type2=sum(comparison[,k]<comparison[,2])/nrow(comparison)
  type1=sum(comparison[,k]>comparison[,2])/nrow(comparison)
  one_one=sum((comparison[,k]==1)&(comparison[,2]==1))/sum(comparison[,2]==1)  ### P( pred=1 | true is 1)
  zero_zero=sum((comparison[,k]==0)&(comparison[,2]==0))/sum(comparison[,2]==0)  ### P( pred=0 | true is 0)
  adjust_result=rbind(adjust_result,c(accuracy,type1,type2,one_one,zero_zero))
}
adjust_result=cbind(adjust_result,seq(0.2,0.8,0.05))
png('rplot.png') # Here it is extraction of image to directly to the disk as an png file.
plot(adjust_result[,6],adjust_result[,1],lwd=2,type="l", ylim=c(0,1),xlab="Parameter", ylab="Accuracy")
lines(adjust_result[,6],adjust_result[,2],lwd=2,col=2)
lines(adjust_result[,6],adjust_result[,3],lwd=2,col=3,lty=2)
lines(adjust_result[,6],adjust_result[,4],lwd=2,col=4,lty=3)
lines(adjust_result[,6],adjust_result[,5],lwd=2,col=5,lty=4)
legend(0.65, 0.8, c("Accuracy", "Type I", "Type II", "P(F=1|A=1)","P(F=0|A=0)"), col = c(1:5),
       lwd = c(2,2,2,2,2), lty = c(1,1,2,3,4),box.col="white"
       , bg = "gray90")
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
