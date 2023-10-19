#save this file as hello.py in your repo
import tensorflow as tf
import torch

# Simple hello world using TensorFlow
hello = tf.constant('Hello, TensorFlow!')
tense = torch.zeros(3, 3)

# Start tf session
sess = tf.Session()

# Run the op
print(sess.run(hello))
print(tense)