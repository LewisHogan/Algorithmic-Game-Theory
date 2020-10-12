% A - The optimal/highest social welfare in bidding

% Each index refers to player i
ctr = [1, 0.55071, 0.4704];
values_per_click = [1000000, 555710, 470400];

format longG;

% The social welfare of an individual allocation can be calculated as a sum
% of the benefits each player gets.

% The optimum social welfare is an instance where the highest ranked value
% per click is matched with the highest click through rank (and so on).

% As the players are already ranked by value per click and so is ctr, this
% can be calculated as a sum of the element wise multiplication of ctr and
% value per click
optimal_social_welfare = ctr .* values_per_click;
disp("Optimal Social Welfare: " + sum(optimal_social_welfare));
disp("Optimal Social Welfare Utilities: ");
disp(optimal_social_welfare);