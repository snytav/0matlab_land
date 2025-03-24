
% https://in.mathworks.com/matlabcentral/answers/437177-solving-advection-diffusion-pde
function [u] = ConvectionDiffusion(x,t,u0,D,V)
close all;
% clear all;
m = 0;
% x = linspace(0,5,100);
% t = linspace(0,10,100);

sol = pdepe(m,@pdefun,@icfun,@bcfun,x,t);
figure;
plot(x,sol(1,:));
title('initial conditions')
hold on;
[X,Y] = meshgrid(x,t);
figure;
%surf(X,Y,sol);
%colorbar;
plot(x,sol(end,:),'Color','red');
title('final moment');

function [g,f,s] = pdefun(x,t,c,DcDx)
D = 900;
v = 0;
g = 1;
f = D*DcDx;
s = -v*DcDx;
end

function c0 = icfun(x)
if x > 0.5 && x < 1.0
    c0 = 2;
else
    c0 = 1;
end
end

function [pl,ql,pr,qr] = bcfun(xl,cl,xr,cr,t)
pl = cl -10;
ql = 1;
pr = cr;
qr = 1;
end
end