1;
clear all;
allPlots = findall(0, 'Type', 'figure');
delete(allPlots);

is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave or Matlab
if( is_octave )
	% Do Octave stuff
else
	% Do Matlab stuff
end



root = './';
root = '/tmp/';
root = '/home/thomas/Dropbox/papers/2017_simulator/';
figdir = [root 'figs/' ];
%figdir = [root '' ];


featname38 = {'1 h_{1}'; '2 h_{2}'; '3 h_{3}'; '4 h_{4}'; '5 h_{5}'; '6 h_{6}'; ...
	'7 Q_{1}'; '8 Q_{2}'; '9 Q_{4}'; '10 Q_{3}'; '11 T_{2}'; ...
	'12 h_{7}'; '13 h_{8}'; '14 h_{9}'; '15 h_{10}'; '16 h_{11}'; '17 h_{12}'; '18 h_{13}'; ...
	'19 Q_{5}'; '20 Q_{8}'; '21 Q_{7}'; '22 Q_{6}'; ...
	'23 T_{3}'; '24 T_{4}'; '25 r_{B}'; '26 r_{C}'; ...
	'27 T_{1}'; '28 c_{A0}';'29 c_{A}';'30 c_{B}';'31 c_{C}'; ...
	'32 m_{1}'; '33 u_{2}'; '34 m_{2}'; ...
	'35 z_{1}';'36 z_{2}';'37 z_{3}';'38 z_{4}'};

% Measurable variables + four derived constraints
featname18 = {'$$1\ c_{A0}$$';'$$2\ Q_{1}$$'; '$$3\ T_{1}$$'; '$$4\ L$$'; '$$5\ c_{A}$$';...
		'$$6\ c_{B}$$'; '$$7\ T_{2}$$';...
		'$$8\ Q_{5}$$'; '$$9\ Q_{4}$$'; '$$10\ T_{3}$$';'$$11\ h_{7}$$'; '$$12\ m_{1}$$'; ...
		'$$13\ u_{2}$$'; '$$14\ m_{2}$$'; '$$15\ z_{1}$$'; '$$16\ z_{2}$$'; ...
		'$$17\ z_{3}$$'; '$$18\ z_{4}$$'};


data = 'cstr18.txt';
%data = 'cstr38.txt';


XY = load(data);
numfeat = size(XY,2)-1; % Number of features
X = XY(:,1:numfeat);
n = size(X,1); % Number of samples
%clss = XY(:,numfeat+1);


% Open data file again, get class label from last column
f = fopen(data,'r');
clss = cell(n,1);
k = 0;
while ~feof(f)
	l = fgetl(f);	% don't call it 'line', since this overwrites the function 'line'
	expression = '[_]+'; % find '_' in string
	startIndex = regexp(l,expression);
	if isempty(startIndex) % normal class
		classlabel = 'normal';
	else
		classnamestart = startIndex(1)-1;
		classlabel = l(classnamestart:end-1);
	end
	k = k+1;
	clss(k) = cellstr(classlabel);
end
classes = unique(clss);
numclass = size(classes,1);
%clss
fclose(f);

X_orig = X; % backup original data matrix



idx = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';	% Plot no signal
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals

fault_test = 0;
paper_faults_2_5 = 0;
paper_faults_3_5 = 1;
fault_4 = 0;
fault_8 = 0;
fault_2_3 = 0;


