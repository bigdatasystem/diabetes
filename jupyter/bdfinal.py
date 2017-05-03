
# coding: utf-8

# In[1]:

import pandas as pd
import numpy as np
from collections import defaultdict
import matplotlib
import matplotlib.pyplot as plt
import os
import re


# In[2]:

os.chdir('/Users/janzaloudek/Development/Skola/umass/diabetes/jupyter/trainingSet')


# In[3]:

diagnosisT = pd.read_csv('training_SyncDiagnosis.csv')
allergyT = pd.read_csv('training_SyncAllergy.csv')
immunT = pd.read_csv('training_SyncImmunization.csv')
labObsT = pd.read_csv('training_SyncLabObservation.csv')
labPanT = pd.read_csv('training_SyncLabPanel.csv')
labResT = pd.read_csv('training_SyncLabResult.csv')
medicationT = pd.read_csv('training_SyncMedication.csv')
patientT = pd.read_csv('training_SyncPatient.csv')
patientCondT = pd.read_csv('training_SyncPatientCondition.csv')
smokingT = pd.read_csv('training_SyncPatientSmokingStatus.csv')
prescripT = pd.read_csv('training_SyncPrescription.csv')
trnscrpT = pd.read_csv('training_SyncTranscript.csv')
trnscrpAT = pd.read_csv('training_SyncTranscriptAllergy.csv')
trnscrpDT = pd.read_csv('training_SyncTranscriptDiagnosis.csv')
trnscrptMT = pd.read_csv('training_SyncTranscriptMedication.csv')
myfileT = pd.read_csv('myfile.csv')
conditionT = pd.read_csv('SyncCondition.csv')
smokingStatusT = pd.read_csv('SyncSmokingStatus.csv')


# In[4]:

labObsT


# In[5]:

def ICD9Label(text):
    if bool(re.match('14[0-9]|2[0-3][0-9]', text)) == True:
        return 'neoplasms'
    elif bool(re.match('2[4-7][0-9]', text)) == True:
        return 'endoctrine'
    elif bool(re.match('28[0-9]', text)) == True:
        return 'blood'
    elif bool(re.match('29[0-9]|3[0-1][0-9]', text)) == True:
        return 'mental'
    elif bool(re.match('3[2-5][0-9]', text)) == True:
        return 'nervous'
    elif bool(re.match('3[6-8][0-9]', text)) == True:
        return 'sense'
    elif bool(re.match('39[0-9]|4[0-5][0-9]', text)) == True:
        return 'circulatory'
    elif bool(re.match('4[6-9][0-9]|5[0-1][0-9]', text)) == True:
        return 'respiratory'
    elif bool(re.match('5[2-7][0-9]', text)) == True:
        return 'digestive'
    elif bool(re.match('5[8-9][0-9]|6[0-2][0-9]', text)) == True:
        return 'genitourinary'
    elif bool(re.match('6[3-7][0-9]', text)) == True:
        return 'pregnancy'    
    elif bool(re.match('6[8-9][0-9]|70[0-9]', text)) == True:
        return 'skin'   
    elif bool(re.match('7[1-3][0-9]', text)) == True:
        return 'musculoskeletal'       
    elif bool(re.match('7[4-5][0-9]', text)) == True:
        return 'congenital' 
    elif bool(re.match('7[6-7][0-9]', text)) == True:
        return 'perinatal' 
    elif bool(re.match('7[8-9][0-9]', text)) == True:
        return 'symptoms or ill-defined' 
    elif bool(re.match('8[0-9][0-9]|9[0-9][0-9]', text)) == True:
        return 'injuries' 
    elif bool(re.match('E|V', text)) == True:
        return 'suppl' 
    else:
        return 'infectious'
    
def heartDisease(text):
    if bool(re.match('41[0-4]|42[0-5]|427|429|74[5-6]', text)) == True:
        return 1
    return 0
def CAD(text):
    if bool(re.match('41[0-4]|429', text)) == True:
        return 1
    return 0
def cardiomyopathy(text):
    if bool(re.match('42[0-5]', text)) == True:
        return 1
    return 0
def CHF(text):
    if bool(re.match('426', text)) == True:
        return 1
    return 0
def arrhythmias(text):
    if bool(re.match('427', text)) == True:
        return 1
    return 0
def heartdefects(text):
    if bool(re.match('74[5-6]', text)) == True:
        return 1
    return 0
def stroke(text):
    if bool(re.match('43[0-1]|43[3-6]|997.02', text)) == True:
        return 1
    return 0
