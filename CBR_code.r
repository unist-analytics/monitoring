####################### set up working directory  ##################################################

#setwd("/Users/sungilkim/Dropbox/CBR/JORS/revision/R_code")
setwd("E:/opencode/") # by using setwd we have to direct the location of our data


######################## read training and testing dataset #########################################


training=read.csv("training_98473.csv", header=T)
testing=read.csv("testing_98473.csv", header=T)
names(training)[2]="POL_ETD"
names(testing)[2]="POL_ETD"

#check_list=c("ACT_ROUTE_ID","ARRIVAL_PORT","CARR_ID","CNEE_ID","FINAL_DEST","LANE_ID","LSP_ID","LOADING_PORT","SHPR_PLANT_CD","ITEM_CD")

############################ Feature Selection using RPART #########################################

library(rpart) #here rpart library is opended as a function to run a code continuously, instead of writing code for each case separetely
#rpart used to recursive partioning for CART algorithm

library(partykit) #this library is used for visualization as graphs, histograms and etc...

#training=read.csv("training_98473.csv", header=T)
#names(training)[2]="POL_ETD"

#both of these libraries are used to select important features before the departure of vessel for detection of delay

#If you want to add additional features, add them to training and testing dataset
POL_D=as.numeric(as.Date(training$POL_ETD)<as.Date(training$POL_ATD))
num.stopby=
  as.numeric(training$X3RD_TS_LOC!="NULL")*3+
  as.numeric((training$X3RD_TS_LOC=="NULL")&(training$X2ND_TS_LOC!="NULL"))*2+
  as.numeric((training$X3RD_TS_LOC=="NULL")&(training$X2ND_TS_LOC=="NULL")&(training$X1ST_TS_LOC!="NULL"))*1+
  as.numeric((training$X3RD_TS_LOC=="NULL")&(training$X2ND_TS_LOC=="NULL")&(training$X1ST_TS_LOC=="NULL"))*0


training=cbind(training,POL_D,num.stopby)

## This is all features after removing unrelated time-related features. We will select among them. ###

features=c("ACT_ROUTE_ID","ARRIVAL_PORT","CARR_ID","CNEE_ID","FINAL_DEST","LANE_ID","LSP_ID","LOADING_PORT","SHPR_PLANT_CD"
             ,"X1ST_TS_LOC"
             ,"X2ND_TS_LOC"
             ,"X3RD_TS_LOC"
             ,"BOD_ID"
             ,"CORP_ID"
             ,"DIR_PRGS_YN"
             ,"FI_PAY_COND_CD"
             ,"INCO_CD"
             ,"POD_LOC"
             ,"SHPR_ID"
             ,"SHPR_PLANT_CD"
             ,"VESSLE_NAME"
             ,"VOYAGE_NO"
             ,"ITEM_CD","POL_D","num.stopby")

y=as.numeric(as.Date(training$BL_LAST_ETA_DATETIME) < as.Date(training$POD_ATA))
training_y=cbind(training[,features],y)
fit <- rpart(y ~ ., data = training_y,parms=list(split='information'))


check_list=names(fit$variable.importance)
#check_list=c("VOYAGE_NO","ITEM_CD","ACT_ROUTE_ID", "BOD_ID" ,"VESSLE_NAME","LANE_ID", "CNEE_ID","FINAL_DEST","LSP_ID","CARR_ID")


#party.fit <- as.party(fit)
#plot(party.fit, type='extended')



######################################################################


comparison=c()

for(j in 1:nrow(testing)){

	values=as.matrix(testing[j,check_list])  # new case feature values
	similar_cases=training_y

	for(i in 1:length(values)){
		if(sum(similar_cases[,check_list[i]]==values[i])>0){             # The size of similar cases should be >0 
		  similar_cases=similar_cases[similar_cases[,check_list[i]]==values[i],]  # similar cases
		}
	}

	prob_delay=sum(similar_cases$y==1)/nrow(similar_cases)  ## calculate probability of delay
	testing_delay=as.numeric(as.Date(testing[j,"BL_LAST_ETA_DATETIME"]) < as.Date(testing[j,"POD_ATA"])) # delay or not from testing dataset, delay ==> 1

	pred_s_or_f=as.numeric(prob_delay>0.5)  # 0 or 1
	
  # This is for comparison as the thresholds
	experiments=c()
	for(thresholds in seq(0.2,0.8,0.05)){
		experiments=c(experiments,as.numeric(prob_delay>thresholds))
	}
	comparison=rbind(comparison,c(pred_s_or_f,testing_delay,nrow(similar_cases),experiments))
}

