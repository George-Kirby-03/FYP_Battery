function x = polymodel(data,p,x1,sol)
%POLYMODEL Summary of this function goes here
%   Detailed explanation goes here
    arguments
        data
        p
        x1
        sol = 0  
    end

x = 0;

if isfield(data,'ocv_curve')
    
    x = data.ocv_curve(x1);
else
    poly_length = length(data.poly.xe);
    if sol ~= 1  %solution param is a vector, problem param is a matrix
      for i=1:poly_length
         x = x + p(:,i).*x1.^(i-1);
      end
    else    
      for i=1:poly_length
         x = x + p(i).*x1.^(i-1);
      end
    end
end

end