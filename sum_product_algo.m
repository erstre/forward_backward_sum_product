%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implementation of forward-backward Sum-product algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all;
close all;

% load the dataset
load('dataset/sp500.mat');
n = size(price_move); % size of the dataset

% initialize alpha and beta messages
alpha_x_Good = -100 * ones(n); % random value
alpha_x_Bad = -100 * ones(n); % random value
beta_x_Good = -100 * ones(n); % random value
beta_x_Bad = -100 * ones(n); % random value

% initialize the parameters of the algorithm
% q is the probability that the price movement is 'up' given that the
% economic state is 'good' and the probability that the price movement is 'down' given that the
% economic state is 'bad'
q = 0.9;                    % q is equal to 0.7 or 0.9
p_x_eq_xNext = 0.8;         % x_{t+1} = x_{t} with probability 0.8    
p_x1_bad = 0.2;             % p(x_{1} = 'bad') = 0.2
p_yPos_given_xGood = q;     % p(y = 1|x = 'good')
p_yNeg_given_xBad = q;      % p(y = -1|x = 'bad')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alpha messages (or forward messages)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize first alpha message
% from theory we know that: a_{1}(x_{1}) = P(x_{1},y_{1})
if price_move(1) == 1
    alpha_x_Good(1) = p_yPos_given_xGood * (1 - p_x1_bad);
    alpha_x_Bad(1) = (1 - p_yNeg_given_xBad) * p_x1_bad;
else
    alpha_x_Good(1) = (1 - p_yPos_given_xGood) * (1 - p_x1_bad);
    alpha_x_Bad(1) = p_yNeg_given_xBad * p_x1_bad;
end

% all the rest alpha messages
for i = 2:1:n(1)
    if price_move(i) == 1
        % Calculations for alpha good
        pos_part_alphaGood = alpha_x_Good(i-1) * p_x_eq_xNext * p_yPos_given_xGood;
        neg_part_alphaGood = alpha_x_Bad(i-1) * (1 - p_x_eq_xNext) * p_yPos_given_xGood;
        alpha_x_Good(i) = pos_part_alphaGood + neg_part_alphaGood;
    
        % Calculations for alpha bad
        pos_part_alphaBad = alpha_x_Good(i-1) * (1 - p_x_eq_xNext) * (1 - p_yNeg_given_xBad);
        neg_part_alphaBad = alpha_x_Bad(i-1) * p_x_eq_xNext * (1 - p_yNeg_given_xBad);
        alpha_x_Bad(i) = pos_part_alphaBad + neg_part_alphaBad;
    else
        % Calculations for alpha good
        pos_part_alphaGood = alpha_x_Good(i-1) * p_x_eq_xNext * (1 - p_yPos_given_xGood);
        neg_part_alphaGood = alpha_x_Bad(i-1) * (1 - p_x_eq_xNext) * (1 - p_yPos_given_xGood);
        alpha_x_Good(i) = pos_part_alphaGood + neg_part_alphaGood;
    
        % Calculations for alpha bad
        pos_part_alphaBad = alpha_x_Good(i-1) * (1 - p_x_eq_xNext) * p_yNeg_given_xBad;
        neg_part_alphaBad = alpha_x_Bad(i-1) * p_x_eq_xNext * p_yNeg_given_xBad;
        alpha_x_Bad(i) = pos_part_alphaBad + neg_part_alphaBad;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beta messages (or backward messages)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize first beta message
% from theory we know that: b_{N}(x_{N}) = 1
beta_x_Good(n(1)) = 1;
beta_x_Bad(n(1)) = 1;

% all the rest beta messages
for i=n(1)-1:-1:1
    if price_move(i+1) == 1
        % Calculations for beta good
        pos_part_betaGood = p_yPos_given_xGood * p_x_eq_xNext * beta_x_Good(i+1);
        neg_part_betaGood = (1 - p_yNeg_given_xBad) * (1 - p_x_eq_xNext) * beta_x_Bad(i+1);
        beta_x_Good(i) = pos_part_betaGood + neg_part_betaGood;
    
        % Calculations for beta bad
        pos_part_betaBad = p_yPos_given_xGood * (1 - p_x_eq_xNext) * beta_x_Good(i+1);
        neg_part_betaBad = (1 - p_yNeg_given_xBad) * p_x_eq_xNext * beta_x_Bad(i+1);
        beta_x_Bad(i) = pos_part_betaBad + neg_part_betaBad;
    else
        % Calculations for beta good
        pos_part_betaGood = (1 - p_yPos_given_xGood) * p_x_eq_xNext * beta_x_Good(i+1);
        neg_part_betaGood = p_yNeg_given_xBad * (1 - p_x_eq_xNext) * beta_x_Bad(i+1);
        beta_x_Good(i) = pos_part_betaGood + neg_part_betaGood;
    
        % Calculations for beta bad
        pos_part_betaBad = (1 - p_yPos_given_xGood) * (1 - p_x_eq_xNext) * beta_x_Good(i+1);
        neg_part_betaBad = p_yNeg_given_xBad * p_x_eq_xNext * beta_x_Bad(i+1);
        beta_x_Bad(i) = pos_part_betaBad + neg_part_betaBad;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gamma calculation (for x_t = 'good' given y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize gamma
gamma = -100 * ones(n); % random value

% calculate gamma using alpha and beta messages
% specifically we calculate the the probability 
% that the economy is in a good state for each week
for i=(1:1:n(1))
    gamma(i) = (alpha_x_Good(i) * beta_x_Good(i))/(alpha_x_Good(i) * beta_x_Good(i) + alpha_x_Bad(i) * beta_x_Bad(i));
end

% plot p(x = 'Good' given all observations)
plot(gamma,'-o')
hold on
plot(price_move,'*')
hold off
legend('p(x = good|y)','price move', 'Location', 'SouthEast')
grid on

% print the probability that the economy is in a good state in the last week
fprintf('The probability that the economy is in a good state in week 52: %f \n', gamma(n(1)))
