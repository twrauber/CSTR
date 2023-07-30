%@book{potter2011mechanics,
%  title={Mechanics of Fluids SI Version},
%  author={Potter, M. and Wiggert, D. and Ramadan, B.},
%  isbn={9781439062036},
%  lccn={2010941455},
%  year={2011},
%  publisher={Cengage Learning}
%}


%	p. 762



clear;
%Given Data
global H R P;
L=[50 100 300];
D=[0.15 0.10 0.10];
f=[0.020 0.015 0.025];
K=[2 1 1];
H=[10 30 15];
g=9.81;
p=20000;
%Evaluate equivalent lengths and resistence coefficients
Le=D.*K./f;
R=8*f.*(L+Le)./(g*pi^2*D.^5);
%Initial estimates of unknowns x0=[HB Q1 Q2 Q3]
x0=[20 0.05 0.05 0.05];
%Call function file g.m and solve for unknows
options=optimset ('precondbandwidth', Inf);
[x, fval] = fsolve('g', x0, options);

x
