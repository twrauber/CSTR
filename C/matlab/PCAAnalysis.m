function [Ret]=PCAAnalysis(X0,vlim,CI,ind,ii,force2dim)
%% Calculate calculates the principal components for the trainning set data
%
% Inputs:
%
% X0 = Data matrix  - row samples x colums variables 
% vlim = variability from variables selected ( 0<vlim<1)
% CI = confidence interval ( 0<CI<1)
% ind = variables from X0 to be analyzed
% ii = training sample interval = usually 1:num_train_samples
%
% Outputs:
%
% ind = index used to select loops from data matrix
% X = zero mean and normalized training set (TS) data
% CI = confidence interval ( 0<CI<1)
% m = loops means from TS
% s = standart deviation from TS
% ss = singular values from TS covariance matrix
% a = number of princial components
% PC = Principal components selected
% s2a = singular values from selected auto vectors from TS covariance matrix
% S2res = Residual predicted variance per variable
% t2lim = t2 threshold
% Qlim = Q threshold
%

%% Argument check
%%

[nn,mm]=size(X0);

if nargin==1
    vlim=0.95;
    CI=0.99;
    ind=1:mm;
    ii=1:nn;
    force2dim=false;
elseif nargin==2
    CI=0.99;
    ind=1:mm;
    ii=1:nn;    
    force2dim=false;
elseif nargin==3
    ind=1:mm;
    ii=1:nn;    
    force2dim=false;
elseif nargin==4
    ii=1:nn;    
    force2dim=false;
elseif nargin==5
    force2dim=false;
end;

%% Initialization
%%

Ret.ind=ind;
Ret.X=X0(:,ind);
Ret.CI = CI;

[nn,mm]=size(Ret.X);

%% Mean and standart deviation interval i1
%%

Ret.m=mean(Ret.X(ii,:));
Ret.s=std(Ret.X(ii,:));

%% Remove mean and normalizes full sample
%%
for i=1:mm
    if Ret.s(i)>1e-3
        Ret.X(:,i)=(Ret.X(:,i)-Ret.m(i))/Ret.s(i);
    else
        Ret.X(:,i)=(Ret.X(:,i)-Ret.m(i));
    end
end

%% Principal components decomposition 
%%


if 0 % show the equivalence of lambda = s^2/(n-1)
% http://math.stackexchange.com/questions/3869/what-is-the-intuitive-relationship-between-svd-and-pca
Z = zscore(X0);
n = size(Z,1);
eigenvalues = flipud(eig(cov(Z)));
singularValues = svd(Z);
res = norm( singularValues.*singularValues/(n-1) - eigenvalues) % should be zero
end

x=Ret.X(ii,:); % number of samples lines, number of features columns

[uu,Ret.ss,v]=svd((x'*x)/(length(ii)-1));

%res = norm( flipud(eig(cov(x))) - diag(Ret.ss) ) % should be zero


% ss are NOT the singular values but the eigenvalues of the covariance matrix of the centralized and normalized data

%% finding PC
%%

Ret.a=0;
vv=trace(Ret.ss);
va=0;
for i=1:length(Ret.ss)
    va=va+Ret.ss(i,i);
    if ((va/vv)>=vlim)
        Ret.a=i;
        break;
    end
end
if force2dim
    if( Ret.a < 2 )
        disp('Only less than two PCs');
        return;
    end
    Ret.a = 2;
end
if Ret.a>0 
    PC=uu(:,1:Ret.a);
    S2a=Ret.ss(1:Ret.a,1:Ret.a);
    Ret.PC=PC;
    Ret.S2a=S2a;
else
    disp('Problemas com escolha das CP para atender variancia especificada');
    return
end

%% Find Residual predicted variance per variable
%%

Ret.S2res=zeros(mm,mm);
for j=1:mm
    for i=Ret.a+1:mm
        Ret.S2res(j,j)=Ret.S2res(j,j)+uu(j,i)*Ret.ss(i,i);
    end;
end;

%% Calculates t2 limit
%%

nn=length(ii);
Ret.t2lim=T2Limit(nn, Ret.a, Ret.CI);
%fprintf('PCAAnalysis> nn=%d a=%d alfa=%f vlim=%f\n', nn, Ret.a, CI, vlim );


%% Caculates Q limit
%%

Ret.Qlim = QLimit(Ret.ss, mm, Ret.a, Ret.CI);

end

%%
function [ t2lim ] = T2Limit( nn, a, alfa )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%fprintf('nn=%d a=%d alfa=%f\n', nn, a, alfa );

% L. H. Chiang, E. L. Russell and R. D. Braatz; Fault Detection and Diagnosis in Industrial Systems, p.22 eq (2.10, 2.11)
t2lim= (a*(nn-1)*(nn+1)/(nn*(nn-a)))*finv(alfa,a,nn-a);
%t2lim = chi2inv(alfa,a);

end

%%
function [ Qlim ] = QLimit( ss, mm, a, alfa )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
teta=zeros(1,3);
for i=1:3
    for j=a+1:mm
        teta(i)=teta(i)+ss(j,j)^(i);
    end;
end;
h0=1-(2*teta(1)*teta(3)/(3*teta(2)^2));
Calfa=norminv([0 alfa],0,1);
Calfa=Calfa(2);
Qlim = teta(1)*(                                                        ...
                (                                                       ...
                  (Calfa*sqrt(2*teta(2)*h0^2)/teta(1))                  ...
                  + 1                                                   ...
                  + (teta(2)*h0*(h0-1)/(teta(1)^2))                     ...
                )^(1/h0)                                                ...
               );
end
