# Bagged random trees (random forest)
# nodesize=5 model need almost 20 Gb RAM!
# Need c:\DMII\models directory for outputs

#Enviroment
rm(list = ls(all = TRUE)) #CLEAR WORKSPACE
setwd("c:/dmii/data")
#############################
#Load packages
#############################
library('randomForest')

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

Patient2<-Patient[Patient$dmIndicator!=-1,dmii]


# RF1  This need 19 Gb RAM free!!
set.seed(223646)
z1 <- unclass(Sys.time())
rf <- randomForest(Patient2[,3:length(Patient2)], Patient2$dmIndicator, replace=TRUE, ntree=15000, nodesize=5, do.trace=50)
z2 <- unclass(Sys.time())
elapsed.time.minutes <- round((z2 - z1)/ 60,2)  
cat("\n")
cat("elapsed time - ",round(elapsed.time.minutes,2),"minutes","\n")
save(rf,file="c://dmii/models/rf1.RData",compress=TRUE)
pred <- predict(rf, Patient[Patient$dmIndicator==-1,dmii], type="response")
pred<- pmin(1,pred)
pred<- pmax(0,pred)
pred<-cbind(as.character(Patient[Patient$dmIndicator==-1,'PatientGuid']),as.numeric(pred))
colnames(pred) <- c("PatientGuid","rf1") 
write.csv(pred, file="c://dmii/models/rf1.csv", row.names = FALSE) 
cvestim<-cbind(as.character(Patient2$PatientGuid),rf$predicted)
colnames(cvestim)<-c('PatientGuid','rf1')
write.csv(cvestim,file="c://dmii/models/rf1cv.csv", row.names = FALSE)

####### RF5
set.seed(229949)
z1 <- unclass(Sys.time())
rf5 <- randomForest(Patient2[,3:length(Patient2)], Patient2$dmIndicator, replace=TRUE, ntree=30000, nodesize=15, do.trace=50)
z2 <- unclass(Sys.time())
elapsed.time.minutes <- round((z2 - z1)/ 60,2)  
cat("\n")
cat("elapsed time - ",round(elapsed.time.minutes,2),"minutes","\n")
save(rf5,file="c://dmii/models/rf5.RData",compress=TRUE)
pred <- predict(rf5, Patient[Patient$dmIndicator==-1,dmii], type="response")
pred<- pmin(1,pred)
pred<- pmax(0,pred)
pred<-cbind(as.character(Patient[Patient$dmIndicator==-1,'PatientGuid']),as.numeric(pred))
colnames(pred) <- c("PatientGuid","rf5") 
write.csv(pred, file="c://dmii/models/rf5.csv", row.names = FALSE) 
cvestim<-cbind(as.character(Patient2$PatientGuid),rf5$predicted)
colnames(cvestim)<-c('PatientGuid','rf5')
write.csv(cvestim,file="c://dmii/models/rf5cv.csv", row.names = FALSE)

### RF3
set.seed(229949)
z1 <- unclass(Sys.time())
rf3 <- randomForest(Patient2[,3:length(Patient2)], Patient2$dmIndicator, replace=TRUE, ntree=15000, nodesize=40, do.trace=50)
z2 <- unclass(Sys.time())
elapsed.time.minutes <- round((z2 - z1)/ 60,2)  
cat("\n")
cat("elapsed time - ",round(elapsed.time.minutes,2),"minutes","\n")
save(rf3,file="c://dmii/models/rf3.RData",compress=TRUE)
pred <- predict(rf3, Patient[Patient$dmIndicator==-1,dmii], type="response")
pred<- pmin(1,pred)
pred<- pmax(0,pred)
pred<-cbind(as.character(Patient[Patient$dmIndicator==-1,'PatientGuid']),as.numeric(pred))
colnames(pred) <- c("PatientGuid","rf3") 
write.csv(pred, file="c://dmii/models/rf3.csv", row.names = FALSE) 
cvestim<-cbind(as.character(Patient2$PatientGuid),rf3$predicted)
colnames(cvestim)<-c('PatientGuid','rf3')
write.csv(cvestim,file="c://dmii/models/rf3cv.csv", row.names = FALSE)

##RF2
set.seed(229949)
z1 <- unclass(Sys.time())
rf2 <- randomForest(Patient2[,3:length(Patient2)], Patient2$dmIndicator, replace=TRUE, ntree=15000, nodesize=20, do.trace=50)
z2 <- unclass(Sys.time())
elapsed.time.minutes <- round((z2 - z1)/ 60,2)  
cat("\n")
cat("elapsed time - ",round(elapsed.time.minutes,2),"minutes","\n")
save(rf2,file="c://dmii/models/rf2.RData",compress=TRUE)
pred <- predict(rf2, Patient[Patient$dmIndicator==-1,dmii], type="response")
pred<- pmin(1,pred)
pred<- pmax(0,pred)
pred<-cbind(as.character(Patient[Patient$dmIndicator==-1,'PatientGuid']),as.numeric(pred))
colnames(pred) <- c("PatientGuid","rf2") 
write.csv(pred, file="c://dmii/models/rf2.csv", row.names = FALSE) 
cvestim<-cbind(as.character(Patient2$PatientGuid),rf2$predicted)
colnames(cvestim)<-c('PatientGuid','rf2')
write.csv(cvestim,file="c://dmii/models/rf2cv.csv", row.names = FALSE)


