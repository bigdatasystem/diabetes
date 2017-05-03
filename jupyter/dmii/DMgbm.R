# Fit boosting regression trees (gbm) with differents parameters
# dismo is used as wrapper for cv control
# Need c:\DMII\models directory for outputs

#Enviroment
rm(list = ls(all = TRUE)) #CLEAR WORKSPACE
setwd("c:/dmii/data")
#############################
#Load packages
#############################
library('gbm')
library('dismo')
source('c://dmii/gbm.utils.R')
source('c://dmii/gbm.step.R')
Patient<-as.data.frame(read.csv("c://dmii/data/Patient.csv", header=TRUE))

### data subset
dmii<-c('PatientGuid','dmIndicator','Gender','L2_AtherosclerosisCoronary','L2_AtherosclerosisPeripheral',
'L2_BoneDeformity','L1_Prostate','L2_CardiacInsufficiency','L2_Cellulitis','L2_CerebroVascular',
'L2_ChronicRenalFailure','L2_Constipation','L2_COPD','L2_Dermatitis','L2_Diarrhea','L2_DMRelated',
'L2_DMRelated2','L2_Dysrhythmia','L2_Edema','L2_EKGAbnormal','L2_FamilyDM','L2_GlucoseAbnormal','L2_Gout',
'L2_Hearing','L2_HerpesZoster','L2_Hypercholesterolemia','L2_Hypertriglyceridemia','L2_Hyperkalemia',
'L2_HyperlipOther','L2_HypertensionComp','L2_HypertensionEssential','L2_Hypoglycemia',
'L2_ImpGlucoseAbnormal','L2_Impotence','L2_IntestinalInfection','L2_IrritableBowel',
'L2_Migraine','L2_MixedHyperlipidemia','L2_MenstruationDisorder','L2_MycosisFoot','L2_NervousSystem',
'L1_NervousSystemOther','L2_NeurRadiculitis','L2_Obesity','L2_Osteoarthrosis','L2_Osteoporosis',
'L2_PeriphNeuropathy','L2_Proteinuria','L2_GallBladder','L2_Renal','L2_RespiratoryFail','L1_RespInfec',
'L2_SexDysfunction','L2_SkinSense','L1_Skin','L2_SleepApnea','L2_Anxiety',
'L2_UrinaryIncontinency','L1_Back','L2_Malaise','L2_PainJoint','L2_DeficiencyAnemia','L2_TesticularDysfunction',
'L2_Ulcer','L2_Vaccine','L2_VascularPeripheral','L2_VitaminD','L2_VitaminB','L2_Cough','L2_Esophagus',
'L2_VertiginousSyndromes','L2_Dyspnea','loopdiuretic_bin','antiplatelet_bin','benzodiazepine_bin',
'fibrate_npr','gastroparesia_bin','antilipid_bin','osteoporosis_bin','glucocorticoid_general_bin',
'inhalation_npr', 'thiazide_bin','LtypeCaChB_npr','amlodipine_dose','ACEI_dose','lisinopril_dose','ACEI_bin',
'aspirin_npr','AIIRA_npr','losartan_telmisartan_dose','olmesartan_dose','statin_dose_adjusted','statin_nap',
'betablocker_bin','atenolol_dose','carvedilol_dose',
'YearOfBirth','Weighted','BMIMaxT','RangeBMI','WeightMedian','DiastolicBPMedian','SystolicBPMaxT',
'HeightMedian','RespiratoryRateMedian','TemperatureMedian',
'InternalMedicine','CardiovascularDisease','FamilyPractice','GeneralPractice','Podiatry',
'VisitYearBlank','NumPhysicians',
'TotDiagWYear','VisitPerWYear2Date','MaxVisitWYear','MinVisit2Date', 
'DiffLevel2Diag','Tot3digitICD9','TotDiagPerVisit','VisitTotal','TotDiag','DiffDMOtherRelatedSymptoms',
'prescripts','medication_wo_prescript','HasLabWithNA','HasLab','PrevSmoker','active_principle','nomedication',
'medication_diag_NA','diag_3digit_with_medication',
'STATE_CA','STATE_TX','STATE_NY')

### data subset (don't big impruve over general subset & overfit risk)
exten<-c('DiastolicBPMaxT','RespiratoryRateMaxT','TemperatureRank2th','HighLowBP','BMIMedian','SystolicBPMedian')

Patient2<-Patient[Patient$dmIndicator!=-1,dmii]

