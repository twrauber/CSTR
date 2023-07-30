clc;

load cstr18.txt;

cstr18 = cstr18(randperm(length(cstr18)),:);
inputs18 = cstr18(:,1:18)';
targets18 = cstr18(:,19)';

hiddenLayerSize = [5 5];
net18 = patternnet(hiddenLayerSize);

net18.divideParam.trainRatio = 70/100;
net18.divideParam.valRatio = 15/100;
net18.divideParam.testRatio = 15/100;
net18.performFcn = 'mse';

[net18,~] = train(net18,inputs18,targets18);

outputs18 = net18(inputs18);
errors18 = gsubtract(targets18,outputs18);
performance18 = perform(net18,targets18,outputs18);

pdclass18 = net18(inputs18);
mse18 = immse(targets18, pdclass18);

%----------------------------------------------%

load cstr38.txt;

cstr38 = cstr38(randperm(length(cstr38)),:);
inputs38 = cstr38(:,1:38)';
targets38 = cstr38(:,39)';

hiddenLayerSize = [5 5];
net38 = patternnet(hiddenLayerSize);

net38.divideParam.trainRatio = 70/100;
net38.divideParam.valRatio = 15/100;
net38.divideParam.testRatio = 15/100;
net38.performFcn = 'mse';

[net38,~] = train(net38,inputs38,targets38);

outputs38 = net38(inputs38);
errors38 = gsubtract(targets38,outputs38);
performance38 = perform(net38,targets38,outputs38);

pdclass38 = net38(inputs38);
mse38 = immse(targets38, pdclass38);

% Plots
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
%figure, ploterrhist(errors)