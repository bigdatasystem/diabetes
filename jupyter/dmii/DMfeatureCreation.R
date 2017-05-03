# Data cleaning & Featured creation
# Assume SQlite compData.db database in C:\DMII\data
# Assume files icd9.csv and drugsap.csv in same location

#Enviroment
rm(list = ls(all = TRUE)) #CLEAR WORKSPACE
setwd("c://dmii/data")
############################
#Train and test sets
############################
library(RSQLite)
n <- dbDriver("SQLite", max.con=25)
con <- dbConnect(n, dbname="compData.db")
dbListTables(con)
# Patients. Training & test in a file, dmIndicator for test data
trainingPatient<-dbGetQuery(con, "SELECT * FROM training_patient")
testPatient<-dbGetQuery(con, "SELECT * FROM test_patient")
testPatient$dmIndicator<--1
# reorder dmIndicator field
testPatient<-testPatient[,c(1,6,2:5)]
# Drop ficticie patient (11,22,33,44,55,66 values...)
trainingPatient<-trainingPatient[trainingPatient$PatientGuid!='498421C5-3895-47FC-9312-0EF9B85ED820',]
Patient<-rbind(trainingPatient,testPatient)
rm("testPatient","trainingPatient")
Patient$Gender<-as.factor(Patient$Gender)

# Transcripts
trainingTranscript<-dbGetQuery(con, "SELECT * FROM training_transcript")
testTranscript<-dbGetQuery(con, "SELECT * FROM test_transcript")
Transcript<-rbind(trainingTranscript[-1,],testTranscript[-1,]) # Drop duplicate header in rec 1
rm("trainingTranscript","testTranscript")
Transcript$Height<-as.numeric(Transcript$Height)
Transcript$Weight<-as.numeric(Transcript$Weight)
# underweight valid patients (valid weight <85) 
underweight<-c('3C8D1326-7D79-4350-89D8-1271A34C62E3','3066A99F-3B26-44A3-95C3-349FCCEB303B','3E917FBC-C42E-4948-A834-EA999131D1A0'
,'812E6BE3-BDBB-4FD2-AA86-7E4FCEA33431','8B6688AB-E183-4C32-8FE6-29B9D8865687','A71E42F0-385F-4102-BE27-FB55ED06D3AE'
,'D70EDC3E-24D7-44E7-993A-501D620E999A','D70EDC3E-24D7-44E7-993A-501D620E999A','BB0CC274-240A-4C02-A764-5070CC514A87'
,'D0703010-9CF8-426C-BD1B-61E8C53D0338','096AA3A2-3306-4F9A-9082-6B479C2BB5AA','148B6713-1D0D-4DE4-8EE5-E6D7988088ED')
# overweight valid patients (valid weight >320)
overweight<-c('04477471-FAFE-45AE-9EF8-6EC94B94789C','0D3EF269-0675-444A-9F45-6FBCF2046CCD','100ECEEB-8759-4D59-AC23-A86697DD4113'
,'10AA6386-B0A5-4F6B-B495-DBC588042E4D','17DCFE68-7A86-473C-A589-11B0FC256BA2','1B0556CF-72DF-480E-8429-DF61C252F16F'
,'25B9E447-F7E3-479C-8B72-E6D76CA3182D','2A767E8A-1E47-4555-B11A-8A507B48DD64','2C2F654C-FC57-4E06-9E41-9AEE559A7D6E'
,'2CC737E9-98B8-48FE-A744-F75770C59218','2EDC74B4-360A-4114-AB6C-BF0689AF2C70','3F8A2228-0DF3-4FAF-8C26-F04A9DD14C36'
,'50BABFE9-D522-425D-86A0-170300961A46','53C120E7-11B2-40F2-AC09-DA209DFA2CBE','5883AF5C-513F-4F2A-B204-762AAF6963E6'
,'61B927CE-1EB3-4464-B843-4BA4943BA027','71047BE4-1639-4F34-8BE9-5AA89281F9C7','763112F7-6F43-43D7-B745-75C0506E4197'
,'7CA6C507-CCA6-4CF2-880E-F11EBECAD928','7E3B9F76-C55F-46B9-897D-E5C4DB645CF0','83190041-69EC-4D8C-8486-DF5C99CB1844'
,'87F932AE-370E-49B8-8B77-EE866EB04267','91A9EECB-093F-4DA7-9F18-4C803E5F94B4','92626713-16CE-4473-8523-ADCDB86A7DC8'
,'A1E6ED8A-68AC-45F1-B622-28833D2ECC37','A42807AE-854E-409B-83E0-6B2389E4DE44','A53C6FBB-730C-4F4C-A128-6B5F3120BCE1'
,'A58157C4-5555-4014-BDFF-14AD3AFA986C','A6FDED95-2D3B-4862-BB6A-B8F4B2CCECD3','B5C1DC45-8EAD-4A7A-A25B-36A788B7E64E'
,'B8D94CCF-43D6-4199-825B-F8A84C0740CA','BC3B4037-0CF1-44C1-9B7B-FB7C730D8FD5','BD123C62-25C7-47B9-85FC-45A556D2A7A5'
,'BD1D634A-067A-4155-AFF7-3BBDF8E68855','C3C41DFF-55D9-43D1-B593-4F5B2386D2AE','C85A8A29-9C32-4B1A-B97A-40DFA987EB09'
,'CA79D067-6078-4B90-B1A3-69F16BF9F656','CA9122C2-6D3B-4B48-B590-310A710A296D','CEBDBE8D-D5B6-467C-B81C-ABE89662E93F'
,'DBF6CA23-2D88-4F78-8B07-B47DA0F98739','E3AF0E14-BB38-4CB8-A84D-B481DFA63A08','E5EE9D7F-5EC3-4F08-BCD6-9A18B09D9424'
,'E9144A10-B708-4574-A30E-696C4E87A5D8','EC172DF9-D1D3-40D8-BB21-EB609CED6773','ECC920FD-BC34-4C45-A596-DF1663623FBD'
,'EEFDF4F3-902B-47E6-84DA-D7FF75DC8F86','EF3B9DD0-2FA4-497A-BCCA-51542F629C03','F0671838-3A3F-4C87-AEA2-6E4CEF20E740'
,'F4C3CE61-31A1-4B24-AEEA-FE17589A83D5','F5B330EC-6D0F-4F3A-B914-41FB43ED3BE3','F7B549C9-74CC-4EE2-A45E-C338A4B280B3'
,'FA42AB14-FD6F-4CD6-859D-B584A3D45D4D')

# Clean weight & height outliers. NA for unknown, 0 for typo error
Transcript$Weight[Transcript$Weight==0]<-NA
Transcript$Weight[Transcript$Weight < 85 & !(Transcript$PatientGuid %in% underweight)]<-0
Transcript$Weight[Transcript$Weight > 320 & !(Transcript$PatientGuid %in% overweight) ]<-0
Transcript$Height[Transcript$Height < 44] <-0
Transcript$Height[Transcript$Height > 79] <-0

