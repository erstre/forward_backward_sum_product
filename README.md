# Sum-product algorithm in MATLAB
Matlab implementation of [Forward-backward Sum-product](https://ocw.mit.edu/courses/6-438-algorithms-for-inference-fall-2014/07fd05499a8596682dedce6fd0a229c3_MIT6_438F14_Lec9.pdf) algorithm for analyzing the behavior of S&P 500 index over a period of time: Sept 30, 2013 to Sep 28, 2014.

## Description
The sum-product algorithm is a powerful technique used in probabilistic graphical models to efficiently compute marginal probabilities and other quantities of interest. The algorithm operates on a factor graph, which represents a factorization of a joint probability distribution into smaller, more manageable pieces. The algorithm works by passing messages between nodes of the factor graph, which allows for the computation of the marginal probabilities of each variable in the graph. The sum-product algorithm is widely used in a variety of applications, including machine learning, computer vision, and speech recognition.

In this project, we analyze the behavior of S&P 500 index over a period of time: Sept 30, 2013 to Sep 28, 2014. Specifically this MATLAB code:

- Impements the Forward-backward Sum-product algorithm.
- It uses the sp500.mat dataset.
- It plots the probability that the economic state is 'good' given a set of observations.
- It prints the probability that the economy is in a good state in week 52, i.e., the last week in the simulation.

### Prerequisites

The following software needs to be installed.

- MATLAB

## Authors

[Errikos Streviniotis](https://www.linkedin.com/in/errikos-streviniotis/)
