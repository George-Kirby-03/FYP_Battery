function f = myQ(y)
    % state.u contains the solution at the current points
     
    if y<0.0045
       f = 20000*y;
       disp("efresfeserr")
    else
        f =  55*y;
        disp("Herr")
    end
end