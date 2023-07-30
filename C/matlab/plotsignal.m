function [X,X0]=plotsignal(Y,T,win,strXLabel,ind,indTxT);
% Ultima atualização: 14/04/2011
[N,c]=size(Y);
if c>N Y=Y';[N,c]=size(Y);end;
if (nargin==1 || isempty(T)) T=1:1:N;end;
if nargin<=2 win=0;end;
if nargin<=3 strXLabel='';end;
if nargin<=4 ind=1:c;end;
if nargin<=5 
    indTxT={};
	for i=1:length(ind)
        indTxT{i}=num2str(ind(i));
    end
end;
if length(T)==1 T=(1:N)*T;end;
[N1,c1]=size(T);if c1>N1 T=T';[N1,c1]=size(T);end;
X=[];
X0=[];
s=0;
for l=1:c
    x=Y(:,l);
    x=x-mean(x);
    if (max(abs(x))>0) x=s+x/max(abs(x)); end;
    X=[X x];
    X0=[X0 s*ones(size(x))];
    s=s+1;
end;
    if nargout==0
        plot(T,X,T,X0,'-.b');grid;
        ts=T(2)-T(1);
        if (max(max(X))> min(min(X)))
            axis([min(T)+win*ts max(T)  min(min(X)) max(max(X))]);
        else
            axis([min(T)+win*ts max(T)  0 c+1 ]);
        end;
        set(gca,'ycolor',[.831 0.816 .784]);shg;
        set(gca,'yticklabel',{});
        for i=1:c
            p=(max(T)-(min(T)+win*ts))/20;
            text(min(T)+win*ts-p,i-1,indTxT{i});
        end;
         xlabel(strXLabel);
    end