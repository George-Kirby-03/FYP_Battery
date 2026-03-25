%Function to provide a piecewise function to fit the OCV-SOC curve
function OCV = OCV_Func2(SOC)

% 0-0.001 first order polynomial
if 0<=SOC && SOC<0.001
    a0 = 2.114;
    a1 = 546.6;

    OCV = a1*SOC + a0;

% 0.001-0.2 fifth order polynomial
elseif 0.001<=SOC && SOC<0.2
    b0 = 2.6606;
    b1 = 19.2751287976418;
    b2 = -294.323209037854;
    b3 = 2292.30177988178;
    b4 = -8752.26466684135;
    b5 = 13011.4758901643;
    
    OCV = b5*(SOC-0.001)^5 + b4*(SOC-0.001)^4 + b3*(SOC-0.001)^3 + b2*(SOC-0.001)^2 + b1*(SOC-0.001) + b0;

% 0.2-0.875 first order polynomial
elseif 0.2<=SOC && SOC<0.875
    c0 = 3.24054;
    c1 = 0.238375166484958;

    OCV = c1*(SOC-0.2) + c0;

% 0.875-0.92 second order polynomial
elseif 0.875<=SOC && SOC<0.92
    d0 = 3.40144323737735;
    d1 =  0.2384;
    d2 = 47.8252524850066;

    OCV = d2*(SOC-0.875)^2 + d1*(SOC-0.875) + d0;

% 0.92-0.95 third order polynomial
elseif 0.92<=SOC && SOC<0.95
    e0 = 3.50901737365949;
    e1 = 6.51803463624783;
    e2 = -171.898504724183;
    e3 = 1479.95394340857;

    OCV = e3*(SOC-0.92)^3 + e2*(SOC-0.92)^2 + e1*(SOC-0.92) + e0;

% 0.95-1 first order polynomial
elseif 0.95<=SOC && SOC<=1
    f0 = 3.58980851496719;
    f1 = 0.203829700656266;

    OCV = f1*(SOC-0.95) + f0;

%SOC cannot be outside of 0-100
elseif SOC<0
    OCV = 2.114;
    %disp('Error, SOC must be within 0-1')
elseif SOC>1
    OCV = 3.6;
    %disp('Error, SOC must be within 0-1')

else
    disp('Unknown error')
end
