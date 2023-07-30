clc;

load cstr18.txt;

cstr18 = cstr18(randperm(length(cstr18)),:);
class18 = cstr18(:,19);
cstr18 = cstr18(:,1:18);

nn18 = fitcknn(cstr18, class18, 'NumNeighbors', 1);
cvnn18 = crossval(nn18, 'kfold', 10);
kloss18 = kfoldLoss(cvnn18);

pdclass18 = predict(nn18, cstr18);
mse18 = immse(class18, pdclass18);

%-----------------------------------------------%
if 0
load cstr38.txt;

cstr38 = cstr38(randperm(length(cstr38)),:);
class38 = cstr38(:,39);
cstr38 = cstr38(:,1:38);

nn38 = fitcknn(cstr38, class38, 'NumNeighbors', 1);
cvnn38 = crossval(nn38, 'kfold', 10);
kloss38 = kfoldLoss(cvnn38);

pdclass38 = predict(nn38, cstr38);
mse38 = immse(class38, pdclass38);

%pdclass = predict(nn18, cstr18);
%pdclass = cellstr(num2str(pdclass));
%trueclass = cellstr(num2str(class));
%cp = classperf(trueclass, pdclass);
end