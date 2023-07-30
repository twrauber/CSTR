function [CONT, vLoops, QCont, vLoopsQ] = FindLoopContribution          ...
                                            ( X1, ind, ii2, PC, S2a,    ...
                                              t2lim, loopTsh,           ...
                                              numSamp, S2res,           ...
                                              QSamp, ii1, alfa, MeanTS)
%UNTITLED4 Find most significent 
%   Find each loop contribuition based on T2 and Q test for PCA analysis
%
% Input  Arguments
%
%
% Output Arguments
%
% CONT      - T2 Contribution for the analysis point
% vLoops    - Selected loops based o T2 test
% QCont     - Q Contribution for the analisys samples (QSamp)
%           Col 1 - Index
%           Col 2 - New Variance / Residual Trainning Set Variance
%           Col 3 - Hipotezis 1 Test
%           Col 4 - New Mean x Predited Trainning Set Mean
%           Col 5 - Hipotezis 2 Test
%           Col 6 - Col 2 times Col 4
% vLoopsQ   - Selected loops based o Q test
%% Calculo das contribuicao media de cada malha a partir do ponto incial
%  usando Estatistica T2 e Q
%%

[r1,c1]=size(PC);
cont_medio=zeros(1,r1);

for kk=1:numSamp
    % Calcula os scores
    x=X1(ii2(kk),:);
    T=x*PC;

    % Seleciona os scores de maior contribuicao
    [r,c]=size(T);
    idx=[];
    for j=1:c 
        if (((T(j)/sqrt(S2a(j,j)))^2)>(1/c1)*t2lim)
            idx=[idx j];
        end
    end;
    T_PC=idx; % scores selecionados

    % Calcula a contribuicao de cada malha para os scores selecionados
    cont=[];
    [r,c]=size(T_PC); 
    for i=1:c
        for j=1:r1
            tNum=T_PC(i);
            ti=T(tNum);
            s2i=S2a(tNum,tNum);
            pij=PC(j,tNum);
            aux=(ti/s2i)*pij*x(j);
            if aux>0
                cont(i,j)=aux;
            else
                cont(i,j)=0;
            end
        end
    end

    
    % Totaliza as contribuicoes por sinal
    if c>1
        cont= sum(cont);
    elseif isempty(cont)
        cont=zeros(1,r1);
    end    
    % Salva contribuicao no tempo
    CONT1(kk,:)=cont;
    
    % Calcula contribuicao normalizada
    cont= cont/sum(cont);    

    % Calcula contribuicao media
    cont_medio=cont + cont_medio;
end
cont_medio=cont_medio/kk;

% Ordena as malhas por contribuicao
[B,idx]=sort(cont_medio,'descend'); 
CONT=[ind(idx)' cont_medio(idx)']; % 


% Encontra as malhas que mais contribuem da contribuicao total 
% [r,c]=size(CONT);
% aux=0;
% for i=1:r
%     aux=aux+CONT(i,2);
%     if aux>loopTsh
%         break;
%     end
% end
[r,c]=size(CONT);
for i=1:r
    if CONT(i,2)<loopTsh
        break;
    end
end

if i>2
    vLoops=CONT(1:i-1,:);
else
    vLoops=[];
end;
%% Calcula limite para hipotese alternativa (hipotese nula rejeitada)
%%

n=length(ii1);
[q,mm]=size(QSamp);
[mm,a]=size(PC);

meioAlfa=(1-alfa)/2;
hip1Lim=finv([0 (1-meioAlfa)],q-a-1,n-a-1);
hip1Lim=hip1Lim(2);
hip2Lim=tinv([0 (1-meioAlfa)],q+n-2*a-2);
hip2Lim=hip2Lim(2);

%% Calcula da contribuicao de cada malha usando Estatistica Q
%%

S2=var(QSamp);
M=mean(QSamp);

QCont=zeros(mm,6);
for i=1:mm
    QCont(i,1)=ind(i);
    QCont(i,2)=S2(i)/S2res(i,i);
    QCont(i,3)=QCont(i,2)>hip1Lim;
    s2=max(S2res(i,i),S2(i));
    QCont(i,4)=abs(                                                     ...
                    (M(i)-MeanTS(i))                                    ...
                    /sqrt(                                              ...
                           s2*(                                         ...
                                 (1/(q-a))+                             ...
                                 (1/(n-a))                              ...
                               )                                        ...
                          )                                             ...
                  );
    QCont(i,5)=QCont(i,4)>hip2Lim;    
    QCont(i,6)=QCont(i,2)*QCont(i,4);    
end

idx=find((QCont(:,3)+QCont(:,5))>=1);
vLoopsQ=QCont(idx,:);

% Ordena as malhas por contribuicao
[B,idx]=sort(vLoopsQ(:,6),'descend'); 
vLoopsQ=vLoopsQ(idx,:); % 

%% Result ploting
%%

if 0
%if nargout==0 
    subplot(121);
    [r,c]=size(CONT);
    [r1,c1]=size(vLoops);
    y=zeros(r,c);
    y1=zeros(r,c);
    y(:,1)=CONT(:,1);
    y1(:,1)=CONT(:,1);
    y(1:r1,2)=CONT(1:r1,2);
    y1(r1+1:r,2)=CONT(r1+1:r,2);
    barh(y(:,1),y(:,2),'r'); hold;
    barh(y(:,1),y1(:,2),'b'); hold;
    set(gca,'ytick',min(ind):max(ind)); xlabel('% Contribution');
    ylabel('Loops');
    axis([0 max(y1(:,2))*10 min(ind) max(ind)]);
    title(sprintf('Contribution per sample T2 %d',ii2(1)));

    subplot(122);
    [r,c]=size(QCont);
    [r1,c1]=size(vLoopsQ);
    y=[];
    y=[QCont(:,1) QCont(:,3)+QCont(:,5)];
    barh(y(:,1),y(:,2),'b'); 
    set(gca,'ytick',min(ind):max(ind)); xlabel('Varibles tests violations');
    ylabel('Loops');
    axis([0 3 min(ind) max(ind)]);
    title(sprintf('Contribution per sample Q %d',ii2(1)));
    pause;
end

end

