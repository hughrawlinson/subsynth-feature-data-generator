# Subsynth Feature Data Generator

A little ChucK program that builds a subtractive synthesizer that can be triggered to randomly set each of its synthesis parameters, which is plugged into a set of feature extractors. Each buffer, the program outputs a line of CSV containing each of the synthesis parameters and the buffer's spectral features.

The goal of this project was to generate data with which to train a neural network to regress the relationship between audio features and the parameters of this specific synthesizer. If you're good with designing and/or training neural nets, let me know.
