function x = polymodel(data,p,x1)
%POLYMODEL Summary of this function goes here
%   Detailed explanation goes here
poly_length = size(data.poly.xe);
x = 0;
for i=1:poly_length
    x = x + p(:,i).*x1.^(i-1);
end
end