def sleepApnea(text):
    if bool(re.match('727.23|780.57', text)) == True:
        return 1
    return 0
def gestDiab(text):
    if bool(re.match('648.8', text)) == True:
        return 1
    return 0
def polyOvary(text):
    if bool(re.match('256.4', text)) == True:
        return 1
    return 0
def frozenShoulder(text):
    if bool(re.match('726.0', text)) == True:
        return 1
    return 0
def hemochr(text):
    if bool(re.match('275.03', text)) == True:
        return 1
    return 0
def hepatitis(text):
    if bool(re.match('070.2|070.3', text)) == True:
        return 1
    return 0
def diabCompl(text):
    if bool(re.match('250.[1-3]|250.5|250.8|251.[0-2]|270.3|775.6|962.3', text)) == True:
        return 1
    return 0
def kidneyFailure(text):
    if bool(re.match('58[4-5]', text)) == True:
        return 1
    return 0
def dementia(text):
    if bool(re.match('331|290|294|797', text)) == True:
        return 1
    return 0
def acanthosis(text):
    if bool(re.match('701.2', text)) == True:
        return 1
    return 0
def blindness(text):
    if bool(re.match('369', text)) == True:
        return 1
    return 0
def sDysfunction(text):
    if bool(re.match('302.7', text)) == True:
        return 1
    return 0
def preDiabetes(text):
    if bool(re.match('790.29', text)) == True:
        return 1
    return 0

def stripPeriods(text):
    result = re.sub('\.', "", text)
    return result


# In[6]:

icd_code = diagnosisT['ICD9Code']
diagnosisT['ICD9'] = icd_code.apply(stripPeriods)
diagnosisT['hasHeartDisease'] = icd_code.apply(heartDisease)
diagnosisT['hasCAD'] = icd_code.apply(CAD)
diagnosisT['hasCardiomyo'] = icd_code.apply(cardiomyopathy)
diagnosisT['hasArrhy'] = icd_code.apply(arrhythmias)
diagnosisT['hasHeartDefects'] = icd_code.apply(heartdefects)
diagnosisT['hasCHF'] = icd_code.apply(CHF)
diagnosisT['hasStroke'] = icd_code.apply(stroke)
diagnosisT['hasSleepA'] = icd_code.apply(sleepApnea)
diagnosisT['hasGestDiab'] = icd_code.apply(gestDiab)
diagnosisT['hasPolyO'] = icd_code.apply(polyOvary)
diagnosisT['hasFrozenShoulder'] = icd_code.apply(frozenShoulder)
diagnosisT['hasHemoChr'] = icd_code.apply(hemochr)
diagnosisT['hasHepatitis'] = icd_code.apply(hepatitis)
diagnosisT['hasDiabComp'] = icd_code.apply(diabCompl)
diagnosisT['hasKidneyF'] = icd_code.apply(kidneyFailure)
diagnosisT['hasDementia'] = icd_code.apply(dementia)
diagnosisT['hasAcanthosis'] = icd_code.apply(acanthosis)
diagnosisT['hasBlindness'] = icd_code.apply(blindness)
diagnosisT['hasSDysf'] = icd_code.apply(sDysfunction)
diagnosisT['hasPreDiab'] = icd_code.apply(preDiabetes)


# In[7]:

patientT['isMale'] = patientT['Gender'].apply(lambda gender: gender == 'M')
patientT['isFemale'] = patientT['Gender'].apply(lambda gender: gender == 'F')


# In[8]:

