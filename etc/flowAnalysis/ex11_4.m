%@book{potter2011mechanics,
%  title={Mechanics of Fluids SI Version},
%  author={Potter, M. and Wiggert, D. and Ramadan, B.},
%  isbn={9781439062036},
%  lccn={2010941455},
%  year={2011},
%  publisher={Cengage Learning}
%}


%	p. 760






clear;
%Given Data
global H R;
L=[500 750 1000];
D=[0.10 0.15 0.13];
f=[0.025 0.020 0.018];
K=[3 2 7];
H=[5 20 13];
g=9.81;
%Evaluate equivalent lengths and resistence coefficients
Le=D.*K./f;
R=8*f.*(L+Le)./(g*pi^2*D.^5);
%Initial estimates of unknowns x0=[HB Q1 Q2 Q3]
x0=[14 0.01 0.01 0.01];
%Call function file f.m and solve for unknows
options=optimset ('precondbandwidth',Inf);
[x, fval] = fsolve('f', x0, options);
x

