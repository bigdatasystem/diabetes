import pymongo
import json
from pymongo import MongoClient

client = MongoClient("localhost", 27017, maxPoolSize=50)

collection = client.test.SyncCondition # pymongoObj.databaseName.table
print(collection.count()) # number of rows in table

cursorAll = collection.find({}) # filter is empty to get all records
for document in cursorAll: # loop thru rows in table
  print(document) # print all columns
  print(document["ConditionGuid"]) # print single column
  
print("");
  
cursorNoKnownAllergies = collection.find({"Code": "NOKNOWNALLERGIES"}) # filter on getting items where column = 'Code' and data = 'NOKNOWNALLERGIES'
for document in cursorNoKnownAllergies: # loop thru rows in table
  print(document) # print all columns
  print(document["ConditionGuid"]) # print single column