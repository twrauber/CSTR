function [Ret]=PCAFaultTest(PcaTS,X0,Ts,loopTsh,ewmaT2Q,ii,op)
%% Calculate T2 statistic for the input data
%
% Inputs:
%
% PcaTS - Returned structure from function PCAAnalysis
% X0 = Data matrix  - row samples x colums variables 
% Ts = sampling interval
% loopTsh = loop minimal theshold to be considered ( loopTsh>0)
% ewmaT2Q = ewmaT2Q filter  ( 0<ewmaT2Q<1)
% ii = interval that contains data to be tested
% op = option 0-only t2 test; 1-t2 and Q test (defaut)
%
% OutPuts:
%
% X = zero mean and normalized input data
% t2 = t2 statistic in time
% Q = Q statistic in time
% T = scores matrix for each sample point
% idx = violation sample number
% LoopCtb = all loops contribution for violation (t2 statistic)
% vLoops = loops that most contributed for violation (t2 statistic)
% QCont = all loops contribution for violation (Q statistic)
% vLoopsQ = loops that most contributed for violation (Q statistic)
%

%% Argument check
%%

[nn,mm]=size(X0);

if (nargin <2)
    disp('wrong parameters');
    return;
elseif nargin==2
    Ts=1.0;
    loopTsh=0.01;
    ewmaT2Q=0.5;
    ii=1:nn;
    op=1;
elseif nargin==3
    loopTsh=0.01;
    ewmaT2Q=0.5;
    ii=1:nn;
    op=1;
elseif nargin==4
    ewmaT2Q=0.5;
    ii=1:nn;
    op=1;
elseif nargin==5
    ii=1:nn;
    op=1;
elseif nargin==6
    op=1;
end;

%% Initialization
%%

Ret.X=X0(:,PcaTS.ind);
[nn,mm]=size(Ret.X);

t=([0 1:(nn-1)]*Ts)'; % time vector

%% Remove mean and normalizes full sample
%%
for i=1:mm
    if PcaTS.s(i)>1e-3
        Ret.X(:,i)=(Ret.X(:,i)-PcaTS.m(i))/PcaTS.s(i);
    else
        Ret.X(:,i)=(Ret.X(:,i)-PcaTS.m(i));
    end
end

%% Caculates t2/Q statistic
%%

t2f=zeros(1,length(ii));
Qf=zeros(1,length(ii));
Ret.t2=zeros(1,length(ii));
Ret.Q=zeros(1,length(ii));
Ret.T=zeros(length(ii),PcaTS.a);

it2Vlt=0;
for i=2:length(ii)
    
    % Sample
    x=Ret.X(ii(i),:);
    
    % Scores
    Ret.T(i,:)=x*PcaTS.PC;
    
    % T2 test
    Ret.t2(i)=x*(PcaTS.PC*(PcaTS.S2a^-1)*PcaTS.PC')*x';
    t2f(i)=ewmaT2Q*Ret.t2(i)+(1-ewmaT2Q)*t2f(i-1);

    % Q Test
    r=(eye(mm)-PcaTS.PC*PcaTS.PC')*x';
    Ret.Q(i)=r'*r;
    Qf(i)=ewmaT2Q*Ret.Q(i)+(1-ewmaT2Q)*Qf(i-1);
 
    % T2 check (violation index)
    if t2f(i)>PcaTS.t2lim
       %fprintf('i=%3d t2f=%15.2f t2lim=%7.2f\n',i,t2f(i),PcaTS.t2lim);
    end
    if op==0 
        if (it2Vlt==0)&&(t2f(i)>PcaTS.t2lim) 
            it2Vlt=i;
        end;
    % T2 and Q limit check (violation index)
    else
        if (it2Vlt==0)&&((t2f(i)>PcaTS.t2lim)&&(Qf(i)>PcaTS.Qlim)) 
            it2Vlt=i;
        end;
    end;
end;

%% Find the viotation point to be analysed and the main contribution loops
%%

if (it2Vlt >0) && (it2Vlt <= length(ii))

    Ret.idx=ii(it2Vlt);
    t2NSamp=1;
    X1=Ret.X;

    t2fxx=t2f(it2Vlt+1:length(t2f));
    i3=Ret.idx:ii(it2Vlt+find(t2fxx==max(t2fxx)));
    X_QSamp=Ret.X(i3,:);

    % [Ret.LoopCtb, Ret.vLoops] = FindLoopContrib ( X1, PcaTS.ind, i3, ...
    %                                               PcaTS.PC, PcaTS.S2a, ...
    %                                               PcaTS.t2lim,  vlim, t2NSamp);

    [Ret.LoopCtb, Ret.vLoops, Ret.QCont, Ret.vLoopsQ] =                 ...
    FindLoopContribution                                                ...
    ( X1, PcaTS.ind, i3, PcaTS.PC, PcaTS.S2a, PcaTS.t2lim, loopTsh,t2NSamp,...%t2
      PcaTS.S2res, X_QSamp, ii, PcaTS.CI, PcaTS.m);                          %Q

else
    Ret.LoopCtb=[];
    Ret.vLoops=[];
    Ret.QCont=[];
    Ret.vLoopsQ=[];
    disp('no treshold volation detected');
end;

%% Result Ploting
%%
if 0
%if (nargout==0) && (it2Vlt >0) && (it2Vlt <= length(ii))
    subplot(131);
    plotsignal(Ret.X(ii,:),t(ii));title('Normalized Variables');
    subplot(132);
    plot(t(ii),Ret.t2,t(ii),t2f,t(Ret.idx),t2f(it2Vlt),'r*');title('T2 and threshold');
    line([1 max(t)], [PcaTS.t2lim PcaTS.t2lim]);
    axis([min(t(ii)) max(t(ii)) 0 max([PcaTS.t2lim max(Ret.t2)])]);
    subplot(133);
    plot(t(ii),Ret.Q,t(ii),Qf,t(Ret.idx),Qf(it2Vlt),'r*');title('Q and threshold');
    line([1 max(t)], [PcaTS.Qlim PcaTS.Qlim]);
    axis([min(t(ii)) max(t(ii)) 0 max([PcaTS.Qlim max(Ret.Q)])]);
end;