comparison[,1:3]
pred_s_or_f
s_or_f
# aa=training[rownames(training_y)%in%rownames(extract),] # for tracking analysis
#xx=as.Date(aa$POD_ATA)-as.Date(aa$POL_ATD)
#plot(xx~extract$y)
#temp=data.frame(cbind(xx,extract$y))
#names(temp)=c("LT","Delay")
#temp[order(xx),]

comparison=comparison[!is.na(comparison[,1]),]
accuracy=sum(comparison[,1]==comparison[,2])/nrow(comparison)
accuracy

one_one=sum((comparison[,1]==1)&(comparison[,2]==1))/sum(comparison[,2]==1)  ### P( pred=1 | true is 1)
zero_zero=sum((comparison[,1]==0)&(comparison[,2]==0))/sum(comparison[,2]==0)  ### P( pred=0 | true is 0)
type2=sum(comparison[,1]<comparison[,2])/nrow(comparison)
type1=sum(comparison[,1]>comparison[,2])/nrow(comparison)

#visualization
comparison2=cbind(comparison[,1:2],(comparison[,1]==comparison[,2])+1)
plot(comparison2[,1],ylab="Delay(1) or not(0)",col=3,pch=19)
points(comparison2[,2],col=comparison2[,3],pch=19)

hist(comparison[,3], xlab="The size of similar cases", main="")

#### adjust parameter

seq(0.2,0.8,0.05)
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

plot(adjust_result[,6],adjust_result[,1],lwd=2,type="l", ylim=c(0,1),xlab="Parameter", ylab="Accuracy")
lines(adjust_result[,6],adjust_result[,2],lwd=2,col=2)
lines(adjust_result[,6],adjust_result[,3],lwd=2,col=3,lty=2)
lines(adjust_result[,6],adjust_result[,4],lwd=2,col=4,lty=3)
lines(adjust_result[,6],adjust_result[,5],lwd=2,col=5,lty=4)

legend(0.65, 0.8, c("Accuracy", "Type I", "Type II", "P(F=1|A=1)","P(F=0|A=0)"), col = c(1:5),
        lwd = c(2,2,2,2,2), lty = c(1,1,2,3,4),box.col="white"
       , bg = "gray90")






############################ Feature Selection using similarity score##############################
library(plyr)

y=as.numeric(as.Date(training$BL_LAST_ETA_DATETIME) < as.Date(training$POD_ATA))

#additional features
POL_D=as.numeric(as.Date(training$POL_ETD)<as.Date(training$POL_ATD))
num.stopby=
  as.numeric(training$X3RD_TS_LOC!="NULL")*3+
  as.numeric((training$X3RD_TS_LOC=="NULL")&(training$X2ND_TS_LOC!="NULL"))*2+
  as.numeric((training$X3RD_TS_LOC=="NULL")&(training$X2ND_TS_LOC=="NULL")&(training$X1ST_TS_LOC!="NULL"))*1+
  as.numeric((training$X3RD_TS_LOC=="NULL")&(training$X2ND_TS_LOC=="NULL")&(training$X1ST_TS_LOC=="NULL"))*0


training=cbind(training,POL_D,num.stopby)
training_y=cbind(training,y)

POL_D_v=as.numeric(as.Date(testing$POL_ETD)<as.Date(testing$POL_ATD))
num.stopby_v=
  as.numeric(testing$X3RD_TS_LOC!="NULL")*3+
  as.numeric((testing$X3RD_TS_LOC=="NULL")&(testing$X2ND_TS_LOC!="NULL"))*2+
  as.numeric((testing$X3RD_TS_LOC=="NULL")&(testing$X2ND_TS_LOC=="NULL")&(testing$X1ST_TS_LOC!="NULL"))*1+
  as.numeric((testing$X3RD_TS_LOC=="NULL")&(testing$X2ND_TS_LOC=="NULL")&(testing$X1ST_TS_LOC=="NULL"))*0

testing=cbind(testing,POL_D=POL_D_v,num.stopby=num.stopby_v)



features=names(training)

similarity=function(dat){
  y=dat$y
  abs(sum(y==1)-sum(y==0))/length(y)
  #max(sum(y==1),sum(y==0))/length(y)
}

#unique(training[,features[16]])
res=c()
for (m in 1:length(features)){
  if((length(unique(training[,features[m]]))<100)&(length(unique(training[,features[m]]))>1)){
    temp=ddply(training_y, features[m], c(similarity,nrow))		
    res=rbind(res,c(features[m],temp$V1%*%(temp$V2/sum(temp$V2))))
  }
}
features_ordered=res[order(res[,2],decreasing = T),]
check_list=features_ordered[1:15,1]





