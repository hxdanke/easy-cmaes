%   Initial parameters (change for different optimisation problems)
dim = 2;    % Dimension
popSize = 20;  % Generation size
offSize = 3; % Offspring size
initMean = [5; 5];  % n*1, size n must match dimension
initStd = [5; 5];   % n*1, size n must match dimension
evalNum = 1000;    % Number of evaluations/iterations
evalLim = 1e-10; % Lower limit of objective function to terminate optimisation
visSpeed = 3;   % Visualisation speed (0 slow, 1 medium, 2 fast, 3 very fast, >3 no visual)
%   objFunc also needs to be defined for different optimisation problems

% ---------------------------------------------------------------------------- %

%   Initialise variables
currGen = [];   % Current generation vector
currGenObj = [];  % Objective function values of current generation
minCurrGen = [];    % Best current generation children
minCurrGenObj = []; % Objective function values of best current genenation children
minPrevGenObj = objFunc(initMean(1),initMean(2)); % Previous generation
contOpt = true;    % Boolean to continue optimisation
genCount = 1;    % Generation counter
currMean = initMean;    % currMean
std = initStd;  % Standard deviation
c = []; % Covariance matrix
cNew = [];  % New covariance matrix
meanNew = [];   % New currMean
stdNew = [];    % New standard deviation
vec = [];   % Vector from old currMean to new currMean
optRes = [];   % Vector to contain the result
fitness = 10000;    % Fitness

% ---------------------------------------------------------------------------- %

%   Plot objective function
figure;
[X,Y] = meshgrid(-10:0.1:10);
H = objFunc(X,Y);
contourf(X,Y,H,20);
xlabel("x");
ylabel("y");
hold on;
%p = plot(-1.296, 1.281, 'g+', 'MarkerSize', 10);
if visSpeed == 0
    pause(1);
elseif visSpeed == 1
    pause(0.5);
elseif visSpeed == 2
    pause(0.2);
elseif visSpeed == 3
    pause(0.05);
end

% ---------------------------------------------------------------------------- %

%   Initial distribution
x = initStd(1) * randn(popSize, 1) + currMean(1);
y = initStd(2) * randn(popSize, 1) + currMean(2);
c = [cov(x,x) cov(x,y);cov(y,x), cov(y,y)];
currGen = [x y];
%   Plot 1st generation
p = plot(x, y, 'ro');
if visSpeed == 0
    pause(0.5);
elseif visSpeed == 1
    pause(0.2);
elseif visSpeed == 2
    pause(0.1);
elseif visSpeed == 3
    pause(0.02);
end

% ---------------------------------------------------------------------------- %

%   Iterative optimisation
while contOpt
    %   Evaluate objective function for current generation
    for i = 1:1:popSize
        currGenObj(i,1) = objFunc(currGen(i,1), currGen(i,2));
    end
    %   Find the best offsprings for new generation
    [minCurrGenObj, ind] = mink(currGenObj, offSize);
    for i = 1:1:offSize
        for j = 1:1:2
            minCurrGen(i,j) = currGen(ind(i),j);
        end
    end
    %   Compute fitness
    fitness = abs(mean(minCurrGenObj) - mean(minPrevGenObj))
    minPrevGenObj = minCurrGenObj;
    %   Plot best offsprings
    delete(p);
    p = plot(minCurrGen(:,1),minCurrGen(:,2), "ro");
    if visSpeed == 0
        pause(1);
    elseif visSpeed == 1
        pause(0.5);
    elseif visSpeed == 2
        pause(0.2);
    elseif visSpeed == 3
        pause(0.05);
    end
    %   Compute vector of moving currMean
    meanNew = mean(minCurrGen);
    vec = transpose(meanNew - currMean);
    %   Covariance matrix adaptation
    cNew = 0.8 * c + 0.2 * vec * transpose(vec);
    %   Generate new distribution and plot
    newGen = mvnrnd(meanNew, cNew, popSize);
    delete(p);
    p = plot(newGen(:,1), newGen(:,2), "ro");
    %   Overwrite distribution for next generation
    currMean = meanNew;
    c = cNew;
    currGen = newGen;
    if visSpeed == 0
        pause(0.5);
    elseif visSpeed == 1
        pause(0.2);
    elseif visSpeed == 2
        pause(0.1);
    elseif visSpeed == 3
        pause(0.02);
    end
    %   Increment generation counter by 1
    genCount += 1;
    %   Check if optimisation should stop
    if fitness < evalLim
        contOpt = false;
    elseif genCount > evalNum
        contOpt = false;
    end
end

%   Get result and plot
optRes = currMean;
delete(p);
p = plot(currMean(1),currMean(2),"ro");
optRes