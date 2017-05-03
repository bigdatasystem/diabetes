# Stacking the cv fold predictions of each model usin a generalized additive model (gam) with cubic splines
# Need c:\DMII\models directory for outputs

#Enviroment
rm(list = ls(all = TRUE)) #CLEAR WORKSPACE
setwd("s://datos/dmii/data")
#############################
#Load packages
#############################
library('gam')
Patient<-as.data.frame(read.csv("c://dmii/data/Patient.csv", header=TRUE))
stackdata<-cbind(as.character(Patient$PatientGuid),as.numeric(Patient$dmIndicator))
colnames(stackdata)<-c('PatientGuid','dmIndicator')

#Model A
pred<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_ext.csv", header=TRUE) 
names(pred)[2]<-"gbm10_5_0.0025_0.80_30_tolhalf_ext"
cv<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_ext_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")


#Model F
pred<-read.csv(file="c://dmii/models/gbm10_5_0.003_0.80_30.csv", header=TRUE) 
names(pred)[2]<-"gbm10_5_0.003_0.80_30"
cv<-read.csv(file="c://dmii/models/gbm10_5_0.003_0.80_30_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

 
#Model H
pred<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf.csv", header=TRUE) 
names(pred)[2]<-"gbm10_5_0.0025_0.80_30_tolhalf"
cv<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

 
#Model E
pred<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30.csv", header=TRUE) 
names(pred)[2]<-"gbm10_5_0.0025_0.80_30"
cv<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")


#Model D
pred<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_ext.csv", header=TRUE) 
names(pred)[2]<-"gbm10_5_0.0025_0.80_30_ext"
cv<-read.csv(file="c://dmii/models/gbm10_5_0.0025_0.80_30_ext_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

 
#Model B
pred<-read.csv(file="c://dmii/models/gbm10_5_0.003_0.80_30_tolhalf_ext.csv", header=TRUE) 
names(pred)[2]<-"gbm10_5_0.003_0.80_30_tolhalf_ext"
cv<-read.csv(file="c://dmii/models/gbm10_5_0.003_0.80_30_tolhalf_ext_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

 
#Model 5
pred<-read.csv(file="c://dmii/models/gbm20_5_0.002_0.80_10.csv", header=TRUE) 
names(pred)[2]<-"gbm20_5_0.002_0.80_10"
cv<-read.csv(file="c://dmii/models/gbm20_5_0.002_0.80_10_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#Model 4
pred<-read.csv(file="c://dmii/models/gbm20_5_0.002_0.80_15.csv", header=TRUE) 
names(pred)[2]<-"gbm20_5_0.002_0.80_15"
cv<-read.csv(file="c://dmii/models/gbm20_5_0.002_0.80_15_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#Model 3
pred<-read.csv(file="c://dmii/models/gbm20_6_0.002_0.80_30.csv", header=TRUE) 
names(pred)[2]<-"gbm20_6_0.002_0.80_30"
cv<-read.csv(file="c://dmii/models/gbm20_6_0.002_0.80_30_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#Model 2
pred<-read.csv(file="c://dmii/models/gbm20_5_0.0025_0.80_40.csv", header=TRUE) 
names(pred)[2]<-"gbm20_5_0.0025_0.80_40"
cv<-read.csv(file="c://dmii/models/gbm20_5_0.0025_0.80_40_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#Model 1
pred<-read.csv(file="c://dmii/models/gbm20_5_0.0025_0.80_20.csv", header=TRUE) 
names(pred)[2]<-"gbm20_5_0.0025_0.80_20"
cv<-read.csv(file="c://dmii/models/gbm20_5_0.0025_0.80_20_cvest.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")


#RF1
pred<-read.csv(file="c://dmii/models/rf1.csv", header=TRUE) 
names(pred)[2]<-"rf1"
cv<-read.csv(file="c://dmii/models/rf1cv.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#RF2
pred<-read.csv(file="c://dmii/models/rf2.csv", header=TRUE) 
names(pred)[2]<-"rf2"
cv<-read.csv(file="c://dmii/models/rf2cv.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#RF3
pred<-read.csv(file="c://dmii/models/rf3.csv", header=TRUE) 
names(pred)[2]<-"rf3"
cv<-read.csv(file="c://dmii/models/rf3cv.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")

#RF5
pred<-read.csv(file="c://dmii/models/rf5.csv", header=TRUE) 
names(pred)[2]<-"rf5"
cv<-read.csv(file="c://dmii/models/rf5cv.csv", header=TRUE)
model<-rbind(cv,pred)
stackdata<-merge(stackdata,model,by="PatientGuid")



stacktrain<-stackdata[stackdata$dmIndicator!=-1,]

dmgam<-gam(dmIndicator ~ s(gbm10_5_0.0025_0.80_30_tolhalf_ext,3)
+s(gbm10_5_0.003_0.80_30,3)+s(gbm10_5_0.0025_0.80_30_tolhalf,3)+s(gbm10_5_0.0025_0.80_30,3)+s(gbm10_5_0.0025_0.80_30_ext,3)
+s(gbm10_5_0.003_0.80_30_tolhalf_ext,3)+s(gbm20_6_0.002_0.80_30,3)+s(gbm20_5_0.0025_0.80_40,3)+s(rf1,3)+s(rf2,3)+s(rf3,3)+s(rf5,3),
family = binomial, data=stacktrain, trace=TRUE)

stacktest<-stackdata[stackdata$dmIndicator==-1,]
pred<-predict(dmgam, newdata=stacktest, type="response")
pred<- pmax(0.01,pred)
pred<- pmin(0.98,pred)
sentdata<- cbind(as.character(stacktest$PatientGuid),as.numeric(pred)) 
write.csv(sentdata, file="c://dmii/models/dmpredict.csv", row.names = FALSE) 









