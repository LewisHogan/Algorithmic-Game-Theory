% Order of Constraints
% Pxa Pxb Pxc Pya Pyb Pyc Pza Pzb Pzc

A = [
    % Row Constraints
    [1, 1, 0, 0, 0, 0, 0, 0, 0];     % 1Pxa + 1Pxb + 0Pxc
    [-3, 0, 0.5, 0, 0, 0, 0, 0, 0];  % - 3Pxa + 0Pxb + 0.5Pxc
    [0, 0, 0, -1, -1, 0, 0, 0, 0];   % - 1Pya - 1Pyb + 0Pyc
    [0, 0, 0, -4, -1, 0.5, 0, 0, 0]; % - 4Pya - 1Pyb + 0.5Pyc
    [0, 0, 0, 0, 0, 0, 3, 0, -0.5];  % 3Pza + 0Pzb - 0.5Pzc
    [0, 0, 0, 0, 0, 0, 4, 1, -0.5];  % 4Pza - 1Pzb - 0.5Pzc
    % Column Constraints
    [1, 0, 0, 1, 0, 0, 0, 0, 0];     % 1Pax + 1Pay + 0Paz
    [-3, 0, 0, 0, 0, 0, 0.5, 0, 0];  % - 3Pax + 0Pay + 0.5Paz
    [0, -1, 0, 0, -1, 0, 0, 0, 0];   % - 1Pbx - 1Pby + 0Pbz
    [0, -4, 0, 0, -1, 0, 0, 0.5, 0]; % - 4Pbx - 1Pby + 0.5Pbz
    [0, 0, 3, 0, 0, 0, 0, 0, -0.5];  % 3Pcx + 0Pcy - 0.5Pcz
    [0, 0, 4, 0, 0, 1, 0, 0, -0.5];  % 4Pcx + 1Pcy - 0.5Pcz
];

% All the above constraints resolve to <= 0
b = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

% All probabilities must be <= 1 (as 1 is 100% chance)
Aeq = [1, 1, 1, 1, 1, 1, 1, 1, 1];

% All probabilities must sum to 1 (every player must make a choice)
beq = 1;

lb = [0, 0, 0, 0, 0, 0, 0, 0, 0];
ub = [1, 1, 1, 1, 1, 1, 1, 1, 1];

% Corresponds to the sum of all player's utilities, negated as we will want
% to maximise this (and linprog minimises)
f = -[6, 4, 0, 4, 2, 0, 0, 0, 1];

[probabilities, utility] = linprog(f, A, b, Aeq, beq, lb, ub);
disp(probabilities);

% Since that result technically minimizes the result, the actual utility is
% negated
disp(-utility);