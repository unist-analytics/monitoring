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