#Model F
set.seed(223646)
gbm10_5_0.003_0.80_30<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=10,n.trees=50, learning.rate=0.003,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.001,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm10_5_0.003_0.80_30,file="c://dmii/models/gbm10_5_0.003_0.80_30.RData",compress=TRUE)
pred<-predict.gbm(gbm10_5_0.003_0.80_30,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm10_5_0.003_0.80_30$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm10_5_0.003_0.80_30.csv", row.names = FALSE) 
save(gbm10_5_0.003_0.80_30,file="c://dmii/models/gbm10_5_0.003_0.80_30.RData",compress=TRUE)
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm10_5_0.003_0.80_30$fold.fit)/(1+exp(gbm10_5_0.003_0.80_30$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm10_5_0.003_0.80_30')
write.csv(cvestim,file="c://dmii/models/gbm10_5_0.003_0.80_30_cvest.csv", row.names = FALSE)

#  Model 5
set.seed(223646)
gbm20_5_0.002_0.80_10<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=20,n.trees=50, learning.rate=0.002,bag.fraction=0.80,n.minobsinnode=15,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm20_5_0.002_0.80_10,file="c://dmii/models/gbm20_5_0.002_0.80_10.RData",compress=TRUE)
pred<-predict.gbm(gbm20_5_0.002_0.80_10,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm20_5_0.002_0.80_10$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm20_5_0.002_0.80_10.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm20_5_0.002_0.80_10$fold.fit)/(1+exp(gbm20_5_0.002_0.80_10$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm20_5_0.002_0.80_10')
write.csv(cvestim,file="c://dmii/models/gbm20_5_0.002_0.80_10_cvest.csv", row.names = FALSE)

#  Model 4
set.seed(223646)
gbm20_5_0.002_0.80_15<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=20,n.trees=50, learning.rate=0.002,bag.fraction=0.80,n.minobsinnode=15,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm20_5_0.002_0.80_15,file="c://dmii/models/gbm20_5_0.002_0.80_15.RData",compress=TRUE)
pred<-predict.gbm(gbm20_5_0.002_0.80_15,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm20_5_0.002_0.80_15$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm20_5_0.002_0.80_15.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm20_5_0.002_0.80_15$fold.fit)/(1+exp(gbm20_5_0.002_0.80_15$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm20_5_0.002_0.80_15')
write.csv(cvestim,file="c://dmii/models/gbm20_5_0.002_0.80_15_cvest.csv", row.names = FALSE)

#  Model 3
set.seed(223646)
gbm20_6_0.002_0.80_30<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=6,
n.folds=20,n.trees=50, learning.rate=0.002,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm20_6_0.002_0.80_30,file="c://dmii/models/gbm20_6_0.002_0.80_30.RData",compress=TRUE)
pred<-predict.gbm(gbm20_6_0.002_0.80_30,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm20_6_0.002_0.80_30$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm20_6_0.002_0.80_30.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm20_6_0.002_0.80_30$fold.fit)/(1+exp(gbm20_6_0.002_0.80_30$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm20_6_0.002_0.80_30')
write.csv(cvestim,file="c://dmii/models/gbm20_6_0.002_0.80_30_cvest.csv", row.names = FALSE)

#  Model 2
set.seed(223646)
gbm20_5_0.0025_0.80_40<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=20,n.trees=50, learning.rate=0.0025,bag.fraction=0.80,n.minobsinnode=40,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm20_5_0.0025_0.80_40,file="c://dmii/models/gbm20_5_0.0025_0.80_40.RData",compress=TRUE)
pred<-predict.gbm(gbm20_5_0.0025_0.80_40,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm20_5_0.0025_0.80_40$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm20_5_0.0025_0.80_40.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm20_5_0.0025_0.80_40$fold.fit)/(1+exp(gbm20_5_0.0025_0.80_40$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm20_5_0.0025_0.80_40')
write.csv(cvestim,file="c://dmii/models/gbm20_5_0.0025_0.80_40_cvest.csv", row.names = FALSE)

#  Model 1
set.seed(223646)
gbm20_5_0.0025_0.80_20<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=20,n.trees=50, learning.rate=0.0025,bag.fraction=0.80,n.minobsinnode=20,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm20_5_0.0025_0.80_20,file="c://dmii/models/gbm20_5_0.0025_0.80_20.RData",compress=TRUE)
pred<-predict.gbm(gbm20_5_0.0025_0.80_20,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm20_5_0.0025_0.80_20$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm20_5_0.0025_0.80_20.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm20_5_0.0025_0.80_20$fold.fit)/(1+exp(gbm20_5_0.0025_0.80_20$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm20_5_0.0025_0.80_20')
write.csv(cvestim,file="c://dmii/models/gbm20_5_0.0025_0.80_20_cvest.csv", row.names = FALSE)
 
#Model H
set.seed(223646)
gbm10_5_0.0025_0.80_30_tolhalf<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=10,n.trees=50, learning.rate=0.0025,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm10_5_0.0025_0.80_30_tolhalf,file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf.RData",compress=TRUE)
pred<-predict.gbm(gbm10_5_0.0025_0.80_30_tolhalf,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm10_5_0.0025_0.80_30_tolhalf$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf.csv", row.names = FALSE) 
save(gbm10_5_0.0025_0.80_30_tolhalf,file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf.RData",compress=TRUE)
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm10_5_0.0025_0.80_30_tolhalf$fold.fit)/(1+exp(gbm10_5_0.0025_0.80_30_tolhalf$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm10_5_0.0025_0.80_30_tolhalf')
write.csv(cvestim,file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_cvest.csv", row.names = FALSE)

#Model E
set.seed(223646)
gbm10_5_0.0025_0.80_30<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=10,n.trees=50, learning.rate=0.0025,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.001,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm10_5_0.0025_0.80_30,file="c://dmii/models/gbm10_5_0.0025_0.80_30.RData",compress=TRUE)
pred<-predict.gbm(gbm10_5_0.0025_0.80_30,Patient[Patient$dmIndicator==-1,dmii],n.trees=gbm10_5_0.0025_0.80_30$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm10_5_0.0025_0.80_30.csv", row.names = FALSE) 
save(gbm10_5_0.0025_0.80_30,file="c://dmii/models/gbm10_5_0.0025_0.80_30.RData",compress=TRUE)
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm10_5_0.0025_0.80_30$fold.fit)/(1+exp(gbm10_5_0.0025_0.80_30$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm10_5_0.0025_0.80_30')
write.csv(cvestim,file="c://dmii/models/gbm10_5_0.0025_0.80_30_cvest.csv", row.names = FALSE)

### Models with a few more features (really not necesaries)

Patient2<-Patient[Patient$dmIndicator!=-1,c(dmii,exten)]

#Model A
set.seed(223646)
gbm10_5_0.0025_0.80_30_tolhalf_ext<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=10,n.trees=50, learning.rate=0.0025,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm10_5_0.0025_0.80_30_tolhalf_ext,file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_ext.RData",compress=TRUE)
pred<-predict.gbm(gbm10_5_0.0025_0.80_30_tolhalf_ext,Patient[Patient$dmIndicator==-1,c(dmii,exten)],n.trees=gbm10_5_0.0025_0.80_30_tolhalf_ext$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_ext.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm10_5_0.0025_0.80_30_tolhalf_ext$fold.fit)/(1+exp(gbm10_5_0.0025_0.80_30_tolhalf_ext$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm10_5_0.0025_0.80_30_tolhalf_ext')
write.csv(cvestim,file="c://dmii/models/gbm10_5_0.0025_0.80_30_tolhalf_ext_cvest.csv", row.names = FALSE)

#Model D
set.seed(223646)
gbm10_5_0.0025_0.80_30_ext<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=10,n.trees=50, learning.rate=0.0025,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.001,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm10_5_0.0025_0.80_30_ext,file="c://dmii/models/gbm10_5_0.0025_0.80_30_ext.RData",compress=TRUE)
pred<-predict.gbm(gbm10_5_0.0025_0.80_30_ext,Patient[Patient$dmIndicator==-1,c(dmii,exten)],n.trees=gbm10_5_0.0025_0.80_30_ext$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm10_5_0.0025_0.80_30_ext.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm10_5_0.0025_0.80_30_ext$fold.fit)/(1+exp(gbm10_5_0.0025_0.80_30_ext$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm10_5_0.0025_0.80_30_ext')
write.csv(cvestim,file="c://dmii/models/gbm10_5_0.0025_0.80_30_ext_cvest.csv", row.names = FALSE)
 
#Model B
set.seed(223646)
gbm10_5_0.003_0.80_30_tolhalf_ext<-gbm.step(Patient2,gbm.x=c(3:ncol(Patient2)),gbm.y=2,
tree.complexity=5,
n.folds=10,n.trees=50, learning.rate=0.003,bag.fraction=0.80,n.minobsinnode=30,tolerance = 0.0005,
family="bernoulli",max.trees=30000,keep.fold.models = TRUE, keep.fold.vector = TRUE, keep.fold.fit=TRUE)
save(gbm10_5_0.003_0.80_30_tolhalf_ext,file="c://dmii/models/gbm10_5_0.003_0.80_30_tolhalf_ext.RData",compress=TRUE)
pred<-predict.gbm(gbm10_5_0.003_0.80_30_tolhalf_ext,Patient[Patient$dmIndicator==-1,c(dmii,exten)],n.trees=gbm10_5_0.003_0.80_30_tolhalf_ext$gbm.call$best.trees,type="response")
sentdata<- cbind(as.character(Patient$PatientGuid[Patient$dmIndicator==-1]),as.numeric(pred)) 
colnames(sentdata)<-c('PatientGuid','dmIndicator')
write.csv(sentdata, file="c://dmii/models/gbm10_5_0.003_0.80_30_tolhalf_ext.csv", row.names = FALSE) 
## cv fold predictions set for stacking models
cvestim<-cbind(as.character(Patient2$PatientGuid),exp(gbm10_5_0.003_0.80_30_tolhalf_ext$fold.fit)/(1+exp(gbm10_5_0.003_0.80_30_tolhalf_ext$fold.fit)))
colnames(cvestim)<-c('PatientGuid','gbm10_5_0.003_0.80_30_tolhalf_ext')
write.csv(cvestim,file="c://dmii/models/gbm10_5_0.003_0.80_30_tolhalf_ext_cvest.csv", row.names = FALSE)






