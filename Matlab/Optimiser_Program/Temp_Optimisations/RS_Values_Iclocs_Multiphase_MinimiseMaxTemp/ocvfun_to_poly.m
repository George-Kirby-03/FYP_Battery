soc = linspace(0,1,100);
OCV = arrayfun(@OCV_Func2, soc);
z = polyfit(soc,OCV,16);
plot(soc,polyval(z,soc))