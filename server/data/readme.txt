- install mongodb via "https://www.mongodb.com"

- add mongodb install location to your sytem path, if windows:
"C:\Program Files\MongoDB\Server\3.4\bin"

- create this folder: "C:\data\db"

- start a mongodb service instance via opening a cmd prompt and typing:
"mongod"

- unzip the test and training data files found at these links
to a local folder:
https://github.com/Itelina/DiabetesPrediction/blob/master/testSet.zip
https://github.com/Itelina/DiabetesPrediction/blob/master/trainingSet.zip

- cd to the folder where the csv datafiles are located and run the
batch file "mongodb-import.bat"