# Comp.5300 Big Data Design Final Project
# Predict Onset of Diabetes
# Training and testing using nn keras tensorflow

from keras.models import Sequential
from keras.layers import Dense
import numpy

# fix random seed for reproducibility
numpy.random.seed(7)

# load dataset
dataset = numpy.loadtxt("..\data\diabetes.csv", delimiter=",")

# split into input X and output Y variables
X = dataset[:,0:8]
Y = dataset[:,8]

# create the model
model = Sequential()
model.add(Dense(12, input_dim=8, init='uniform', activation='relu'))
model.add(Dense(8, init='uniform', activation='relu'))
model.add(Dense(1, init='uniform', activation='sigmoid'))

# compile the model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

# fit the model
model.fit(X, Y, nb_epoch=150, batch_size=10,  verbose=2)

# calculate the predictions
predictions = model.predict(X)

# round predictions
rounded = [round(x[0]) for x in predictions]

# print the predictions
print(rounded)