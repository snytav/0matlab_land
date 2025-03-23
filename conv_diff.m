%https://in.mathworks.com/matlabcentral/answers/231379-pdepe-matlab-convection-diffusion
sol = pdepe(m,@ParticleDiffusionpde,@ParticleDiffusionic,@ParticleDiffusionbc,x,t);
global Ds;
Ds =1.0;
% Extract the first solution component as u.
u = sol(:,:,:); 

function [c,f,s] = ParticleDiffusionpde(x,t,u,DuDx)
global Ds 
c = 1/Ds;
f = DuDx;
s = 0;

function u0 = ParticleDiffusionic(x)
global qo
u0 = qo;

function [pl,ql,pr,qr] = ParticleDiffusionbc(xl,ul,xr,ur,t,x)

global Ds K n
global Amo Gc kf rhop
global uavg
global dr R nr

sum = 0;
for i = 1:1:nr-1
r1 = (i-1)*dr; % radius at i
r2 = i * dr; % radius at i+1
r1 = double(r1); % convert to double precision
r2 = double(r2);
sum = sum + (dr / 2 * (r1*ul+ r2*ur));
end;
uavg = 3/R^3 * sum;

ql = 1;
pl = 0;

qr = 1;
pr = -((kf/(Ds.*rhop)).*(Amo - Gc.*uavg - ((double(ur/K)).^2).^(n/2) ));

dq(r,t)/dt = Ds( d2q(r,t)/dr2 + (2/r)*dq(r,t)/dr );

q(r, t=0) = 0

dq(r=0, t)/dr = 0

dq(r=dp/2, t)/dr = (kf/Ds*rhop) [C(t) - Cp(at r = dp/2)]

% q = solid phase concentration of trace compound in a particle with radius dp/2
% 
% C = bulk liquid concentration of trace compound
% 
% Cp = trace compound concentration at particle surface