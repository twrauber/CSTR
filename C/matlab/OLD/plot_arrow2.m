load cstr_matlab.txt;

class = cstr_matlab(:,29);
cstr_matlab = cstr_matlab(:,1:28);

lineLength = 0.3;
headWidth = 8;
headLength = 8;
dotSize = 500;

% X = cstr_matlab;
% size(X);
% meanX = mean(X,1);
% X = bsxfun(@minus,X,meanX);
% [V,D] = eig(cov(X));
% size(V)
% cstr_pca = cstr_matlab*(V');

[~, cstr_pca] = pca(cstr_matlab);
fig = figure('Position',[250 100 800 600]);
title('Arrow plot','FontSize',12);
hold on;

clss = class(1);
for i = 1:length(cstr_pca)
    if(class(i) == clss)
        cl = 'b';
    else
        cl = 'r';
    end
    scatter(cstr_pca(i,1),cstr_pca(i,2),'.',cl,'SizeData',dotSize);
end

 for i = 1:length(cstr_pca)
 
     p1 = [cstr_pca(i,1) cstr_pca(i,2)];
     if(i+1 <= length(cstr_pca))
         p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
         dp = p2 - p1;
         %dp = (dp./norm(dp))./2;
     end
     
     if(i==1)
         clr = [0 0 1]; %Initial point (blue)
     elseif(i==length(cstr_pca))
         clr = [1 0 0]; %Final point (red)
     else
         clr = [0 0 0];
     end
     ah = annotation('arrow','headStyle','cback1',...
             'HeadLength',headLength,'HeadWidth',headWidth,'color',clr);
     set(ah,'parent',gca);
     set(ah,'position',[p1(1) p1(2) lineLength*dp(1) lineLength*dp(2)]);
 
 end

message = sprintf('Do you want to save the plot?');
button = questdlg(message, 'Save?', 'Yes', 'No', 'Yes');
drawnow;	% Refresh screen to get rid of dialog box remnants.
if strcmpi(button, 'No')
   return;
end

saveas(fig, 'plot.png');
message = msgbox({'Done!' ' '}, 'Success');