%Plota os dados lidos pelos sensores
load cstr18.txt;

cstr_matlab = cstr18;
class = cstr_matlab(:,size(cstr_matlab,2));
cstr_matlab = cstr_matlab(:,1:(size(cstr_matlab,2)-1));

[data_size,~] = size(cstr_matlab);
lineLength = 0.5;
lineLength2 = 0.5;
headWidth = 4;
headLength = 4;
dotSize = 300;

% X = cstr_matlab;
% size(X);
% meanX = mean(X,1);
% X = bsxfun(@minus,X,meanX);
% [V,D] = eig(cov(X));
% size(V)
% cstr_pca = cstr_matlab*(V');

[~, cstr_pca] = pca(cstr_matlab);
fig = figure('Position',[250 100 800 600]);
title('cstr18','FontSize',12);
hold on;

count = 0;
clss = class(1);
for i=1:length(cstr_matlab)
    if(class(i) ~= clss)
        icls = i;
        break;
    end
    count = count + 1;
end

if(count ~= length(cstr_matlab))
    if(data_size <= 1000)
        intv = 1;
        icls_in = i - 1;
        icls_en = i + 7;
    else
        intv = 10;
        icls_in = i - 1;
        icls_en = i + 7;
    end
else
    intv = 1;
    icls_in = 1;
    icls_en = 1;
    minarr = 1;
    maxarr = 3;
end


for i = 1:intv:(icls_in-1)
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
    dp = p2 - p1;
    
    scatter(cstr_pca(i,1),cstr_pca(i,2),'.','b','SizeData',0.5*dotSize);
    ah = annotation('arrow','headStyle','cback1',...
        'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
    set(ah,'parent',gca);
    set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);

end

for i = icls_in:1:icls_en
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
    dp = p2 - p1;

    scatter(cstr_pca(i,1),cstr_pca(i,2),'.','g','SizeData',dotSize);
    ah = annotation('arrow','headStyle','cback1',...
        'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
    set(ah,'parent',gca);
    set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength*dp(2)]);
        
end

for i = (icls_en+1):intv:length(cstr_matlab)
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    if(i+1 <= length(cstr_matlab))
        p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
        d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
        dp = p2 - p1;
    end
    
    scatter(cstr_pca(i,1),cstr_pca(i,2),'.','r','SizeData',0.5*dotSize);
    ah = annotation('arrow','headStyle','cback1',...
        'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
    set(ah,'parent',gca);
    set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);

end

% message = sprintf('Do you want to save the plot?');
% button = questdlg(message, 'Save?', 'Yes', 'No', 'Yes');
% drawnow;	% Refresh screen to get rid of dialog box remnants.
% if strcmpi(button, 'No')
%    return;
% end
% 
% saveas(fig, 'plot.png');
% message = msgbox({'Done!' ' '}, 'Success');

%----------------------------------------------------------%
clear all:
clc;
%----------------------------------------------------------%
%Plota todos os dados produzidos pelo simulador
load cstr38.txt;

cstr_matlab = cstr38;
class = cstr_matlab(:,size(cstr_matlab,2));
cstr_matlab = cstr_matlab(:,1:(size(cstr_matlab,2)-1));

[data_size,~] = size(cstr_matlab);
lineLength = 0.4;
lineLength2 = 0.2;
headWidth = 4;
headLength = 4;
dotSize = 300;

% X = cstr_matlab;
% size(X);
% meanX = mean(X,1);
% X = bsxfun(@minus,X,meanX);
% [V,D] = eig(cov(X));
% size(V)
% cstr_pca = cstr_matlab*(V');

[~, cstr_pca] = pca(cstr_matlab);
fig = figure('Position',[250 100 800 600]);
title('cstr38','FontSize',12);
hold on;

count = 0;
clss = class(1);
for i=1:length(cstr_matlab)
    if(class(i) ~= clss)
        icls = i;
        break;
    end
    count = count + 1;
end

if(count ~= length(cstr_matlab))
    if(data_size <= 1000)
        intv = 1;
        icls_in = i - 1;
        icls_en = i + 7;
        minarr = 0.001;
        maxarr = 10;
    else
        intv = 10;
        icls_in = i - 1;
        icls_en = i + 7;
        minarr = 1;
        maxarr = 1.5;
    end
else
    intv = 1;
    icls_in = 1;
    icls_en = 1;
    minarr = 1;
    maxarr = 3;
end

for i = 1:intv:(icls_in-1)
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
    dp = p2 - p1;
    
    scatter(cstr_pca(i,1),cstr_pca(i,2),'.','b','SizeData',0.5*dotSize);
    ah = annotation('arrow','headStyle','cback1',...
        'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
    set(ah,'parent',gca);
    set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);

end

for i = icls_in:1:icls_en
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
    dp = p2 - p1;
    
    scatter(cstr_pca(i,1),cstr_pca(i,2),'.','g','SizeData',dotSize);
    ah = annotation('arrow','headStyle','cback1',...
        'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
    set(ah,'parent',gca);
    set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength*dp(2)]);

end

for i = (icls_en+1):intv:length(cstr_matlab)
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    if(i+1 <= length(cstr_matlab))
        p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
        d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
        dp = p2 - p1;
    end
    
    scatter(cstr_pca(i,1),cstr_pca(i,2),'.','r','SizeData',0.5*dotSize);
    ah = annotation('arrow','headStyle','cback1',...
        'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
    set(ah,'parent',gca);
    set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);

end

% message = sprintf('Do you want to save the plot?');
% button = questdlg(message, 'Save?', 'Yes', 'No', 'Yes');
% drawnow;	% Refresh screen to get rid of dialog box remnants.
% if strcmpi(button, 'No')
%    return;
% end
% 
% saveas(fig, 'plot.png');
% message = msgbox({'Done!' ' '}, 'Success');