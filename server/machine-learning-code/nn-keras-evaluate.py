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
model.add(Dense(12, input_dim=8, activation='relu'))
model.add(Dense(8, activation='relu'))
model.add(Dense(1, activation='sigmoid'))

# compile the model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

# fit the model
model.fit(X, Y, epochs=150, batch_size=10)

# evaluate the model
scores = model.evaluate(X, Y)
print("\n%s: %.2f%%" % (model.metrics_names[1], scores[1]*100))