bloodpressure1 = trnscrpT.groupby(['PatientGuid'])[['SystolicBP', 'DiastolicBP']].mean()
bloodpressure2 = trnscrpT.groupby(['PatientGuid'])[['SystolicBP', 'DiastolicBP']].max()
bloodpressure3 = trnscrpT.groupby(['PatientGuid'])[['SystolicBP', 'DiastolicBP']].min()
bloodpressure = pd.concat([bloodpressure1, bloodpressure2, bloodpressure3], axis = 1)
bloodpressure.columns = ['meanSystolicBP', 'meanDiastolicBP', 'maxSystolicBP', 'maxDiastolicBP', 'minSystolicBP', 'minDiastolicBP']
bloodpressure['SystDiff'] = np.abs(bloodpressure['maxSystolicBP'] - bloodpressure['minSystolicBP'])
bloodpressure['DiastDiff'] = np.abs(bloodpressure['maxDiastolicBP'] - bloodpressure['minDiastolicBP'])
bloodpressure['isPreHyp'] = 0
bloodpressure['isStage1HBP'] = 0
bloodpressure['isStage2HBP'] = 0
bloodpressure.loc[((bloodpressure['meanSystolicBP'] >= 120) & (bloodpressure['meanSystolicBP'] < 140)) | ((bloodpressure['meanDiastolicBP'] >= 80) & (bloodpressure['meanDiastolicBP'] < 90)), 'isPreHyp'] = 1
bloodpressure.loc[((bloodpressure['meanSystolicBP'] >= 140) & (bloodpressure['meanSystolicBP'] < 160)) | ((bloodpressure['meanDiastolicBP'] >= 90) & (bloodpressure['meanDiastolicBP'] < 100)), 'isStage1HBP'] = 1
bloodpressure.loc[(bloodpressure['meanSystolicBP'] >= 160) | (bloodpressure['meanDiastolicBP'] >= 100), 'isStage2HBP'] = 1
bloodpressure.loc[bloodpressure['isStage2HBP'] == 1, 'isStage1HBP'] = 0
bloodpressure.loc[bloodpressure['isStage1HBP'] == 1, 'isPreHyp'] = 0
bloodpressure = bloodpressure.reset_index()


# In[9]:

bmi1 = trnscrpT.groupby(['PatientGuid'])['BMI'].mean()
bmi2 = trnscrpT.groupby(['PatientGuid'])['BMI'].max()
bmi3 = trnscrpT.groupby(['PatientGuid'])['BMI'].min()
bmi = pd.concat([bmi1, bmi2, bmi3], axis = 1)
bmi.columns = ['MeanBMI', 'MaxBMI', 'MinBMI']
bmi['isOverweight'] = 0
bmi['isObese'] = 0
bmi.loc[(bmi['MeanBMI'] >= 25) & (bmi['MeanBMI'] < 30), 'isOverweight'] = 1
bmi.loc[bmi['MeanBMI'] >= 30, 'isObese'] = 1
bmi['BMIDiff'] = np.abs(bmi['MaxBMI'] - bmi['MinBMI'])
bmi['NotOverweight'] = 1
bmi.loc[(bmi['isOverweight'] == 1) | (bmi['isObese'] == 1), 'NotOverweight'] = 0 
bmi = bmi.reset_index()


# In[10]:

patientdata = pd.merge(patientT, diagnosisT, how='inner', on=['PatientGuid'])
patientdata = pd.merge(patientT, diagnosisT, how='inner', on =['PatientGuid'])
patientdata = pd.merge(patientdata, bloodpressure, how='inner', on =['PatientGuid'])
patientdata = pd.merge(patientdata, bmi, how='inner', on =['PatientGuid'])
patientdata['Age'] = 2017 - patientdata['YearOfBirth']

print patientdata.columns
y = patientdata[['DMIndicator']]
X = patientdata[['isMale', 'isFemale', 'YearOfBirth', 'StartYear', 'StopYear', 'Acute', 'hasHeartDisease',
                'hasCAD', 'hasCardiomyo', 'hasArrhy', 'hasHeartDefects', 'hasCHF', 'hasStroke', 'hasSleepA',
                'hasGestDiab', 'hasPolyO', 'hasFrozenShoulder', 'hasHemoChr', 'hasHepatitis', 'hasDiabComp',
                'hasKidneyF', 'hasDementia', 'hasAcanthosis', 'hasBlindness', 'hasSDysf', 'hasPreDiab',
                'meanSystolicBP', 'meanDiastolicBP', 'maxSystolicBP', 'maxDiastolicBP', 'minSystolicBP',
                'minDiastolicBP', 'SystDiff', 'DiastDiff', 'isPreHyp', 'isStage1HBP', 'isStage2HBP',
                'MeanBMI', 'MaxBMI', 'MinBMI', 'isOverweight', 'isObese', 'BMIDiff', 'Age']]

print(X.shape, y.shape)
X = X.values
y = y.values


# In[14]:

from keras.models import Sequential
from keras.layers import Dense, Activation
import time


# In[20]:

model = Sequential([
    Dense(32, input_shape=(44,)),
    Activation('relu'),
    Dense(1),
    Activation('softmax'),
])

model.compile(optimizer='rmsprop',
              loss='binary_crossentropy',
              metrics=['accuracy'])

time.sleep(1)
model.fit(X, y, nb_epoch=10, batch_size=32)


# In[18]:

loss, accuracy = model.evaluate(X, y)


# In[19]:

loss, accuracy

