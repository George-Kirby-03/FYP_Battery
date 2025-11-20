function out = IndexOfZfinal(x)
zfinal=0.8;
kmax = size(x,1)/4;
z = x(3:4:(4*kmax-1),1);
y = find(z >= zfinal, 1);
if isscalar(y)
    out=y/(kmax+1);
else
    out=1;
end