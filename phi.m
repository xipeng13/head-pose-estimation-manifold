%phi.m - Basic function
%Here we consider the bi-harmonic basic function in 3D, phi(r)=|r|. 
function u=phi(r)
%
% Function phi of r
%
% Syntax [u] = phi(r)
%
% Remember if using something like the thinplate spline
 
% in 2D you will need to test for r nonzero before 
% taking the log.

%u =r ;

%u=r.^3;

% thinplate spline

m=(r~=0);

u=zeros(size(r));

u(m)=r(m).*r(m).*log(r(m));

% Gaussian

%u=exp(-0.5*(r.*r)/2.0);