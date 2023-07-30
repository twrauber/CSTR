%Plot the data after pca using arrows

clear all;
clc;

load cstr_matlab.txt;

[T, D] = size(cstr_matlab);
cstr_norm = zeros(T,D);
maxVal = max(cstr_matlab);
maxVal = max(maxVal);
minVal = min(cstr_matlab);
minVal = min(minVal);

LineLength = 0.08;

for i=1:T
    for j=1:D
        cstr_norm(i,j) = (cstr_matlab(i,j) - minVal)/(maxVal - minVal);
    end
end

[~, cstr_pca] = pca(cstr_matlab);
vfig = figure;
hold on;

nFrames = length(cstr_pca);
allFrames = cell(nFrames,1);
vidHeight = 344;
vidWidth = 446;
allFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
colorMaps = cell(nFrames,1);
colorMaps(:) = {zeros(256, 3)};
M = struct('cdata', allFrames, 'colormap', colorMaps);
set(gcf, 'renderer', 'zbuffer');

for i=1:length(cstr_pca)
    p1 = [cstr_pca(i,1) cstr_pca(i,2)];
    if(i+1 <= length(cstr_pca))
        p2 = [cstr_pca(i+1,1) cstr_pca(i+1,2)];
    end
    dp = p2 - p1;
    hq = quiver(p1(1),p1(2),dp(1),dp(2),0,'ShowArrowHead','off', 'color', [1 1 1]);
   	
    U = hq.UData;
    V = hq.VData;
    X = hq.XData;
    Y = hq.YData;
    
    for j = 1:length(X)
        for k = 1:length(X)

            ah = annotation('arrow',...
                'headStyle','vback1','HeadLength',5,'HeadWidth',3);
            set(ah,'parent',gca);
            set(ah,'position',[X(j,k) Y(j,k) LineLength*U(j,k) LineLength*V(j,k)]);

        end
    end
    
    thisFrame = getframe(gca);
    M(i) = thisFrame;
end

%movie(M,1,10);
movie2avi(M, 'cstr_plot.avi', 'compression', 'none', 'fps', 10);