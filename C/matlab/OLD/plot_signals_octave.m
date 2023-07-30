
is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave or Matlab
if( is_octave )
else
end


%Plota os dados lidos pelos sensores
load cstr14.txt;

cstr_matlab = cstr14;
class = cstr_matlab(:,15);
cstr_matlab = cstr_matlab(:,1:14);

%cstr_matlab = cstr_matlab(1:10,1:5);

[data_size,~] = size(cstr_matlab);
lineLength = 0.5;
lineLength2 = 0.05;
headWidth = 4;
headLength = 4;
dotSize = 300;


if( is_octave )
    X = cstr_matlab;
    meanX = mean(X,1);
    X = bsxfun(@minus,X,meanX);
    %[V,~] = eig(cov(X)); cstr_pca = X*fliplr(V)
    [~,~,V] = svd(X);
    cstr_pca = X*V;
% http://matlabdatamining.blogspot.com.br/2010/02/principal-components-analysis.html
% Note three important things about the above:
% 1. The order of the principal components from princomp is opposite of that from eig(cov(B)).
%    princomp orders the principal components so that the first one appears in column 1,
%    whereas eig(cov(B)) stores it in the last column.
%
% 2. Some of the coefficients from each method have the opposite sign.
%    This is fine: There is no "natural" orientation for principal components,
%    so you can expect different software to produce different mixes of signs.
else
    [~, cstr_pca] = pca(cstr_matlab);
end
%diffdbg = cstr_pca-cstr_pca1  % Matlab inverts the direction of some eigenvectors. Therefore difference
%input('Diff: Enter to continue...'); return;



fig = figure('Position',[250 100 800 600]);
title('cstr14','FontSize',12);
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
        minarr = 1;
        maxarr = 3;
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
    
    if(d >= minarr && d <= maxarr)
        scatter(cstr_pca(i,1),cstr_pca(i,2),'.','b','SizeData',0.5*dotSize);
        ah = annotation('arrow','headStyle','cback1',...
            'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
        set(ah,'parent',gca);
        set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);
    end
    
end

for i = icls_in:1:icls_en
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
    dp = p2 - p1;
    %if(d >= 1 && d <=5)
        if( is_octave )
        else
        end
        if( is_octave )
            scatter(cstr_pca(i,1),cstr_pca(i,2));
        else
            scatter(cstr_pca(i,1),cstr_pca(i,2),'.','g','SizeData',dotSize);
           ah = annotation('arrow','headStyle','cback1',...
            'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
            set(ah,'parent',gca);
            set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength*dp(2)]);
        end
    %end
end

for i = (icls_en+1):intv:length(cstr_matlab)
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    if(i+1 <= length(cstr_matlab))
        p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
        d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
        dp = p2 - p1;
    end
    
    if(d >= minarr && d <= maxarr)
        scatter(cstr_pca(i,1),cstr_pca(i,2),'.','r','SizeData',0.5*dotSize);
        ah = annotation('arrow','headStyle','cback1',...
            'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
        set(ah,'parent',gca);
        set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);
    end
    
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
load cstr34.txt;

cstr_matlab = cstr34;
class = cstr_matlab(:,35);
cstr_matlab = cstr_matlab(:,1:34);

[data_size,~] = size(cstr_matlab);
lineLength = 0.4;
lineLength2 = 0.05;
headWidth = 4;
headLength = 4;
dotSize = 300;

if( is_octave )
    X = cstr_matlab;
    meanX = mean(X,1);
    X = bsxfun(@minus,X,meanX);
    %[V,~] = eig(cov(X)); cstr_pca = X*fliplr(V)
    [~,~,V] = svd(X);
    cstr_pca = X*V;
else
    [~, cstr_pca] = pca(cstr_matlab);
end

fig = figure('Position',[250 100 800 600]);
title('cstr34','FontSize',12);
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
        minarr = 1;
        maxarr = 3;
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
    
    if(d >= minarr && d <= maxarr)
	if( is_octave )
        	scatter(cstr_pca(i,1),cstr_pca(i,2));
	else
        	scatter(cstr_pca(i,1),cstr_pca(i,2),'.','b','SizeData',0.5*dotSize);
        	ah = annotation('arrow','headStyle','cback1',...
			'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
        	set(ah,'parent',gca);
        	set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);
	end
    end
    
end

for i = icls_in:1:icls_en
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
    dp = p2 - p1;
    %if(d >= 1 && d <=5)
	if( is_octave )
        	scatter(cstr_pca(i,1),cstr_pca(i,2));
	else
        	scatter(cstr_pca(i,1),cstr_pca(i,2),'.','g','SizeData',dotSize);
        	ah = annotation('arrow','headStyle','cback1',...
			'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
        	set(ah,'parent',gca);
        	set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength*dp(2)]);
	end
    %end
end

for i = (icls_en+1):intv:length(cstr_matlab)
    
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    if(i+1 <= length(cstr_matlab))
        p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
        d = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
        dp = p2 - p1;
    end
    
    if(d >= minarr && d <= maxarr)
	if( is_octave )
        	scatter(cstr_pca(i,1),cstr_pca(i,2));
	else
        	scatter(cstr_pca(i,1),cstr_pca(i,2),'.','r','SizeData',0.5*dotSize);
		ah = annotation('arrow','headStyle','cback1',...
			'HeadLength',headLength,'HeadWidth',headWidth,'color',[0 0 0]);
		set(ah,'parent',gca);
		set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength2*dp(2)]);
    	end
    end
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