if fault_test
%%%%%
%%%%%	faults/test.txt
%%%%%
%         1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx =    [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
%idx =    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
%idx =    [0 0 0 0 1 0 0 1 0 0 0 0 1 1 0 0 1 0]';

fstart1=90.0; fstart2=0; posdx=0.4; posdy=-0.4; dytick=0.6; fname1='$$\mathrm{Fault}\ Test$$';

signal_xaxis_faultlabel_dy = 0.4;
signal_yaxis_label_dx = -2.0;
%signal_xaxis_tick_dx = -0.0;
signal_xaxis_tick_dy = -0.4;
%signal_yaxis_tick_dx = 0.0;
%signal_yaxis_tick_dy = -0.0;

scatdxlabel=-0.8;
scatdylabel=-0.5;
scat_xaxis_tick_dx = -0.0;
scat_xaxis_tick_dy = -0.1;
scat_yaxis_tick_dx = -0.1;
scat_yaxis_tick_dy = -0.0;
t0dx=0.4; t0dy=0.3; tmaxdx=-0.7; tmaxdy=0.1; % Position of t = 0 and t = t_max


athresh = 0.4; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.4;
end

if paper_faults_3_5
%%%%%
%%%%%	faults/paper_faults_3_5.txt
%%%%%
%         1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx =    [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
%idx =    [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
idx =    [0 0 0 1 1 1 1 1 0 0 0 1 1 1 1 1 1 0]';

fstart1=20.0; fstart2=40; shutdownstart = 63.68;
fname1='$$\mathrm{Fault}\ 3$$'; fname2='$$\mathrm{Fault}\ 5$$';
signal_xaxis_faultlabel_dy = 0.4;
signal_yaxis_label_dx = -2.0;
%signal_xaxis_tick_dx = -0.0;
signal_xaxis_tick_dy = -0.4;
%signal_yaxis_tick_dx = 0.0;
%signal_yaxis_tick_dy = -0.0;

scatdxlabel=-0.8;
scatdylabel=-0.5;
scat_xaxis_tick_dx = -0.0;
scat_xaxis_tick_dy = -0.1;
scat_yaxis_tick_dx = -0.1;
scat_yaxis_tick_dy = -0.0;
t0dx=0.4; t0dy=0.3; tmaxdx=-0.4; tmaxdy=0.5; % Position of t = 0 and t = t_max

athresh = 0.45; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.3;
end

if paper_faults_2_5
%%%%%
%%%%%	faults/paper_faults_2_5
%%%%%   2 - Loss of pump pressure --- 5 - Jacket leak to tank
%%%%%
%      1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
%idx = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';	% Selective plot
idx = [0 0 0 0 1 1 0 1 1 0 0 1 1 1 0 0 0 0]';	% Selective plot  5 6 8 9 12 13 14
fstart1=20.0; fstart2=60.0; posdx=1.6; posdy=-0.4; dytick=0.6;
fname1='$$\mathrm{Fault}\ 2$$'; fname2='$$\mathrm{Fault}\ 5$$';

scatdxlabel=0.0; scatdylabel=-0.05;
scatdxtick=-0.3; scatdytick=-0.05;

athresh = 0.3; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.18;
t0dx=1.0; t0dy=0.0; tmaxdx=0.0; tmaxdy=-0.05;
end

if fault_4
%%%%%
%%%%%	faults/fault_4.txt
%%%%%
%      1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
idx = [0 0 0 0 0 0 0 1 0 0 0 0 1 1 1 1 1 1]';	% Selective plot
fstart1=40.0; fstart2=0; posdx=0.4; posdy=-0.4; dytick=0.6; fname1='$$\mathrm{Fault}\ 4$$';

scatdxlabel=0.0; scatdylabel=-0.05;
scatdxtick=-0.3; scatdytick=-0.05;

athresh = 0.4; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.2;
t0dx=0.0; t0dy=0.0; tmaxdx=0.0; tmaxdy=0.0;
end

if fault_8
%%%%%
%%%%%	faults/fault_8.txt
%%%%%
%      1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
idx = [0 0 0 0 1 0 1 1 0 1 0 0 1 1 0 1 0 0]';	% Selective plot
fstart1=40.0; fstart2=0; posdx=0.4; posdy=-0.4; dytick=0.6; fname1='$$\mathrm{Fault}\ 8$$';

scatdxlabel=0.0; scatdylabel=-0.05;
scatdxtick=-0.3; scatdytick=-0.05;

athresh = 0.4; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.2;
t0dx=0.0; t0dy=0.0; tmaxdx=0.0; tmaxdy=0.0;
end

if fault_2_3
%%%%%
%%%%%	faults/fault_2_3.txt
%%%%%
%      1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
idx = [0 0 0 1 1 0 0 1 1 0 0 1 1 1 1 1 1 1]';	% Selective plot
fstart1=20.0; fstart2=60.0; posdx=0.8; posdy=-0.6; dytick=0.9;
fname1='$$\mathrm{Fault}\ 2$$'; fname2='$$\mathrm{Fault}\ 3$$';

scatdxlabel=0.0; scatdylabel=-0.05;
scatdxtick=-0.3; scatdytick=-0.05;

athresh = 0.4; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.2;
t0dx=0.0; t0dy=0.0; tmaxdx=0.0; tmaxdy=0.0;
end


Xplot=X;
Xplot(:,1)=Xplot(:,1)/20;
Xplot(:,2)=Xplot(:,2)/0.25;
Xplot(:,3)=Xplot(:,3)/30;
Xplot(:,4)=Xplot(:,4)/2;
Xplot(:,5)=Xplot(:,5)/2.8;
Xplot(:,6)=Xplot(:,6)/17.1;
Xplot(:,7)=Xplot(:,7)/80;
Xplot(:,8)=Xplot(:,8)/0.9;
Xplot(:,9)=Xplot(:,9)/0.25;
Xplot(:,10)=Xplot(:,10)/20;
Xplot(:,11)=Xplot(:,11)/10;
Xplot(:,12)=Xplot(:,12)/0.1;
Xplot(:,13)=Xplot(:,13)/0.6;
Xplot(:,14)=Xplot(:,14)/0.9;
Xplot(:,15)=Xplot(:,15)+1;
Xplot(:,16)=(Xplot(:,16)+0.15)+1;
Xplot(:,17)=Xplot(:,17)+1;
Xplot(:,18)=Xplot(:,18)+1;

idx = logical(idx); % Create mask
Xplot = Xplot(:,idx);
numfeat = size(Xplot,2);
% Distribute along y axis
for i=1:numfeat
	Xplot(:,i) = Xplot(:,i) + i - 1;
end

featname = featname18(idx);

%h = gcf; % Current figure handle
h = figure;

% http://www.mathworks.com/help/matlab/learn_matlab/understanding-handle-graphics-objects.html

if( is_octave )
	linewidth = 1.0;
else
	linewidth = 0.3;
end



%%%
%%% Order of commands is important
%%%
plot(Xplot,'LineWidth',linewidth);


%title('Measured variables and constraints');
miny = -1.0; maxy = numfeat+1;
axis([0 n miny maxy]);

hax = gca; % Current axis object


fontsize = 8;
%set(hax, 'XTickMode', 'manual'); set(hax, 'YTickMode', 'manual'); set(hax, 'ZTickMode', 'manual');

xlim = get(hax,'Xlim'); % axis limits
ylim = get(hax,'Ylim');

% Place the y text labels
set(hax,'yticklabel',[]); % clear y axis labels
xtickpos = repmat(xlim(1),1,numfeat)+signal_yaxis_label_dx; % constant x position of label
ytickpos = (1:numfeat);
t = text(xtickpos, ytickpos, featname, 'Interpreter','latex','FontSize',fontsize);
set(t, 'HorizontalAlignment','right','VerticalAlignment','middle')

for i=1:numfeat % horizontal reference lines
	line([0 n],[i i],'LineStyle',':','LineWidth',0.4,'Color',[0 0 0]);
end

% Put units '[min]'
xlabelpos = (xlim(1)+xlim(2))/2;
xlabelpos = xlim(2)+0.4;
txlabel = text(xlabelpos,miny,'$$[\mathrm{min}]$$','Interpreter','latex','FontSize',9);
set(txlabel, 'HorizontalAlignment','left','VerticalAlignment','top','Rotation',90);

xtick = get(hax,'XTick');
numxticks = size(xtick,2);
set(hax,'xticklabel',[]); % clear x axis labels
for i=1:numxticks
	txtick = text( xtick(i), miny+signal_xaxis_tick_dy,...
			['$$' num2str(xtick(i)) '$$'],'Interpreter','latex','FontSize',fontsize);
	set(txtick, 'HorizontalAlignment','center','VerticalAlignment','middle')
end

% Vertical line(s) marking fault start
% https://www.gnu.org/software/octave/doc/interpreter/Line-Properties.html
% https://www.gnu.org/software/octave/doc/interpreter/Line-Styles.html  -- dashed : dotted -. dash-dot 
if fstart1 ~= 0
	text(fstart1,miny+signal_xaxis_faultlabel_dy,fname1,'Interpreter','latex','FontSize',fontsize);
	line([fstart1 fstart1],[miny maxy],'Marker','>','MarkerSize',5,'MarkerFaceColor',[1 0 0],...
		'LineStyle','-','LineWidth',0.2,'Color',[0.5 0.5 0.5]);
end
if fstart2 ~= 0
	text(fstart2,miny+signal_xaxis_faultlabel_dy,fname2, 'Interpreter','latex','FontSize',fontsize);
	line([fstart2 fstart2],[miny maxy],'Marker','>','MarkerSize',5,'MarkerFaceColor',[1 0 0],...
		'LineStyle','-','LineWidth',0.2,'Color',[0.5 0.5 0.5]);
end
if shutdownstart ~= 0
	text(shutdownstart,miny+signal_xaxis_faultlabel_dy,'Shutdown',...
		'Interpreter','latex','FontSize',fontsize);
	line([shutdownstart shutdownstart],[miny maxy],'Marker','>','MarkerSize',5,...
		'MarkerFaceColor',[1 0 0],'LineStyle','-','LineWidth',0.2,'Color',[0.5 0.5 0.5]);
end

% Dump colored encapsulated PostScript
figwidthcm = 8.89;	% 3.5 inch = 252.0pt In LaTeX visualize with: \typeout{####### The column width is \the\columnwidth}
figheightcm = 6.0;
%figheightcm = figwidthcm;
cm2inch = 2.54;
inch2points = 72.0;
cm2points = inch2points/cm2inch;
if( ~is_octave )
	% Matlab subtracts this value from the plot, so compensate
    paddingMarginPoints = 10; % from Matlab 'print.m'
    paddingMarginPoints = 9;
    cm2points = cm2points + paddingMarginPoints;
end
% In the 'print' driver an explicit use of 'points' is done. So use a priori this units
figwidth = figwidthcm * cm2points;
figheight = figheightcm * cm2points;
set(h,'Resize','off');
set(h,'PaperUnits','points');
set(h,'Position',[0 0 figwidth figheight]);
set(h,'PaperSize',[figwidth figheight]); % Must come after 'PaperUnits' IEEE paper columnwidth = 8.89cm
%ppmbefore = get(h,'PaperPositionMode')
set(h,'PaperPosition',[0 0 figwidth figheight]); % [left bottom width height], left, bottom not used when exporting to EPS
% The previous command set to 'PaperPositionMode' to 'manual' (not in Octave)
%ppmafter = get(h,'PaperPositionMode')
set(h,'PaperPositionMode','auto'); % Must come after 'PaperPosition'
set(h,'Clipping','off');
%p = get(h,'Position')
%ppmafterexplicitset = get(h,'PaperPositionMode')

if 0
fprintf('Resize=%s\n', get(h,'Resize') );
fprintf('PaperUnits=%s\n', get(h,'PaperUnits') );
fprintf('Position=%.0f %.0f %.0f %.0f\n', get(h,'Position') );
fprintf('PaperSize=%.0f %.0f\n', get(h,'PaperSize') );
fprintf('PaperPosition=%.0f %.0f %.0f %.0f\n', get(h,'PaperPosition') );
fprintf('PaperPositionMode=%s\n', get(h,'PaperPositionMode') );
fprintf('Clipping=%s\n', get(h,'Clipping') );
fprintf('AXES: Position=%.0f %.0f %.0f %.0f\n', get(hax,'Position') );
end

print([figdir 'faultsignals1'], '-depsc2');%,'-loose');
set(h,'Resize','on');

if 0
fprintf('PaperPosition after print=%.0f %.0f %.0f %.0f\n', get(h,'PaperPosition') );
fprintf('AXES: Position after print=%.0f %.0f %.0f %.0f\n', get(hax,'Position') );
end

%return
%shg; % Show graph window
%fprintf('<Enter> to close ...\n'); pause;
%gcf
%close(h);% kills current figure --- do not do it, otherwise EPS result not good

%return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Quiver Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FIGWIDTHCM = 8.89;
FIGHEIGHTCM = 4.4;
aspectfig = FIGWIDTHCM/FIGHEIGHTCM;
h = figure;

%X = X(:,1:2);numfeat = size(X,2);

% Filter out samples that belong to the normal class
idxConditionNormal = cellfun(@isequal, clss, repmat({'normal'},n,1));
idxConditionNormal = logical(idxConditionNormal);
XConditionNormal = X(idxConditionNormal,:);
nnormal = size(XConditionNormal,1); % Number of normal samples

minx = min(X);		% Minima each feature (columns of X)
maxx = max(X);		% Maxima of each feature (columns of X)
meanX = mean(X,1);	% Mean of each feature (columns of X)
stdX = std(X,1);	% Standard deviation of each feature (columns of X)

if 1
% Scale features between [-1,1]
X = 2*bsxfun(@rdivide,bsxfun(@minus,X,minx),maxx-minx)-1;
end

if 0
% Scale features zero mean, unit variance: equivalent to X = zscore(X);
X = bsxfun(@rdivide,bsxfun(@minus,X,meanX),stdX);
end

XConditionNormal = X(idxConditionNormal,:); % Have to filter again


if 1
%if( is_octave || ~exist('pca') )
	meanX = mean(X,1);
	XC = bsxfun(@minus,X,meanX);
	%[V,~] = eig(cov(XC)); pc_octave = XC*fliplr(V);
	[~,~,V] = svd(XC);
	score_octave = XC*V;
	score = score_octave;
% http://matlabdatamining.blogspot.com.br/2010/02/principal-components-analysis.html
% Note three important things about the above:
% 1. The order of the principal components from princomp is opposite of that from eig(cov(B)).
%    princomp orders the principal components so that the first one appears in column 1,
%    whereas eig(cov(B)) stores it in the last column.
%
% 2. Some of the coefficients from each method have the opposite sign.
%    This is fine: There is no "natural" orientation for principal components,
%    so you can expect different software to produce different mixes of signs.
%
else
	[~, score] = pca(X);
	%diff = score-score_octave
	%input('Diff: Enter to continue...'); return;
end


if 0	% Use only the normal patterns, with unit variance and mean zero to obtain PCA vectors
meanXConditionNormal = mean(XConditionNormal,1);
stdXConditionNormal = std(XConditionNormal,1);
XConditionNormal = bsxfun(@rdivide,bsxfun(@minus,XConditionNormal,meanXConditionNormal),stdXConditionNormal);
[~,~,V] = svd(XConditionNormal);
XC = bsxfun(@minus,X,meanXConditionNormal);
score = XC*V;
end


y1 = score(:,1); miny1 = min(y1); maxy1 = max(y1);
y2 = score(:,2); miny2 = min(y2); maxy2 = max(y2);
if numfeat == 3
	y3 = score(:,3); miny3 = min(y3); maxy3 = max(y3);
else
	y3 = zeros(size(y1,1),1);
end
%gscatter(y1,y2,clss); % Matlab only


% Distance vector between two successive points
dy1 = zeros(n-1,1);
dy2 = zeros(n-1,1);
dy3 = zeros(n-1,1);
dynorm = zeros(n-1,1); % Euclidean norm (=distance between two consecutive points)
dyangle = zeros(n-1,1); % angle of distance vector [-pi,pi] (only 2-D case)
for i=1:n-1
	dy1(i) = y1(i+1)-y1(i);
	dy2(i) = y2(i+1)-y2(i);
	dy3(i) = y3(i+1)-y3(i);
	dynorm(i) = sqrt(dy1(i)*dy1(i)+dy2(i)*dy2(i)+dy3(i)*dy3(i));
	dyangle(i) = atan2(dy2(i),dy1(i));
end


%%% SCATTER PLOT
colors = ['r', 'g', 'b', 'y', 'm', 'c'];
numcol = size(colors,2);
%colors = cmap;
% Marker style: http://www.mathworks.com/help/matlab/ref/linespec.html
% + o * . x s d ^ v > < p h
dotstyle = '.';
markersize = 5;
for i=1:numclass
	idx = [];
	for j=1:n
		idx = [idx isequal(clss(j),classes(i))];
	end
	idx = logical(idx);
	y1i = y1(idx,:); y2i = y2(idx,:);
	colidx = mod(i,numcol);
	%scatter(y1i,y2i,dotsize,colors(colidx),dotstyle ); %,'filled'); 
end
hold off;




%%% ARROWS
cmap = colormap; numcol = size(cmap,1);
linewidth = 0.4;

% Create arrow as specified in pstricks, pst_ug.pdf, p.40 (length,width,inset)
% Specify directly
length = 0.8;	% x-axis
width = 0.4;	% y-axis
inset = 0.2;	% x-axis

%length = 2
%width  = 0.5
%inset = 0.25
%aspectfig


length = length * arrowscale;
width = width * arrowscale / aspectfig;
w2 = width/2.0;
inset = inset * arrowscale;
%fprintf('dim=%5.2f num=%5.2f arrowlength=%5.2f arrowinset=%5.2f\nwidth=%5.2f length=%5.2f inset=%5.2f\n',...
%	dim,num,arrowlength,arrowinset,width,length,inset);

% calculate the polygon of the arrow tip, given current angle to horizontal, arrow coordinates, width, length, inset
px = zeros(1,5); py = zeros(1,5); % Polygon
vx = zeros(1,4); vy = zeros(1,4); % Offset vectors to create polygon

vx(1) = +length; vy(1) = +w2;
vx(2) =  -inset; vy(2) = -w2;
vx(3) =  +inset; vy(3) = -w2;
vx(4) = -length; vy(4) = +w2;
for i=1:4
	px(i+1) = px(i) + vx(i);
	py(i+1) = py(i) + vy(i);
end
mx = mean(px);
my = mean(py);
px = px - mx;
py = py - my;


dx = maxy1 - miny1;
dy = maxy2 - miny2;
perc = 0.1;
xmin = miny1-perc*dx; xmax = maxy1+perc*dx;
ymin = miny2-perc*dy; ymax = maxy2+perc*dy;
dx = xmax - xmin; % must come after the limits have been defined
dy = ymax - ymin;
axis([xmin xmax ymin ymax]);
aspectaxis = abs(dx/dy);
%fprintf('minx=%5.2f maxx=%5.2f miny=%5.2f maxy=%5.2f xmin=%5.2f xmax=%5.2f ymin=%5.2f ymax=%5.2f dx=%5.2f dy=%5.2f aspectaxis=%5.2f\n',...
%	miny1,maxy1,miny2,maxy2,xmin,xmax,ymin,ymax,dx,dy,aspectaxis);

if 0	% DEBUG
%p1 = patch(0,0,'magenta');

%----------------------------------------------------
ax1 = px/aspectfig;
ay1 = py;
angrotate = 0.0;
sintheta = sin(angrotate); costheta = cos(angrotate);
rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
pr =  rotmat * [ax1;ay1];
ax1 = pr(1,:);
ay1 = pr(2,:);
ax1 = ax1 * dx * arrowscale / aspectfig;
ay1 = ay1 * dy * arrowscale;
p1 = patch(ax1-0.2,ay1-0.2,'black','LineWidth',0.1);
%----------------------------------------------------

%----------------------------------------------------
ax1 = px/aspectfig;
ay1 = py;
angrotate = 3*pi/8;
sintheta = sin(angrotate); costheta = cos(angrotate);
rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
pr =  rotmat * [ax1;ay1];
ax1 = pr(1,:);
ay1 = pr(2,:);
ax1 = ax1 * dx * arrowscale / aspectfig;
ay1 = ay1 * dy * arrowscale;
p1 = patch(ax1,ay1,'red','LineWidth',0.1);
%----------------------------------------------------

%----------------------------------------------------
ax1 = px / aspectfig;
ay1 = py;
angrotate = 4*pi/8;
sintheta = sin(angrotate); costheta = cos(angrotate);
rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
pr =  rotmat * [ax1;ay1];
ax1 = pr(1,:);
ay1 = pr(2,:);
ax1 = ax1 * dx * arrowscale / aspectfig;
ay1 = ay1 * dy * arrowscale;
p1 = patch(ax1+0.2,ay1+0.2,'green','LineWidth',0.2);
%----------------------------------------------------

%----------------------------------------------------
ax1 = px / aspectfig;
ay1 = py;
angrotate = -7*pi/8;
sintheta = sin(angrotate); costheta = cos(angrotate);
rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
pr =  rotmat * [ax1;ay1];
ax1 = pr(1,:);
ay1 = pr(2,:);
ax1 = ax1 * dx * arrowscale / aspectfig;
ay1 = ay1 * dy * arrowscale;
p1 = patch(ax1-0.2,ay1+0.2,'blue','LineWidth',0.3);
%----------------------------------------------------
else


%axis equal;
%axis square;
%axis normal;

idxConditionNormal = logical(idxConditionNormal);
XConditionNormal = X(idxConditionNormal,:);
meanConditionNormal = mean(score(idxConditionNormal,1:2)); % Mean of normal class in score space

%(((((((((((((((((((((((((((( T2 statistic test ))))))))))))))))))))))))))))
if 1
vlim = 0.95;
CI = 0.99;
ind = 1:numfeat;
ii = 1:nnormal;
loopTsh = 0.01;   % Percentual minimo de contribuicao da malha para a falha
ewmaT2Q = 0.99;   % Filtro ewma para a estatistica t2/Q
%ewmaUni = 0.99;   % Filtro ewma para a estatistica univariada
%janaUni = 05;     % Janela de amostras para analise univariada em torno do 
                  % ponto de falha

ts      = 1.0; % sampling interval
Tts     = [0 1:(n-1)]*ts;
Tc1     = [(max(Tts)+1):(max(Tts)+n)]*ts;
[rr,cc] = size(X);


pcaanalysis = PCAAnalysis(XConditionNormal,vlim,CI,ind,ii,false);
%pcaanalysis = PCAAnalysis(XConditionNormal,vlim,CI,ind,ii,true);
% Test all samples against the T2 threshold obtained from only the normal samples
faultanalysis = PCAFaultTest(pcaanalysis,X,ts,loopTsh,ewmaT2Q);

t2fidx=zeros(1,n); % Those samples that violate the T2 threshold
for i=1:n
	violatesT2 = faultanalysis.t2(i) > pcaanalysis.t2lim;
	t2fidx(i) = violatesT2;
end


Z = zscore(XConditionNormal);
[n,a] = size(Z); alfa = CI;
%[V,D] = eig(cov(Z));
LAMBDAINV = diag(1./(eig(cov(Z))));
t2lim = (a*(n-1)*(n+1)/(n*(n-a)))*finv(alfa,a,n-a);
%fprintf('n=%d a=%d alfa=%f\n', n, a, alfa );
for i=1:n
    t2 = Z(i,:)*LAMBDAINV*Z(i,:)';
    violatesT2 = t2 > t2lim;
    t2fidx(i) = violatesT2;
    %fprintf('i=%d T2=%f violates=%d\n',i,t2,violatesT2);
end

% Now all values...




%singularValues = svd(Z);
%res = norm( singularValues.*singularValues/(n-1) - eigenvalues) % should be zero



% Generate parametric curve from the T2 = T2_alpha condition

V = pcaanalysis.PC;		% Eigenvector matrix
LAMBDA = pcaanalysis.ss;	% Diagnonal matrix of ordered eigenvalues
a = pcaanalysis.a;		% Number of principal components
T2lim = pcaanalysis.t2lim; 	% Cutting value of hypothesis test

%xmean_a = xmean(1:a);
P = V(:,1:a);
LAMBDA_a = LAMBDA(1:a,1:a);
lambda1 = LAMBDA_a(1,1);
lambda2 = LAMBDA_a(2,2);

% T2 = [y1 y2] * diag(1/lambda1, 1/lambda2) * [y1 y2]' describes an ellipse
% Parametric representation of ellipse (a cos(t),b sin(t))
% ==> a=sqrt(lambda1 T2), b=sqrt(lambda2 T2)
aa = 1/sqrt(lambda1 * T2lim);
bb = 1/sqrt(lambda2 * T2lim);
fx = @(t)  aa*cos(t);                 
fy = @(t)  bb*sin(t);
t = 0:2*pi/100:2*pi;
%hold on;
%patch(0.1+fx(t), 0.2+fy(t),[0.9 0.9 0.9],'FaceColor','none');
%ezplot (fx,fy);               
%hold off;
%return;
end
%((((((((((((((((((((((((((((((((()))))))))))))))))))))))))))))))))

hold on;
% T2 limit
patch(meanConditionNormal(1)+fx(t), meanConditionNormal(2)+fy(t),...
	[0.8 0.8 0.8],'LineWidth',0.2,'FaceColor',[0.8 0.8 0.8]);

for i=1:n-1
	ax1 = y1(i); ax2 = ax1 + dy1(i);
	ay1 = y2(i); ay2 = ay1 + dy2(i);
	%line([ax1 ax2],[ay1 ay2],'LineStyle','-','linewidth',0.2,'Color',[0 0 0]);
	cidx = 1+mod(i,numcol);
	r = cmap(cidx,1); g = cmap(cidx,2); b = cmap(cidx,3);
	r = 0; g = 0; b = 0;	% Just black
	l = line([ax1 ax2],[ay1 ay2],'LineStyle','-','LineWidth',linewidth,'Color',[r g b]);
	%set(l,'LineWidth',linewidth);	% RUN IN 2013a --- DOES NOT WORK IN 2015a
	% http://stackoverflow.com/questions/28685604/draw-bold-axes-in-matlab-properly
	%pause(0.02);

	% draw an arrow halfway on the distance vector (only 2-D)
	cx = (ax1+ax2)/2.0;
	cy = (ay1+ay2)/2.0;
	%scatter(y1i,y2i,dotsize,colors(colidx),dotstyle ); %,'filled'); 
	%plot (ax1, ay1, '.', 'MarkerSize', 6, 'Color',[r g b]);

	% Paint the pattern with the color of its class
	[~,idx] = ismember(clss(i),classes);
	plot (ax1,ay1,dotstyle,'MarkerSize',markersize,'Color',colors(idx));

	%fprintf('athresh=%e dynorm(%d)=%e\n',athresh,i,dynorm(i));
	if dynorm(i) >= athresh
		%----------------------------------------------------
		auxx = px / aspectfig;
		auxy = py;
		angrotate = atan2(dy2(i)/dy/aspectfig,dy1(i)/dx) - pi;
		sintheta = sin(angrotate); costheta = cos(angrotate);
		rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
		rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
		pr =  rotmat * [auxx;auxy];
		auxx = pr(1,:);
		auxy = pr(2,:);
		auxx = auxx * dx * arrowscale / aspectfig;
		auxy = auxy * dy * arrowscale;
		p1 = patch(auxx+cx,auxy+cy,[r g b],'LineWidth',0.1);
		% http://www.mathworks.com/help/matlab/ref/patch.html (filled polygon)
		%----------------------------------------------------
	end
end

if 0 % Paint the triangles at first and last pattern
[~,idx] = ismember(clss(1),classes); % Class index of first sample
plot (y1(1), y2(1),     'v', 'MarkerSize', 1.0*markersize, 'Color', colors(idx) ); % First: color of first class 
[~,idx] = ismember(clss(end),classes); % Class index of last sample
plot (y1(end), y2(end), '^', 'MarkerSize', 1.0*markersize, 'Color', colors(idx) ); % Last: color of last class
end




txt = text(y1(1)+t0dx, y2(1)+t0dy, '$$t=0$$', 'Interpreter','latex','FontSize',fontsize);
set(txt, 'HorizontalAlignment','center','VerticalAlignment','middle')
txt = text(y1(end)+tmaxdx, y2(end)+tmaxdy, '$$t=t_{\mathrm{max}}$$', 'Interpreter','latex','FontSize',fontsize);
set(txt, 'HorizontalAlignment','center','VerticalAlignment','middle')


xlabelpos = (xmin+xmax)/2;
ylabelpos = ymin+scatdylabel;
txlabel = text(xlabelpos,ylabelpos,'$$\mathrm{PC}_{1}$$','Interpreter','latex','FontSize',fontsize);
set(txlabel, 'HorizontalAlignment','left','VerticalAlignment','middle')

xlabelpos = xmin+scatdxlabel;
ylabelpos = (ymin+ymax)/2;
tylabel = text(xlabelpos,ylabelpos,'$$\mathrm{PC}_{2}$$','Interpreter','latex','FontSize',fontsize);
set(tylabel, 'HorizontalAlignment','right','VerticalAlignment','middle', 'Rotation', 90)

% Place the y text labels -- the value of delta modifies how far the labels 
% are from the axis.

hax = gca;


xtick = get(hax,'XTick');
numxticks = size(xtick,2);
set(hax,'xticklabel',[]); % clear x axis labels
for i=1:numxticks
	txtick = text( xtick(i)+scat_xaxis_tick_dx, ymin+scat_xaxis_tick_dy,...
			['$$' num2str(xtick(i)) '$$'],'Interpreter','latex','FontSize',fontsize);
	set(txtick, 'HorizontalAlignment','center','VerticalAlignment','top')
end

ytick = get(hax,'YTick');
numyticks = size(ytick,2);
set(hax,'yticklabel',[]); % clear y axis labels
for i=1:numyticks
	tytick = text( xmin+scat_yaxis_tick_dx, ytick(i)+scat_yaxis_tick_dy,...
			['$$' num2str(ytick(i)) '$$'],'Interpreter','latex','FontSize',fontsize);
	set(tytick, 'HorizontalAlignment','right','VerticalAlignment','middle')
end

hold off; 



zoom = axes('position',[.4 .6 .25/aspectaxis .25]); % http://www.mathworks.com/help/matlab/ref/axes-properties.html
box on % put box around new pair of axes
set(zoom,'xticklabel',[]); % clear x axis labels
set(zoom,'yticklabel',[]); % clear y axis labels

% T2 limit
patch(meanConditionNormal(1)+fx(t), meanConditionNormal(2)+fy(t),...
	[0.8 0.8 0.8],'LineWidth',0.2,'FaceColor',[0.8 0.8 0.8]);
for i=1:n-1
	hold on; 
	ax1 = y1(i); ax2 = ax1 + dy1(i);
	ay1 = y2(i); ay2 = ay1 + dy2(i);
	%line([ax1 ax2],[ay1 ay2],'LineStyle','-','linewidth',0.2,'Color',[0 0 0]);
	cidx = 1+mod(i,numcol);
	r = cmap(cidx,1); g = cmap(cidx,2); b = cmap(cidx,3);
	r = 0; g = 0; b = 0;	% Just black

	% Paint the pattern with the color of its class
	[~,idx] = ismember(clss(i),classes);	
%	if 1
%	if isequal(char(clss(i)),'normal') t2fidx(i)
	if ~t2fidx(i)
		plot (ax1,ay1,dotstyle,'MarkerSize',markersize,'Color',colors(idx));
		if ~t2fidx(i+1)
			%l = line([ax1 ax2],[ay1 ay2],'LineStyle','-','LineWidth',linewidth,'Color',[r g b]);
		end
	end
	hold off; 
end
axis tight;


end	% DEBUG

% Dump colored encapsulated PostScript
figwidthcm = FIGWIDTHCM;	% 3.5 inch = 252.0pt In LaTeX visualize with: \typeout{####### The column width is \the\columnwidth}
figheightcm = FIGHEIGHTCM;
%figheightcm = figwidthcm;
cm2inch = 2.54;
inch2points = 72.0;
cm2points = inch2points/cm2inch;
if( ~is_octave )
    paddingMarginPoints = 18;
    paddingMarginPoints = 12;
    cm2points = cm2points + paddingMarginPoints;
end
% In the 'print' driver an explicit use of 'points' is done. So use a priori this units
figwidth = figwidthcm * cm2points;
figheight = figheightcm * cm2points;
set(h,'Resize','off');
set(h,'PaperUnits','points');
set(h,'Position',[0 0 figwidth figheight]);
set(h,'PaperSize',[figwidth figheight]);
set(h,'PaperPosition',[0 0 figwidth figheight]);
set(h,'PaperPositionMode','auto');
set(h,'Clipping','off');
print([figdir 'faultsignals1scatter'], '-depsc2');
set(h,'Resize','on');
%fprintf('<Enter> to close ...\n'); pause;
%close(h);
