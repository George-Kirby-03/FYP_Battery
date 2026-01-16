x = 0:0.01:1;
p = plot(nan,nan);
p.XData = x;
for n = 1:0.5:5
      p.YData = x.^n;
      exportgraphics(gcf,'testAnimated.gif','Append',true);
end