# Weight & Height Median 
# Exclude only weight error transcripts in height median computing (include NA). 
# A record with weigth error probably has height error.
HeightMedian<-aggregate(cbind(Height)~PatientGuid, data=Transcript[(is.na(Transcript$Weight) | Transcript$Weight!=0) & Transcript$Height!=0,], function(x) median(x))
names(HeightMedian) <- c('PatientGuid','HeightMedian')
Transcript<- merge(Transcript,HeightMedian,by="PatientGuid",all.x=TRUE)
Patient <- merge(Patient,HeightMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Exclude only height error transcripts in weight median computing (include NA).
# A record with heigth error probably has weight error.
WeightMedian<-aggregate(cbind(Weight)~PatientGuid, data=Transcript[(is.na(Transcript$Height) | Transcript$Height!=0) & Transcript$Weight!=0,], function(x) median(x))
names(WeightMedian) <- c('PatientGuid','WeightMedian')
Transcript<- merge(Transcript,WeightMedian,by="PatientGuid",all.x=TRUE)
Patient <- merge(Patient,WeightMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Clean weights outside [0.8*WeightMedian , 1.20*WeightMedian] (typo errors)
Transcript$Weight[Transcript$Weight < 0.8*Transcript$WeightMedian | Transcript$Weight > 1.2*Transcript$WeightMedian]<-0

# Recalculate BMI with Height Median
Transcript$BMIc<-703*Transcript$Weight/(Transcript$HeightMedian^2)
Transcript$BMIc[is.na(Transcript$BMIc)]<-0

# Some functions for robust aggregate data.

MaxTruncated <- function (x) { 
ndata<-length(x)
x<-sort(x)
maxtrunc<-0
if (ndata<=2) {maxtrunc<-x[ndata]}
if ((ndata>=3) & (ndata<=8)){maxtrunc<-x[ndata-1]}
if ((ndata>=9) & (ndata<=14)){maxtrunc<-x[ndata-2]}
if ((ndata>=15) & (ndata<=23)){maxtrunc<-x[ndata-3]}
if (ndata>=24){maxtrunc<-x[ndata-4]}
return(maxtrunc)
}

MinTruncated <- function (x) { 
ndata<-length(x)
x<-sort(x)
mintrunc<-0
if (ndata<=2) {mintrunc<-x[1]}
if ((ndata>=3) & (ndata<=8)){mintrunc<-x[2]}
if ((ndata>=9) & (ndata<=14)){mintrunc<-x[3]}
if ((ndata>=15) & (ndata<=23)){mintrunc<-x[4]}
if (ndata>=24){mintrunc<-x[5]}
return(mintrunc)
}

Rank2th <- function (x) { 
ndata<-length(x)
x<-sort(x)
mintrunc<-0
if (ndata<=3) {mintrunc<-x[1]}
if (ndata>=4) {mintrunc<-x[2]}
return(mintrunc)
}

# Max truncated Weight
WeightMaxT<-aggregate(cbind(Weight)~PatientGuid, data=Transcript[Transcript$Weight>0 & !is.na(Transcript$Weight),], function(x) MaxTruncated(x))
names(WeightMaxT) <- c('PatientGuid','WeightMaxT')
Patient <- merge(Patient,WeightMaxT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Max, Min truncated & Median BMI
BMIMaxT<-aggregate(cbind(BMIc)~PatientGuid, data=Transcript[Transcript$BMIc>0,], function(x) MaxTruncated(x))
names(BMIMaxT) <- c('PatientGuid','BMIMaxT')
Patient <- merge(Patient,BMIMaxT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

BMIMinT<-aggregate(cbind(BMIc)~PatientGuid, data=Transcript[Transcript$BMIc>0,], function(x) MinTruncated(x))
names(BMIMinT) <- c('PatientGuid','BMIMinT')
Patient <- merge(Patient,BMIMinT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

BMIMedian<-aggregate(cbind(BMIc)~PatientGuid, data=Transcript[Transcript$BMIc>0,], function(x) median(x))
names(BMIMedian) <- c('PatientGuid','BMIMedian')
Patient <- merge(Patient,BMIMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Range BMI
Patient$RangeBMI<-Patient$BMIMaxT-Patient$BMIMinT

# Clean Systolic & Diastolic BP
Transcript$SystolicBP<-as.numeric(Transcript$SystolicBP)
Transcript$SystolicBP[is.na(Transcript$SystolicBP)]<-0
Transcript$SystolicBP[Transcript$SystolicBP <= 20]<-10*Transcript$SystolicBP[Transcript$SystolicBP <= 20] # 0 typo
Transcript$SystolicBP[Transcript$SystolicBP <= 50]<-0
Transcript$DiastolicBP<-as.numeric(Transcript$DiastolicBP)
Transcript$DiastolicBP[is.na(Transcript$DiastolicBP)]<-0
Transcript$DiastolicBP[Transcript$DiastolicBP <= 9]<-10*Transcript$DiastolicBP[Transcript$DiastolicBP <= 9] # 0 typo
Transcript$DiastolicBP[Transcript$DiastolicBP <= 40]<-0
Transcript$DiastolicBP[Transcript$SystolicBP <= Transcript$DiastolicBP]<-0 # typo error
Transcript$DiastolicBP[Transcript$SystolicBP == 0]<-0 # only both valid
Transcript$SystolicBP[Transcript$DiastolicBP == 0]<-0 # only both valid

# Max y Min truncated, Median Systolic and Diastolic BP
SystolicBPMaxT<-aggregate(cbind(SystolicBP)~PatientGuid, data=Transcript[Transcript$SystolicBP>0,], function(x) MaxTruncated(x))
names(SystolicBPMaxT) <- c('PatientGuid','SystolicBPMaxT')
Patient <- merge(Patient,SystolicBPMaxT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

SystolicBPMinT<-aggregate(cbind(SystolicBP)~PatientGuid, data=Transcript[Transcript$SystolicBP>0,], function(x) MinTruncated(x))
names(SystolicBPMinT) <- c('PatientGuid','SystolicBPMinT')
Patient <- merge(Patient,SystolicBPMinT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

SystolicBPMedian<-aggregate(cbind(SystolicBP)~PatientGuid, data=Transcript[Transcript$SystolicBP>0,], function(x) median(x))
names(SystolicBPMedian) <- c('PatientGuid','SystolicBPMedian')
Patient <- merge(Patient,SystolicBPMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

DiastolicBPMaxT<-aggregate(cbind(DiastolicBP)~PatientGuid, data=Transcript[Transcript$DiastolicBP>0,], function(x) MaxTruncated(x))
names(DiastolicBPMaxT) <- c('PatientGuid','DiastolicBPMaxT')
Patient <- merge(Patient,DiastolicBPMaxT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

DiastolicBPMinT<-aggregate(cbind(DiastolicBP)~PatientGuid, data=Transcript[Transcript$DiastolicBP>0,], function(x) MinTruncated(x))
names(DiastolicBPMinT) <- c('PatientGuid','DiastolicBPMinT')
Patient <- merge(Patient,DiastolicBPMinT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

DiastolicBPMedian<-aggregate(cbind(DiastolicBP)~PatientGuid, data=Transcript[Transcript$DiastolicBP>0,], function(x) median(x))
names(DiastolicBPMedian) <- c('PatientGuid','DiastolicBPMedian')
Patient <- merge(Patient,DiastolicBPMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Range BP
Patient$RangeSystolicBP<-Patient$SystolicBPMaxT-Patient$SystolicBPMinT
Patient$RangeDiastolicBP<-Patient$DiastolicBPMaxT-Patient$DiastolicBPMinT
Patient$HighLowBP<-Patient$SystolicBPMedian-Patient$DiastolicBPMedian

# Max truncated, Median Respiratory Rate
Transcript$RespiratoryRate<-as.numeric(Transcript$RespiratoryRate)
Transcript$RespiratoryRate[is.na(Transcript$RespiratoryRate)]<-0
Transcript$RespiratoryRate[Transcript$RespiratoryRate <= 6]<-0 # typo error

RespiratoryRateMaxT<-aggregate(cbind(RespiratoryRate)~PatientGuid, data=Transcript[Transcript$RespiratoryRate>0,], function(x) MaxTruncated(x))
names(RespiratoryRateMaxT) <- c('PatientGuid','RespiratoryRateMaxT')
Patient <- merge(Patient,RespiratoryRateMaxT,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

RespiratoryRateMedian<-aggregate(cbind(RespiratoryRate)~PatientGuid, data=Transcript[Transcript$RespiratoryRate>0,], function(x) median(x))
names(RespiratoryRateMedian) <- c('PatientGuid','RespiratoryRateMedian')
Patient <- merge(Patient,RespiratoryRateMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Rank2th (second lowest) & Median Temperature
Transcript$Temperature<-as.numeric(Transcript$Temperature)
Transcript$Temperature[is.na(Transcript$Temperature)]<-0
Transcript$Temperature[Transcript$Temperature <= 75]<-0 # typo error

TemperatureRank2th<-aggregate(cbind(Temperature)~PatientGuid, data=Transcript[Transcript$Temperature>0,], function(x) Rank2th(x))
names(TemperatureRank2th) <- c('PatientGuid','TemperatureRank2th')
Patient <- merge(Patient,TemperatureRank2th,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

TemperatureMedian<-aggregate(cbind(Temperature)~PatientGuid, data=Transcript[Transcript$Temperature>0,], function(x) median(x))
names(TemperatureMedian) <- c('PatientGuid','TemperatureMedian')
Patient <- merge(Patient,TemperatureMedian,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Transcript by Specialty
InternalMedicine<-aggregate(cbind(PhysicianSpecialty)~PatientGuid, data=Transcript[Transcript$PhysicianSpecialty=='Internal Medicine',], function(x) length(x))
names(InternalMedicine) <- c('PatientGuid','InternalMedicine')
Patient <- merge(Patient,InternalMedicine,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

CardiovascularDisease<-aggregate(cbind(PhysicianSpecialty)~PatientGuid, data=Transcript[Transcript$PhysicianSpecialty=='Cardiovascular Disease',], function(x) length(x))
names(CardiovascularDisease) <- c('PatientGuid','CardiovascularDisease')
Patient <- merge(Patient,CardiovascularDisease,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

FamilyPractice<-aggregate(cbind(PhysicianSpecialty)~PatientGuid, data=Transcript[Transcript$PhysicianSpecialty=='Family Practice',], function(x) length(x))
names(FamilyPractice) <- c('PatientGuid','FamilyPractice')
Patient <- merge(Patient,FamilyPractice,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

GeneralPractice<-aggregate(cbind(PhysicianSpecialty)~PatientGuid, data=Transcript[Transcript$PhysicianSpecialty=='General Practice',], function(x) length(x))
names(GeneralPractice) <- c('PatientGuid','GeneralPractice')
Patient <- merge(Patient,GeneralPractice,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

Podiatry<-aggregate(cbind(PhysicianSpecialty)~PatientGuid, data=Transcript[Transcript$PhysicianSpecialty=='Podiatry',], function(x) length(x))
names(Podiatry) <- c('PatientGuid','Podiatry')
Patient <- merge(Patient,Podiatry,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Unique specialties other than Pediatrics , FamilyPractice
NumSpecialties<-aggregate(cbind(PhysicianSpecialty)~PatientGuid, data=Transcript[!(Transcript$PhysicianSpecialty %in% c('Pediatrics','Family Practice')),], function(x) length(unique(x)))
names(NumSpecialties) <- c('PatientGuid','NumSpecialties')
Patient <- merge(Patient,NumSpecialties,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# weight 2009 & 2012 years (not complete years)
TVY<-data.frame(table(Transcript$VisitYear))
weight2009<-2*TVY$Freq[2]/(TVY$Freq[3]+TVY$Freq[4])
weight2012<-2*TVY$Freq[5]/(TVY$Freq[3]+TVY$Freq[4])

# Transcripts by years
VisitYearBlank<-aggregate(cbind(VisitYear)~PatientGuid, data=Transcript[Transcript$VisitYear==0,], function(x) length(x))
names(VisitYearBlank) <- c('PatientGuid','VisitYearBlank')
VisitYear2009<-aggregate(cbind(VisitYear)~PatientGuid, data=Transcript[Transcript$VisitYear==2009,], function(x) length(x))
names(VisitYear2009) <- c('PatientGuid','VisitYear2009')
VisitYear2010<-aggregate(cbind(VisitYear)~PatientGuid, data=Transcript[Transcript$VisitYear==2010,], function(x) length(x))
names(VisitYear2010) <- c('PatientGuid','VisitYear2010')
VisitYear2011<-aggregate(cbind(VisitYear)~PatientGuid, data=Transcript[Transcript$VisitYear==2011,], function(x) length(x))
names(VisitYear2011) <- c('PatientGuid','VisitYear2011')
VisitYear2012<-aggregate(cbind(VisitYear)~PatientGuid, data=Transcript[Transcript$VisitYear==2012,], function(x) length(x))
names(VisitYear2012) <- c('PatientGuid','VisitYear2012')
Patient <- merge(Patient,VisitYearBlank,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 
Patient <- merge(Patient,VisitYear2009,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 
Patient <- merge(Patient,VisitYear2010,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 
Patient <- merge(Patient,VisitYear2011,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 
Patient <- merge(Patient,VisitYear2012,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0
Patient$VisitTotal<-Patient$VisitYearBlank+Patient$VisitYear2009+Patient$VisitYear2010+Patient$VisitYear2011+Patient$VisitYear2012
Patient$MaxVisitYear<-pmax(Patient$VisitYearBlank,Patient$VisitYear2009,Patient$VisitYear2010,Patient$VisitYear2011,Patient$VisitYear2012)


# First year with visit
Patient$FirstYear<-0
Patient$FirstYear[Patient$VisitYear2009>0]<-2009
Patient$FirstYear[Patient$FirstYear==0 & Patient$VisitYear2010>0]<-2010
Patient$FirstYear[Patient$FirstYear==0 & Patient$VisitYear2011>0]<-2011
Patient$FirstYear[Patient$FirstYear==0 & Patient$VisitYear2012>0]<-2012

# Last year with visit
Patient$LastYear<-0
Patient$LastYear[Patient$VisitYear2012>0]<-2012
Patient$LastYear[Patient$LastYear==0 & Patient$VisitYear2011>0]<-2011
Patient$LastYear[Patient$LastYear==0 & Patient$VisitYear2010>0]<-2010
Patient$LastYear[Patient$LastYear==0 & Patient$VisitYear2009>0]<-2009

# Range year visit to last with visit >0 (weight year adjusted)
Patient$RangeYear<-Patient$LastYear-Patient$FirstYear+1
Patient$RangeYear[Patient$FirstYear==2009]<-Patient$RangeYear[Patient$FirstYear==2009]-1+weight2009 # adjust 2009 weight
Patient$RangeYear[Patient$LastYear==2012]<-Patient$RangeYear[Patient$LastYear==2012]-1+weight2012 # adjust 2012 weigth

# Range to date year visit (weight year adjusted)
Patient$Years2Date<-0
Patient$Years2Date[Patient$FirstYear==2009]<-weight2012+2+weight2009
Patient$Years2Date[Patient$FirstYear==2010]<-weight2012+2
Patient$Years2Date[Patient$FirstYear==2011]<-weight2012+1
Patient$Years2Date[Patient$FirstYear==2012]<-weight2012

# Max visit per weighted year
Patient$MaxVisitWYear<-0
Patient$MaxVisitWYear[Patient$MaxVisitWYear<(Patient$VisitYear2009/weight2009)]<-Patient$VisitYear2009[Patient$MaxVisitWYear<(Patient$VisitYear2009/weight2009)]/weight2009
Patient$MaxVisitWYear[Patient$MaxVisitWYear<(Patient$VisitYear2010)]<-Patient$VisitYear2010[Patient$MaxVisitWYear<(Patient$VisitYear2010)]
Patient$MaxVisitWYear[Patient$MaxVisitWYear<(Patient$VisitYear2011)]<-Patient$VisitYear2011[Patient$MaxVisitWYear<(Patient$VisitYear2011)]
Patient$MaxVisitWYear[Patient$MaxVisitWYear<(Patient$VisitYear2012/weight2012)]<-Patient$VisitYear2012[Patient$MaxVisitWYear<(Patient$VisitYear2012/weight2012)]/weight2012

# Min visit per weighted year (to date)
Patient$MinVisit2Date<-999999
Patient$MinVisit2Date[Patient$MinVisit2Date>(Patient$VisitYear2009/weight2009) & Patient$FirstYear<=2009]<-Patient$VisitYear2009[Patient$MinVisit2Date>(Patient$VisitYear2009/weight2009) & Patient$FirstYear<=2009]/weight2009
Patient$MinVisit2Date[Patient$MinVisit2Date>(Patient$VisitYear2010) & Patient$FirstYear<=2010]<-Patient$VisitYear2010[Patient$MinVisit2Date>(Patient$VisitYear2010) & Patient$FirstYear<=2010]
Patient$MinVisit2Date[Patient$MinVisit2Date>(Patient$VisitYear2011) & Patient$FirstYear<=2011]<-Patient$VisitYear2011[Patient$MinVisit2Date>(Patient$VisitYear2011) & Patient$FirstYear<=2011]
Patient$MinVisit2Date[Patient$MinVisit2Date>(Patient$VisitYear2012/weight2012)]<-Patient$VisitYear2012[Patient$MinVisit2Date>(Patient$VisitYear2012/weight2012)]/weight2012

# Min visit per weighted year (to last year with visit>0)
Patient$MinVisit2Last<-999999
Patient$MinVisit2Last[Patient$MinVisit2Last>(Patient$VisitYear2009/weight2009) & Patient$FirstYear<=2009]<-Patient$VisitYear2009[Patient$MinVisit2Last>(Patient$VisitYear2009/weight2009) & Patient$FirstYear<=2009]/weight2009
Patient$MinVisit2Last[Patient$MinVisit2Last>(Patient$VisitYear2010) & Patient$FirstYear<=2010 & Patient$LastYear>=2010]<-Patient$VisitYear2010[Patient$MinVisit2Last>(Patient$VisitYear2010) & Patient$FirstYear<=2010 & Patient$LastYear>=2010]
Patient$MinVisit2Last[Patient$MinVisit2Last>(Patient$VisitYear2011) & Patient$FirstYear<=2011 & Patient$LastYear>=2011]<-Patient$VisitYear2011[Patient$MinVisit2Last>(Patient$VisitYear2011) & Patient$FirstYear<=2011 & Patient$LastYear>=2011]
Patient$MinVisit2Last[Patient$MinVisit2Last>(Patient$VisitYear2012/weight2012) & Patient$LastYear>=2012]<-Patient$VisitYear2012[Patient$MinVisit2Last>(Patient$VisitYear2012/weight2012) & Patient$LastYear>=2012]/weight2012

# Number of physicians
NumPhysicians<-aggregate(cbind(UserGuid)~PatientGuid, data=Transcript[,], function(x) length(unique(x)))
names(NumPhysicians) <- c('PatientGuid','NumPhysicians')
Patient <- merge(Patient,NumPhysicians,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

# Visit per year ratios
Patient$VisitPerWYear2Date<-(Patient$VisitYearBlank+Patient$VisitYear2009+Patient$VisitYear2010+Patient$VisitYear2011+Patient$VisitYear2012)/Patient$Years2Date
Patient$VisitPerWYear2Last<-(Patient$VisitYearBlank+Patient$VisitYear2009+Patient$VisitYear2010+Patient$VisitYear2011+Patient$VisitYear2012)/Patient$RangeYear


# Nº of Transcripts with weight & height, (errors included)
Heighted<-aggregate(cbind(Height)~PatientGuid, data=Transcript, function(x) length(x))
names(Heighted) <- c('PatientGuid','Heighted')
Patient <- merge(Patient,Heighted,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

Weighted<-aggregate(cbind(Weight)~PatientGuid, data=Transcript, function(x) length(x))
names(Weighted) <- c('PatientGuid','Weighted')
Patient <- merge(Patient,Weighted,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 


## Lab data. few data. Only feature "Has lab" & "Has las with NA" (in HL7Text field)
trainingLab<-dbGetQuery(con, "SELECT * FROM training_labs")
testLab<-dbGetQuery(con, "SELECT * FROM test_labs")
# typos in database
names(testLab)[26] <- 'IsAbnormalValue'
names(testLab)[18] <- 'HL7CodingSystem'
Lab<-rbind(trainingLab,testLab)
PatientwithLabNA<-unique(Lab$PatientGuid[is.na(Lab$HL7Text)])
AllPatientswithLab<-unique(Lab$PatientGuid)
Patient$HasLabWithNA<-0
Patient$HasLabWithNA[Patient$PatientGuid %in% PatientwithLabNA]<-1
Patient$HasLab<-0
Patient$HasLab[Patient$PatientGuid %in% AllPatientswithLab]<-1


###############  Smoking status ################################################
testsmoke<-dbGetQuery(con, "SELECT * FROM test_patientSmokingStatus")
trainingsmoke<-dbGetQuery(con, "SELECT * FROM training_patientSmokingStatus")
smoke<-rbind(trainingsmoke,testsmoke)
smoke<-smoke[order(smoke$EffectiveYear, decreasing=TRUE),]
smokelast<-aggregate(cbind(SmokingStatusGuid)~ PatientGuid, data=smoke, function(x) x[1])
smokelast$PrevSmoker<--1
smokelast$Smoker<--1
### 0 cigarettes per day (previous smoker)
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='C12C2DB7-D31A-4514-88C0-42CBD339F764']<-1
smokelast$Smoker[smokelast$SmokingStatusGuid=='C12C2DB7-D31A-4514-88C0-42CBD339F764']<-0
### Current status unknown
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='E86CA3A8-E35B-4BBF-80E2-0375AB4A1460']<--1
smokelast$Smoker[smokelast$SmokingStatusGuid=='E86CA3A8-E35B-4BBF-80E2-0375AB4A1460']<--1
### Not a current tobacco user
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='1F3BFBBF-AB76-481B-B1E0-08A3689A54BC']<--1
smokelast$Smoker[smokelast$SmokingStatusGuid=='1F3BFBBF-AB76-481B-B1E0-08A3689A54BC']<-0
### Few (1-3) cigarettes per day 
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='FA2B7AE4-4D14-4768-A8C7-55B5F0CDF4AF']<-0
smokelast$Smoker[smokelast$SmokingStatusGuid=='FA2B7AE4-4D14-4768-A8C7-55B5F0CDF4AF']<-2
### Current status unknown
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='0815F240-3DD3-43C6-8618-613CA9E41F9F']<--1
smokelast$Smoker[smokelast$SmokingStatusGuid=='0815F240-3DD3-43C6-8618-613CA9E41F9F']<--1
### 2 or more packs per day
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='02116D5A-F26C-4A48-9A11-75AC21BC4FD3']<-0
smokelast$Smoker[smokelast$SmokingStatusGuid=='02116D5A-F26C-4A48-9A11-75AC21BC4FD3']<-40
### Up to 1 pack per day
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='DD01E545-D7AF-4F00-B248-9FD40010D81D']<-0
smokelast$Smoker[smokelast$SmokingStatusGuid=='DD01E545-D7AF-4F00-B248-9FD40010D81D']<-15
### 1-2 packs per day
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='FCD437AA-0451-4D8A-9396-B6F19D8B25E8']<-0
smokelast$Smoker[smokelast$SmokingStatusGuid=='FCD437AA-0451-4D8A-9396-B6F19D8B25E8']<-30
### 0 cigarettes per day (non-smoker or less than 100 in lifetime)
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='5ABBAB35-836F-4F3E-8632-CE063828DA15']<-0
smokelast$Smoker[smokelast$SmokingStatusGuid=='5ABBAB35-836F-4F3E-8632-CE063828DA15']<-0
### Current Tobacco user
smokelast$PrevSmoker[smokelast$SmokingStatusGuid=='2548BD83-03AE-4287-A578-FA170F39E32F']<-0
smokelast$Smoker[smokelast$SmokingStatusGuid=='2548BD83-03AE-4287-A578-FA170F39E32F']<-20
smokelast$PrevSmoker<-as.factor(smokelast$PrevSmoker)
smokelast$Smoker<-as.numeric(smokelast$Smoker)
smokelast<-smokelast[,c(1,3,4)]
names(smokelast) <- c('PatientGuid','PrevSmoker','Smoker')
Patient <- merge(Patient,smokelast,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,'PrevSmoker']),'PrevSmoker']<--1
Patient[is.na(Patient[,'Smoker']),'Smoker']<--1


############################## ICD9 codes ######################################
icd9 <- as.data.frame(read.table("icd9.csv", header=TRUE,sep=","))
testDiagnosis<-dbGetQuery(con, "SELECT * FROM test_diagnosis")
trainingDiagnosis<-dbGetQuery(con, "SELECT * FROM training_diagnosis")
Diagnosis<-rbind(trainingDiagnosis,testDiagnosis)
testTDiagnosis<-dbGetQuery(con, "SELECT * FROM test_transcriptDiagnosis")
trainingTDiagnosis<-dbGetQuery(con, "SELECT * FROM training_transcriptDiagnosis")
TDiagnosis<-rbind(trainingTDiagnosis,testTDiagnosis)
Diagnosis<-merge(Diagnosis,TDiagnosis,by="DiagnosisGuid",all.x=TRUE)
Diagnosis<-merge(Diagnosis,icd9,by="ICD9Code",all.x=TRUE)


## Level 1 & Level 2 diagnostics group, based in CCS classification & personal experience
icd9groupsLevel2<-as.data.frame(table(icd9[,2]))
names(icd9groupsLevel2) <- c('level2','Freq')
icd9groupsLevel1<-as.data.frame(table(icd9[,3]))
names(icd9groupsLevel1) <- c('level1','Freq')

for (i in 2:nrow(icd9groupsLevel2)) {
 group2<-as.character(icd9groupsLevel2$level2[i])
 agrLevel2<-aggregate(cbind(level2)~PatientGuid, data=Diagnosis[Diagnosis$level2==group2,], function(x) length(x))
 names(agrLevel2) <- c('PatientGuid',paste("L2",group2,sep='_'))
 Patient <- merge(Patient,agrLevel2,by="PatientGuid",all.x=TRUE)
 Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
 }
for (i in 2:nrow(icd9groupsLevel1)) {
 group1<-as.character(icd9groupsLevel1$level1[i])
 agrLevel1<-aggregate(cbind(level1)~PatientGuid, data=Diagnosis[Diagnosis$level1==group1,], function(x) length(x))
 names(agrLevel1) <- c('PatientGuid',paste("L1",group1,sep='_'))
 Patient <- merge(Patient,agrLevel1,by="PatientGuid",all.x=TRUE)
 Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
 }

## Min start year of all diagnostics
StartYear<-aggregate(cbind(StartYear)~PatientGuid, data=Diagnosis[Diagnosis$StartYear!=0,], function(x) min(x))
names(StartYear) <- c('PatientGuid','StartYear')
Patient <- merge(Patient,StartYear,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

## Number of diagnostics declared earlier 2009
PreviousYear<-aggregate(cbind(StartYear)~PatientGuid, data=Diagnosis[Diagnosis$StartYear!=0 & Diagnosis$StartYear<2009,], function(x) length(x))
names(PreviousYear) <- c('PatientGuid','PreviousYear')
Patient <- merge(Patient,PreviousYear,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Number of different categories with level 1 in icd9 table as "DMSymptom"
## This are categories of diagnostics could probably correlated with DM but no significatives in this data
## This feature is like a score of "other symptoms".
DiffDMOtherRelatedSymptoms<-aggregate(cbind(level2)~PatientGuid, data=Diagnosis[Diagnosis$level1=="DMSymptom",], function(x) length(unique(x)))
names(DiffDMOtherRelatedSymptoms) <- c('PatientGuid','DiffDMOtherRelatedSymptoms')
Patient <- merge(Patient,DiffDMOtherRelatedSymptoms,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Number of visits generated by previous categories
VisitsDMOtherRelatedSymptoms<-aggregate(cbind(level2)~PatientGuid, data=Diagnosis[Diagnosis$level1=="DMSymptom",], function(x) length(x))
names(VisitsDMOtherRelatedSymptoms) <- c('PatientGuid','VisitsDMOtherRelatedSymptoms')
Patient <- merge(Patient,VisitsDMOtherRelatedSymptoms,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Number of differents level 2 diagnostics groups in icd9 table
DiffLevel2Diag<-aggregate(cbind(level2)~PatientGuid, data=Diagnosis, function(x) length(unique(x)))
names(DiffLevel2Diag) <- c('PatientGuid','DiffLevel2Diag')
Patient <- merge(Patient,DiffLevel2Diag,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Number of differents 3 digits diagnostics groups in icd9 table
Tot3digitICD9<-aggregate(cbind(icd9_3d)~PatientGuid, data=Diagnosis, function(x) length(unique(x)))
names(Tot3digitICD9) <- c('PatientGuid','Tot3digitICD9')
Patient <- merge(Patient,Tot3digitICD9,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Diagnostics per weighted year
TotDiagWYear<-aggregate(cbind(ICD9Code)~PatientGuid, data=Diagnosis, function(x) length(x))
names(TotDiagWYear) <- c('PatientGuid','TotDiagWYear')
Patient <- merge(Patient,TotDiagWYear,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient[,ncol(Patient)]<-Patient[,ncol(Patient)]/Patient$RangeYear

## Total diagnostics
TotDiag<-aggregate(cbind(ICD9Code)~PatientGuid, data=Diagnosis, function(x) length(x))
names(TotDiag) <- c('PatientGuid','TotDiag')
Patient <- merge(Patient,TotDiag,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient[,ncol(Patient)]<-Patient[,ncol(Patient)]

## Total diagnostics per visit
Patient$TotDiagPerVisit<-Patient$TotDiag/Patient$VisitTotal

## Total "orphand" diagnostics (diagnostic without transcript reference)
TotDiagWOTranscript<-aggregate(cbind(ICD9Code)~PatientGuid, data=Diagnosis[is.na(Diagnosis$TranscriptGuid),], function(x) length(x))
names(TotDiagWOTranscript) <- c('PatientGuid','TotDiagWOTranscript')
Patient <- merge(Patient,TotDiagWOTranscript,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  


###############################  Medication ###################################

##  Vademecum ######################### 4 active principles per medication #########
Vademecum <- as.data.frame(read.table("drugsap.csv", header=TRUE,sep=";",dec="."))
Vade1<-as.data.frame(Vademecum[,c(1:3,4:7,20:37)])
Vade2<-as.data.frame(Vademecum[,c(1:3,8:11,20:37)])
Vade3<-as.data.frame(Vademecum[,c(1:3,12:15,20:37)])
Vade4<-as.data.frame(Vademecum[,c(1:3,16:19,20:37)])
names(Vade1)[4]<-"MedStrength"
names(Vade1)[5]<-"ActivePrinciple"
names(Vade1)[6]<-"ActivePricipleUnique"
names(Vade1)[7]<-"ActivePrincipleOrder"
names(Vade2)[4]<-"MedStrength"
names(Vade2)[5]<-"ActivePrinciple"
names(Vade2)[6]<-"ActivePricipleUnique"
names(Vade2)[7]<-"ActivePrincipleOrder"
names(Vade3)[4]<-"MedStrength"
names(Vade3)[5]<-"ActivePrinciple"
names(Vade3)[6]<-"ActivePricipleUnique"
names(Vade3)[7]<-"ActivePrincipleOrder"
names(Vade4)[4]<-"MedStrength"
names(Vade4)[5]<-"ActivePrinciple"
names(Vade4)[6]<-"ActivePricipleUnique"
names(Vade4)[7]<-"ActivePrincipleOrder"
Vademecum<-as.data.frame(rbind(Vade1,Vade2,Vade3,Vade4))
Vademecum<-Vademecum[Vademecum$ActivePrinciple!="",]
###########################################################################
testPrescription<-dbGetQuery(con, "SELECT * FROM test_prescription")
trainingPrescription<-dbGetQuery(con, "SELECT * FROM training_prescription")
Prescription<-rbind(trainingPrescription,testPrescription)
testMedication<-dbGetQuery(con, "SELECT * FROM test_medication")
trainingMedication<-dbGetQuery(con, "SELECT * FROM training_medication")
Medication<-rbind(trainingMedication,testMedication)
Prescription<-merge(Prescription,Medication,by="MedicationGuid",all.y=TRUE)
ActPPrescrip<-merge(Prescription,Vademecum,by="MedicationNdcCode",all.x=TRUE)
names(ActPPrescrip)[11]<-"PatientGuid"
## auxiliary data frame for join dmIndicator to ActPPrescript )only a effect of interactive checking of data, not for medeling)
Patient2<-as.data.frame(cbind(Patient$PatientGuid,Patient$dmIndicator))
names(Patient2)<-c('PatientGuid','dmIndicator')
ActPPrescrip<-merge(ActPPrescrip,Patient2,by="PatientGuid",all.x=TRUE)
## administration route
ActPPrescrip$Via<-"General"
ActPPrescrip$Via[ActPPrescrip$Rectal=='1']<-"Rectal"
ActPPrescrip$Via[ActPPrescrip$Inhalation=='1']<-"Inhalation"
ActPPrescrip$Via[ActPPrescrip$Sublingual=='1']<-"Sublingual"
ActPPrescrip$Via[ActPPrescrip$Nasal=='1']<-"Nasal"
ActPPrescrip$Via[ActPPrescrip$Transdermal=='1']<-"Transdermal"
ActPPrescrip$Via[ActPPrescrip$Injectable=='1']<-"Injectable"
ActPPrescrip$Via[ActPPrescrip$Vaginal=='1']<-"Vaginal"
ActPPrescrip$Via[ActPPrescrip$Ophtalmic=='1']<-"Ophtalmic"
ActPPrescrip$Via[ActPPrescrip$Otic=='1']<-"Otic"
ActPPrescrip$Via[ActPPrescrip$Topical=='1']<-"Topical"
ActPPrescrip$Via[ActPPrescrip$Vaccine=='1']<-"Vaccine"


### Actives principles / families (defined by chemical similarities or clinical indication)

## _dose for dose of active principle / family adjusted
## _npr for number of prescriptions
## _nap for number of active principles of the family
## _bin for binary flag

############################## Acetaminophen ##############################################
ap<-'acetaminophen'
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','acetaminophen_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-'acetaminophen'
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','acetaminophen_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-'acetaminophen'
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','acetaminophen_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0
#Patient[,ncol(Patient)]<-Patient[,ncol(Patient)]/Patient$RangeYear 

###################################### ACEI ########################################
ap<-c('benazepril','captopril','enalapril','fosinopril','lisinopril','moexipril','perindopril','quinapril','ramipril','trandolapril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','ACEI_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('benazepril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','benazepril_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('benazepril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','benazepril_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('enalapril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','enalapril_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('enalapril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','enalapril_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient$enalapril_dose<-2*Patient$enalapril_dose

ap<-c('ramipril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','ramipril_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('ramipril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','ramipril_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient$ramipril_dose<-4*Patient$ramipril_dose

ap<-c('lisinopril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','lisinopril_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('lisinopril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','lisinopril_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## ACEI dose
Patient$ACEI_dose<-pmax(Patient$benazepril_dose,Patient$ramipril_dose,Patient$enalapril_dose)

## ACEI npr
ap<-c('benazepril','captopril','enalapril','fosinopril','lisinopril','moexipril','perindopril','quinapril','ramipril','trandolapril')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','ACEI_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

################################# Aspirin #################################################
ap<-c('aspirin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','aspirin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('aspirin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','aspirin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('aspirin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','aspirin_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

##################################### AIIRA ##################################################
ap<-c('losartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','losartan_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('olmesartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','olmesartan_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('telmisartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','telmisartan_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('valsartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','valsartan_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('losartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','losartan_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('olmesartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','olmesartan_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('telmisartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','telmisartan_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('valsartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','valsartan_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('losartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','losartan_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('olmesartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','olmesartan_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('telmisartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','telmisartan_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('valsartan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','valsartan_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('azilsartan','candesartan','irbesartan','losartan','olmesartan','telmisartan','valsartan')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','AIIRA_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('azilsartan','candesartan','irbesartan','losartan','olmesartan','telmisartan','valsartan')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','AIIRA_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

### Dose adjusted losartan / telmisartan
Patient$losartan_telmisartan_dose<-pmax(Patient$losartan_dose,5*Patient$telmisartan_dose/4)


## Total family npr
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','AIIRA_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

####################################### Antifungical ################################################
## General route
ap<-c('butenafine','ciclopirox','clotrimazole','econazole','fluconazole','griseofulvin','itraconazole','ketoconazole','miconazole','naftifine')
ap<-c(ap,'nystatin','oxiconazole','sertaconazole','sulconazole','terbinafine','terconazole','tioconazole','tolnaftate')
vvia=c('General')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','antifungical_general_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('butenafine','ciclopirox','clotrimazole','econazole','fluconazole','griseofulvin','itraconazole','ketoconazole','miconazole','naftifine')
ap<-c(ap,'nystatin','oxiconazole','sertaconazole','sulconazole','terbinafine','terconazole','tioconazole','tolnaftate')
vvia=c('General')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','antifungical_general_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('butenafine','ciclopirox','clotrimazole','econazole','fluconazole','griseofulvin','itraconazole','ketoconazole','miconazole','naftifine')
ap<-c(ap,'nystatin','oxiconazole','sertaconazole','sulconazole','terbinafine','terconazole','tioconazole','tolnaftate')
vvia=c('General')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','antifungical_general_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

# Topical, Vaginal
ap<-c('butenafine','ciclopirox','clotrimazole','econazole','fluconazole','griseofulvin','itraconazole','ketoconazole','miconazole','naftifine')
ap<-c(ap,'nystatin','oxiconazole','sertaconazole','sulconazole','terbinafine','terconazole','tioconazole','tolnaftate')
vvia=c('Topical','Vaginal')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','antifungical_topical_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('butenafine','ciclopirox','clotrimazole','econazole','fluconazole','griseofulvin','itraconazole','ketoconazole','miconazole','naftifine')
ap<-c(ap,'nystatin','oxiconazole','sertaconazole','sulconazole','terbinafine','terconazole','tioconazole','tolnaftate')
vvia=c('Topical','Vaginal')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','antifungical_topical_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 
 
ap<-c('butenafine','ciclopirox','clotrimazole','econazole','fluconazole','griseofulvin','itraconazole','ketoconazole','miconazole','naftifine')
ap<-c(ap,'nystatin','oxiconazole','sertaconazole','sulconazole','terbinafine','terconazole','tioconazole','tolnaftate')
vvia=c('Topical','Vaginal')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','antifungical_topical_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 
 
###################################### Antiplatelet #########################################################
ap<-c('cilostazol','clopidogrel','dipyridamole','prasugrel','ticlopidine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','antiplatelet_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('cilostazol','clopidogrel','dipyridamole','prasugrel','ticlopidine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','antiplatelet_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('cilostazol','clopidogrel','dipyridamole','prasugrel','ticlopidine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','antiplatelet_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

########################################## Benzodiazepine #####################################################################
ap<-c('alprazolam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','alprazolam_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('alprazolam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','alprazolam_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('clonazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','clonazepam_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('clonazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','clonazepam_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('diazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','diazepam_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('diazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','diazepam_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('lorazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','lorazepam_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('lorazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','lorazepam_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('temazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','temazepam_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('temazepam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','temazepam_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('alprazolam','clonazepam','diazepam','flurazepam','lorazepam','oxazepam','temazepam','triazolam')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','benzodiazepine_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

ap<-c('alprazolam','clonazepam','diazepam','flurazepam','lorazepam','oxazepam','temazepam','triazolam')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','benzodiazepine_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

ap<-c('alprazolam','clonazepam','diazepam','flurazepam','lorazepam','oxazepam','temazepam','triazolam')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','benzodiazepine_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

###########################################  Betablocker  #################################################################### 
ap<-c('atenolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','atenolol_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('atenolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','atenolol_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('atenolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','atenolol_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('carvedilol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','carvedilol_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('carvedilol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','carvedilol_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('carvedilol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','carvedilol_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('metoprolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','metoprolol_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('metoprolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','metoprolol_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('nebivolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','nebivolol_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('nebivolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','nebivolol_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('propranolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','propranolol_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('propranolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','propranolol_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('acebutolol','atenolol','bisoprolol','carvedilol','labetalol','levobunolol','metoprolol','nadolol','nebivolol','pindolol','propranolol','sotalol','timolol')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','betablocker_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

ap<-c('acebutolol','atenolol','bisoprolol','carvedilol','labetalol','levobunolol','metoprolol','nadolol','nebivolol','pindolol','propranolol','sotalol','timolol')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','betablocker_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

ap<-c('acebutolol','atenolol','bisoprolol','carvedilol','labetalol','levobunolol','metoprolol','nadolol','nebivolol','pindolol','propranolol','sotalol','timolol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','betablocker_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

###########################################  Fibrate  #################################################################### 
ap<-c('fenofibrate')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','fenofibrate_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('fenofibric_acid')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','fenofibric_acid_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('gemfibrozil')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','gemfibrozil_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('fenofibrate')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','fenofibrate_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('fenofibric_acid')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','fenofibric_acid_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('gemfibrozil')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','gemfibrozil_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('fenofibrate','fenofibric_acid','gemfibrozil')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','fibrate_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

ap<-c('fenofibrate','fenofibric_acid','gemfibrozil')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','fibrate_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('fenofibrate','fenofibric_acid','gemfibrozil')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','fibrate_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

######################################## GABA ##################################################
ap<-c('gabapentin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','gabapentin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('pregabalin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','pregabalin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('gabapentin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','gabapentin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('pregabalin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','pregabalin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('gabapentin','pregabalin','tiagabine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','GABA_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('gabapentin','pregabalin','tiagabine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','GABA_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

######################################## Gastroparesia ######################################
ap<-c('metoclopramide')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','gastroparesia_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('metoclopramide')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','gastroparesia_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','gastroparesia_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################################ glucocorticoid #####################################
# Injectable
ap<-c('beclomethasone','betamethasone','cortisone','dexamethasone','fludrocortisone','hydrocortisone',
'methylprednisolone','prednisolone','prednisone','triamcinolone')
vvia=c('Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','glucocorticoid_injec_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('beclomethasone','betamethasone','cortisone','dexamethasone','fludrocortisone','hydrocortisone',
'methylprednisolone','prednisolone','prednisone','triamcinolone')
vvia=c('Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','glucocorticoid_injec_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

# Topical
ap<-c('beclomethasone','betamethasone','cortisone','dexamethasone','fludrocortisone','hydrocortisone','methylprednisolone','prednisolone','prednisone','triamcinolone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','glucocorticoid_local_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','glucocorticoid_local_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','glucocorticoid_local_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('betamethasone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','betamethasone_local_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

ap<-c('betamethasone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','betamethasone_local_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('hydrocortisone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','hydrocortisone_local_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('hydrocortisone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','hydrocortisone_local_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('triamcinolone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','triamcinolone_local_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('triamcinolone')
vvia<-c('Topical')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','triamcinolone_local_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## General (including rectal & injectable)
ap<-c('budenoside','beclomethasone','betamethasone','cortisone','dexamethasone','fludrocortisone','hydrocortisone','methylprednisolone','prednisolone','prednisone','triamcinolone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','glucocorticoid_general_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','glucocorticoid_general_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','glucocorticoid_general_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('hydrocortisone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) max(x))
names(agrPA) <- c('PatientGuid','hydrocortisone_general_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('hydrocortisone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','hydrocortisone_general_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('hydrocortisone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','hydrocortisone_general_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('methylprednisolone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) max(x))
names(agrPA) <- c('PatientGuid','methylprednisolone_general_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('methylprednisolone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','methylprednisolone_general_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('methylprednisolone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','methylprednisolone_general_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('prednisone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) max(x))
names(agrPA) <- c('PatientGuid','prednisone_general_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('prednisone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','prednisone_general_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('prednisone')
vvia<-c('General','Rectal','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','prednisone_general_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################################## L Type calcium channel blocker ####################################
ap<-c('amlodipine','felodipine','isradipine','nifedipine','nisoldipine','verapamil','diltiazem')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','LtypeCaChB_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('amlodipine','felodipine','isradipine','nifedipine','nisoldipine','verapamil','diltiazem')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','LtypeCaChB_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','LtypeCaChB_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('amlodipine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','amlodipine_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('amlodipine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','amlodipine_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

####################################### Proton pump inhibitor ###################################
ap<-c('dexlansoprazole','esomeprazole','lansoprazole','omeprazole','pantoprazole','rabeprazole')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','protonpumpinhibitor_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('dexlansoprazole','esomeprazole','lansoprazole','omeprazole','pantoprazole','rabeprazole')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','protonpumpinhibitor_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','protonpumpinhibitor_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

######################################## Statin #################################################
ap<-c('atorvastatin','fluvastatin','lovastatin','pitavastatin','pravastatin','rosuvastatin','simvastatin')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','statin_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','statin_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','statin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('atorvastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','atorvastatin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('lovastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','lovastatin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('pravastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','pravastatin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('rosuvastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','rosuvastatin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('simvastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','simvastatin_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('atorvastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','atorvastatin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('lovastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','lovastatin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('pravastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','pravastatin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('rosuvastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','rosuvastatin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

ap<-c('simvastatin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','simvastatin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

### Statin dose adjusted!
Patient$statin_dose_adjusted<-pmax(2*Patient$lovastatin_dose,Patient$pravastatin_dose,2*Patient$rosuvastatin_dose,Patient$atorvastatin_dose,Patient$simvastatin_dose)

################################################ Thiazide ################################
ap<-c('bendroflumethiazide','chlorthalidone','hydrochlorothiazide','indapamide','metolazone')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','thiazide_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('bendroflumethiazide','chlorthalidone','hydrochlorothiazide','indapamide','metolazone')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','thiazide_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','thiazide_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-('hydrochlorothiazide')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) max(x))
names(agrPA) <- c('PatientGuid','hydrochlorothiazide_dose')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0

############################################# Antilipid ######################################
ap<-c('niacin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','niacin_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('niacin')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','niacin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('ezetimibe')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','ezetimibe_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('ezetimibe')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','ezetimibe_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('cholestyramine','colesevelam','colestipol','ezetimibe','niacin','omega_3')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','antilipid_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('cholestyramine','colesevelam','colestipol','ezetimibe','niacin','omega_3')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','antilipid_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

######################################## Nasal route ###############################
vvia<-c('Nasal')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','nasal_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

######################################## Inhalation route ###############################
vvia<-c('Inhalation')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','inhalation_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

################################################ Otic route ##############################################
vvia<-c('Otic')
agrPA<-aggregate(cbind(MedicationGuid)~PatientGuid, data=ActPPrescrip[ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','otic_nmed')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('acetic','aluminum_acetate','antipyrine','benzocaine','carbamazepine','chloroxylenol','ciprofloxacin',
'colistin','fluocinolone','hydrocortisone','neomycin','ofloxacin','polymyxin_b','pramoxine','thonzonium','triethanolamine_polypeptide_oleate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','otic_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('acetic','aluminum_acetate','antipyrine','benzocaine','carbamazepine','chloroxylenol','ciprofloxacin','colistin',
'fluocinolone','hydrocortisone','neomycin','ofloxacin','polymyxin_b','pramoxine','thonzonium','triethanolamine_polypeptide_oleate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','otic_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','otic_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################################## Ophtalmic route ##############################################
## antiinflammatory
vvia<-c('Ophtalmic')
ap<-c('alcaftadine','azelastine','bepotastine','bromfenac','cromolyn','cyclosporine','dexamethasone',
'emedastine','epinastine','hydrocortisone','ketorolac','ketotifen','loteprednol','naphazoline',
'nedocromil','nepafenac','ocular_lubricant','olopatadine','pheniramine','prednisolone','tetrahydrozoline','zinc')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','allergy_inflam_opht_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('alcaftadine','azelastine','bepotastine','bromfenac','cromolyn','cyclosporine','dexamethasone',
'emedastine','epinastine','hydrocortisone','ketorolac','ketotifen','loteprednol','naphazoline',
'nedocromil','nepafenac','ocular_lubricant','olopatadine','pheniramine','prednisolone','tetrahydrozoline','zinc')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','allergy_inflam_opht_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('alcaftadine','azelastine','bepotastine','bromfenac','cromolyn','cyclosporine','dexamethasone',
'emedastine','epinastine','hydrocortisone','ketorolac','ketotifen','loteprednol','naphazoline',
'nedocromil','nepafenac','ocular_lubricant','olopatadine','pheniramine','prednisolone','tetrahydrozoline','zinc')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','allergy_inflam_opht_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

# antibiotic
ap<-c('azithromycin','bacitracin','besifloxacin','ciprofloxacin','erythromycin','gatifloxacin','gentamicin','gramicidin','moxifloxacin','neomycin','ofloxacin','polymyxin_b','sulfacetamide_sodium','tobramycin','trimethoprim')
vvia<-c('Ophtalmic')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','antibiotic_opht_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('azithromycin','bacitracin','besifloxacin','ciprofloxacin','erythromycin','gatifloxacin','gentamicin','gramicidin','moxifloxacin','neomycin','ofloxacin','polymyxin_b','sulfacetamide_sodium','tobramycin','trimethoprim')
vvia<-c('Ophtalmic')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','antibiotic_opht_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','antibiotic_opht_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

# glaucoma
ap<-c('bimatoprost','brimonidine','brinzolamide','dorzolamide','latanoprost','levobunolol','pilocarpine','timolol','travoprost')
vvia<-c('Ophtalmic')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','glaucoma_opht_nap')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('bimatoprost','brimonidine','brinzolamide','dorzolamide','latanoprost','levobunolol','pilocarpine','timolol','travoprost')
vvia<-c('Ophtalmic')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','glaucoma_opht_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','glaucoma_opht_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

##########################  Contraceptives ###############################
# Oral + injectable
ap<-c('conjugated_estrogens','desogestrel','esterified_estrogens','estradiol','ethinyl_estradiol','etonogestrel','levonorgestrel','mestranol','norgestrel')
vvia<-c('General','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','oral_contracep_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('conjugated_estrogens','desogestrel','esterified_estrogens','estradiol','ethinyl_estradiol','etonogestrel','levonorgestrel','mestranol','norgestrel')
vvia<-c('General','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','oral_contracep_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

# Transdermal / Vaginal
ap<-c('conjugated_estrogens','estradiol','ethinyl_estradiol','levonorgestrel','nonoxynol_9','norelgestromin')
vvia<-c('Transdermal','Vaginal')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) length(x))
names(agrPA) <- c('PatientGuid','no_oral_contracep_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('conjugated_estrogens','estradiol','ethinyl_estradiol','levonorgestrel','nonoxynol_9','norelgestromin')
vvia<-c('Transdermal','Vaginal')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','no_oral_contracep_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

##### Alfa1 blockers ##############
ap<-c('alfuzosin','doxazosin','prazosin','silodosin','tamsulosin','terazosin')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','alfa1blocker_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

##### Calcium ##############
ap<-c('calcium','calcium_acetate','calcium_carbonate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','calcium_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('calcium','calcium_acetate','calcium_carbonate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','calcium_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

##### Coxib ##############
ap<-c('celecoxib')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','coxib_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

##### Digoxin ##############
ap<-c('digoxin')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','digoxin_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Laxatives #####################
ap<-c('bisacodyl','docusate','glycerin','lactulose','lubiprostone','magnesium_hydroxide','magnesium_oxide','mineral_oil','peg_3350','senna','sodium_biphosphate','sodium_phosphate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','laxatives_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('bisacodyl','docusate','glycerin','lactulose','lubiprostone','magnesium_hydroxide','magnesium_oxide','mineral_oil','peg_3350','senna','sodium_biphosphate','sodium_phosphate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','laxatives_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### 5a-reductase #####################
ap<-c('dutasteride','finasteride')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','fiveareductase_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Iron #####################
ap<-c('carbonyl_iron','ferrous_fumarate','ferrous_gluconate','ferrous_sulfate','iron','sodium_ferric_gluconate_complex')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','iron_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Loop diuretic #####################
ap<-c('bumetanide','furosemide','torsemide')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','loopdiuretic_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### K diuretic ##################### 
ap<-c('amiloride','spironolactone','triamterene')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','Kdiuretic_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('amiloride','spironolactone','triamterene')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','Kdiuretic_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Isosorbide ##################### 
ap<-c('isosorbide_dinitrate','isosorbide_mononitrate')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','isosorbide_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Omega_3 #####################
ap<-c('omega_3')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','omega_3_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Potassium_chloride ####################
ap<-c('potassium_chloride')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','potassium_chloride_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

#### Disinfectant towelette (possible use by insulin dependant diabetics) #####
ap<-c('isopropyl_alcohol')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','isopropyl_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

# Few cases, add this to DMRelated diagnostics group
Patient$L2_DMRelated2<-Patient$L2_DMRelated2+Patient$isopropyl_npr

##########################  null (codes with null medication description) ###############################
ap<-c('null')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','null_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################# Osteoporosis #################
ap<-c('alendronate','ibandronate','ibandronate','raloxifene','risedronate','tamoxifen','denosumab')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','osteoporosis_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################# Alkylamines ###################
ap<-c('brompheniramine','chlorpheniramine','dexchlorpheniramine','triprolidine')
vvia<-c('General','Injectable')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap & ActPPrescrip$Via %in% vvia,], function(x) 1)
names(agrPA) <- c('PatientGuid','alkylamine_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

####################### Amphetamine ##############################
ap<-c('amphetamine','benzphetamine','dextroamphetamine','diethylpropion','ephedrine','lisdexamfetamine',
'methamphetamine','phentermine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','amphetamine_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

######################  BP Other ###################
ap<-c('aliskiren','hydralazine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','BPOther_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('aliskiren','hydralazine')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','BPOther_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

########################### Triptan ###########################
ap<-c('ergotamine','almotriptan','eletriptan','frovatriptan','naratriptan','rizatriptan','sumatriptan','zolmitriptan')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','triptan_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

########################### Corticosteroids ##################
ap<-c('alclometasone','amcinonide','clobetasol','desonide','desoximetasone','diflorasone','fluocinolone',
'flurandrenolide','halcinonide','halobetasol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','corticosteroids_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################# Gout ##############################
ap<-c('allopurinol','colchicine','febuxostat','mercaptopurine','probenecid')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','gout_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

ap<-c('allopurinol','colchicine','febuxostat','mercaptopurine','probenecid')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','gout_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############################ Vitamin #######################
ap<-c('calcipotriene','calcitriol','cholecalciferol','doxercalciferol','ergocalciferol')
agrPA<-aggregate(cbind(MedStrength)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) 1)
names(agrPA) <- c('PatientGuid','vitamin_bin')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  


############################# Medication resume ########################################

############# Number of active principles ################
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip, function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','active_principle')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0 

############# Number of prescripts (this take a while, and eat 15Gb RAM ...) ################
agrPA<-aggregate(cbind(PrescriptionGuid)~PatientGuid, data=ActPPrescrip, function(x) length(x))
names(agrPA) <- c('PatientGuid','prescripts')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

############# Number of medications without prescript ################
agrPA<-aggregate(cbind(MedicationGuid)~PatientGuid, data=ActPPrescrip[is.na(ActPPrescrip$PrescriptionGuid),], function(x) length(unique(x)))
names(agrPA) <- c('PatientGuid','medication_wo_prescript')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Correct Prescripts
Patient$prescripts<-Patient$prescripts+Patient$medication_wo_prescript

## Move "0" to the tail end
Patient$active_principle[Patient$active_principle==0]<-999

## Create a binary flag
Patient$nomedication<-0
Patient$nomedication[Patient$active_principle==999]<-1


Medication <- merge(Medication,Diagnosis,by="DiagnosisGuid",all.x=TRUE)

####################### Nº of diagnosis (3 digit) with medication  ############################
# clean orphand & missing diagnosis
Medication$DiagNA<-0
Medication$DiagNA[is.na(Medication$ICD9Code)]<-1
Medication$Zero<-0
Medication$Zero[Medication$DiagnosisGuid=='00000000-0000-0000-0000-000000000000']<-1
Medication$Valid<-1
Medication$Valid[Medication$Zero+Medication$DiagNA>0]<-0
agrMed<-aggregate(cbind(icd9_3d)~PatientGuid.x, data=Medication[Medication$Valid==1,], function(x) length(unique(x)))
names(agrMed) <- c('PatientGuid','diag_3digit_with_medication')
Patient <- merge(Patient,agrMed,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  

## Add features for missing values
agrMed<-aggregate(cbind(MedicationGuid)~PatientGuid.x, data=Medication[Medication$Zero==1,], function(x) 1)
names(agrMed) <- c('PatientGuid','medication_diag_zero')
Patient <- merge(Patient,agrMed,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient[Patient[,ncol(Patient)]>0,ncol(Patient)]<-1  

agrMed<-aggregate(cbind(MedicationGuid)~PatientGuid.x, data=Medication[Medication$DiagNA==1,], function(x) 1)
names(agrMed) <- c('PatientGuid','medication_diag_NA')
Patient <- merge(Patient,agrMed,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient[Patient[,ncol(Patient)]>0,ncol(Patient)]<-1  
Patient[Patient[,ncol(Patient)-1]>0,ncol(Patient)]<-0  

########################### DM (data leaks, few cases, but every count!) #####################################
ap<-c('miglitol','acarbose')
agrPA<-aggregate(cbind(ActivePrinciple)~PatientGuid, data=ActPPrescrip[ActPPrescrip$ActivePrinciple %in% ap,], function(x) length(x))
names(agrPA) <- c('PatientGuid','dm_npr')
Patient <- merge(Patient,agrPA,by="PatientGuid",all.x=TRUE)
Patient[is.na(Patient[,ncol(Patient)]),ncol(Patient)]<-0  
Patient$medication_diag_NA[Patient$medication_diag_NA==0 & (Patient$dm_npr+Patient$L2_DMII)>0]<-1

###### State flags (great number of patients) #######################

Patient$STATE_CA<-ifelse(Patient$State=="CA",1,0)
Patient$STATE_TX<-ifelse(Patient$State=="TX",1,0)
Patient$STATE_FL<-ifelse(Patient$State=="FL",1,0)
Patient$STATE_MO<-ifelse(Patient$State=="MO",1,0)
Patient$STATE_NJ<-ifelse(Patient$State=="NJ",1,0)
Patient$STATE_NY<-ifelse(Patient$State=="NY",1,0)
Patient$STATE_OH<-ifelse(Patient$State=="OH",1,0)
Patient$STATE_NV<-ifelse(Patient$State=="NV",1,0)
Patient$STATE_VA<-ifelse(Patient$State=="VA",1,0)

# Write Data
write.csv(Patient,file="c://dmii/data/Patient.csv", row.names = FALSE) 





