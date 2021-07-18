%   Function to find a set number of minimum values in a vector with indices
function [sorted,i] = mink(x,k)
    n = size(x);
    [x_sorted,I] = sort(x, 'ascend');
    sorted = x_sorted(1:k);
    i = I(1:k);
end