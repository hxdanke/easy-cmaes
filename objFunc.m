%   Objective function (change for different optimisation problems)
function value = objFunc(x,y)  % Number of inputs must match dimension
    value = (x-y)./((x.^2+5).*(y.^2+5) + (y.^2)/20000); % "Butterfly" function
end