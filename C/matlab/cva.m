1;
clear all;

is_octave = (exist('OCTAVE_VERSION','builtin')>1); % Octave or Matlab
if( is_octave )
	% Do Octave stuff
else
	% Do Matlab stuff
end



root = './';
root = '/tmp/';
root = '/home/thomas/Dropbox/papers/2015_simulator/';
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


X_orig = X;

meanX = mean(X,1);
XC = bsxfun(@minus,X,meanX); % Centralized X

%      1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
all = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% All signals
idx = [0 0 0 1 1 0 0 1 1 0 0 1 1 1 1 1 0 1]';	% Selection
idy = all - idx;

% Canonical Variate Analysis in Control and Signal Processing
% Wallace E. Larimore, 1997
% x : zero mean random variable predictor
% y : predicted

idx = logical(idx); % Create mask
idy = logical(idy); % Create mask
x = XC(:,idx);
y = XC(:,idy);

[nx,K] = size(x); 
[ny,L] = size(y); 

% http://www.statlect.com/glossary/cross-covariance_matrix.htm
Cxx = cov(x); % = x'*x / (nx-1);
Cyy = cov(y); % = y'*y / (ny-1)

if nx ~= ny || nx <= 1
	fprintf('Dimension error %d<>%d !\n',nx,ny);
	return;
end
Cxy = x'*y/(nx-1);
% https://en.wikipedia.org/wiki/Eigendecomposition_of_a_matrix

Cxx12 = Cxx^(-1/2);
Cyy12 = Cyy^(-1/2);

if 0	% DEBUG: Show equivalence
[V, LAMBDA] = eig(Cxx);
Cxx12aux = V*diag(1./sqrt(diag(LAMBDA)))*V';
fprintf('Residual, should be zero: %.20e\n',norm(Cxx12-Cxx12aux));
[V, LAMBDA] = eig(Cyy);
Cyy12aux = V*diag(1./sqrt(diag(LAMBDA)))*V';
fprintf('Residual, should be zero: %.20e\n',norm(Cyy12-Cyy12aux));
end

C = Cxx12 * Cxy * Cyy12;

[U,S,V] = svd(C);

J = U'*Cxx12;
L = V'*Cyy12;


c = J*x';
d = L*y';

if 0	% DEBUG: Show equivalence
det(J*Cxx*J')	% Must be unity
det(cov(c))	% Must be the same as before
res = norm(J*Cxx*J' - cov(c') ) % must be numerically zero
end


return;



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

idx = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';	% Plot no signal
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals

paper_faults_2_5 = 0;
fault_4 = 1;
fault_8 = 0;
fault_2_3 = 0;

if paper_faults_2_5
%%%%%
%%%%%	faults/paper_faults_2_5
%%%%%   2 - Loss of pump pressure --- 5 - Jacket leak to tank
%%%%%
%      1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
idx = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]';	% Plot all signals
idx = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';	% Selective plot
idx = [0 0 0 1 1 0 0 0 0 0 0 1 1 1 1 0 0 0]';	% Selective plot
fstart1=20.0; fstart2=50.0; posdx=1.6; posdy=-0.4; dytick=0.6;
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

athresh = 0.4; % Do not draw arrow if distance between consecutive point is below this
arrowscale = 0.2;
t0dx=0.0; t0dy=0.0; tmaxdx=0.0; tmaxdy=0.0;
end



idx = logical(idx); % Create mask
Xplot = Xplot(:,idx);
numfeat = size(Xplot,2);
% Distribute along y axis
for i=1:numfeat
	Xplot(:,i) = Xplot(:,i) + i - 1;
end


featname = featname18(idx);


close(gcf);
h = gcf; % Current figure handle
%h = figure;

% http://www.mathworks.com/help/matlab/learn_matlab/understanding-handle-graphics-objects.html


%%%
%%% Order of commands is important
%%%
plot(Xplot,'LineWidth',0.1);


%title('Measured variables and constraints');
miny = -1.0; maxy = numfeat+1;
axis([0 n miny maxy]);

hax = gca; % Current axis object


fontsize = 8;
%set(hax, 'XTickMode', 'manual'); set(hax, 'YTickMode', 'manual'); set(hax, 'ZTickMode', 'manual');

xlim = get(hax,'Xlim'); % axis limits
ylim = get(hax,'Ylim');

% Place the y text labels -- the value of posdx modifies how far the labels 
% are from the y axis.
set(hax,'yticklabel',[]); % clear y axis labels
xtickpos = repmat(xlim(1),1,numfeat)-posdx; % constant x position of label
ytickpos = (1:numfeat);
t = text(xtickpos, ytickpos, featname, 'Interpreter','latex','FontSize',fontsize);
set(t, 'HorizontalAlignment','right','VerticalAlignment','middle')
%xlabel('[min x 100]');
%xlabel('[min]');
%ylabel('Coefficients');


%legend(featname);
%set(h,'fontname','Arial');


for i=1:numfeat % horizontal reference lines
	line([0 n],[i i],'LineStyle',':','LineWidth',0.5,'Color',[0 0 0]);
end


xlabelpos = (xlim(1)+xlim(2))/2;
xlabelpos = xlim(2)+0.4;
txlabel = text(xlabelpos,miny,'$$[\mathrm{Iter}/100]$$','Interpreter','latex','FontSize',9);
set(txlabel, 'HorizontalAlignment','left','VerticalAlignment','top','Rotation',90);

xtick = get(hax,'XTick');
numxticks = size(xtick,2);
set(hax,'xticklabel',[]); % clear x axis labels
for i=1:numxticks
	txtick = text( xtick(i), miny-dytick,...
			['$$' num2str(xtick(i)) '$$'],'Interpreter','latex','FontSize',fontsize);
	set(txtick, 'HorizontalAlignment','center','VerticalAlignment','middle')
end

% Vertical line(s) marking fault start
% https://www.gnu.org/software/octave/doc/interpreter/Line-Properties.html
% https://www.gnu.org/software/octave/doc/interpreter/Line-Styles.html  -- dashed : dotted -. dash-dot 
if fstart1 ~= 0
	text(fstart1,miny-posdy,fname1,'Interpreter','latex','FontSize',fontsize);
	line([fstart1 fstart1],[miny maxy],'Marker','>','markersize',5,'LineStyle',':',...
			'linewidth',1.0,'Color',[1 0 0]);
end

if fstart2 ~= 0
	text(fstart2,miny-posdy,fname2, 'Interpreter','latex','FontSize',fontsize);
	line([fstart2 fstart2],[miny maxy],'Marker','>','markersize',5,'LineStyle',':',...
			'linewidth',1.0,'Color',[1 0 0]);
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

%fprintf('<Enter> to close ...\n'); pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Quiver Plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = figure;

X_orig = X;


if( is_octave )
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
y1 = score(:,1); miny1 = min(y1); maxy1 = max(y1);
y2 = score(:,2); miny2 = min(y2); maxy2 = max(y2);
y3 = score(:,3); miny3 = min(y3); maxy3 = max(y3);
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
dotsize = 6;
% Marker style: http://www.mathworks.com/help/matlab/ref/linespec.html
% + o * . x s d ^ v > < p h
dotstyle = 'o';
for i=1:numclass
	idx = [];
	for j=1:n
		idx = [idx isequal(clss(j),classes(i))];
	end
	idx = logical(idx);
	y1i = y1(idx,:); y2i = y2(idx,:);
	colidx = mod(i,numcol);
	scatter(y1i,y2i,dotsize,colors(colidx),dotstyle ); %,'filled'); 
end
hold off;




%%% ARROWS
cmap = colormap; numcol = size(cmap,1);
linewidth = 0.4;

% Create arrow as specified in pstricks, pst_ug.pdf, p.40 (length,width,inset)
% Specify directly
length = 0.8;
width = 0.4;
inset = 0.2;


length = length * arrowscale;
width = width * arrowscale; w2 = width/2.0;
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
aspect = abs(dy/dx);
%fprintf('minx=%5.2f maxx=%5.2f miny=%5.2f maxy=%5.2f xmin=%5.2f xmax=%5.2f ymin=%5.2f ymax=%5.2f dx=%5.2f dy=%5.2f aspect=%5.2f\n',...
%	miny1,maxy1,miny2,maxy2,xmin,xmax,ymin,ymax,dx,dy,aspect);

if 0	% DEBUG
%p1 = patch(0,0,'magenta');

%----------------------------------------------------
ax1 = px; ay1 = py;
angrotate = 3*pi/8;
sintheta = sin(angrotate); costheta = cos(angrotate);
rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
pr =  rotmat * [ax1;ay1];
ax1 = pr(1,:);
ay1 = pr(2,:);
ax1 = ax1 * dx * arrowscale;
ay1 = ay1 * dy * arrowscale;
p1 = patch(ax1-0.4,ay1+0.9,'blue');
%----------------------------------------------------


%----------------------------------------------------
ax1 = px; ay1 = py;
angrotate = -7*pi/8;
sintheta = sin(angrotate); costheta = cos(angrotate);
rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
pr =  rotmat * [ax1;ay1];
ax1 = pr(1,:);
ay1 = pr(2,:);
ax1 = ax1 * dx * arrowscale;
ay1 = ay1 * dy * arrowscale;
p1 = patch(ax1-0.4,ay1+0.9,'blue');
%----------------------------------------------------
end


%axis equal;
%axis square;
%axis normal;


hold on;
for i=1:n-1
	ax1 = y1(i); ax2 = ax1 + dy1(i);
	ay1 = y2(i); ay2 = ay1 + dy2(i);
	%line([ax1 ax2],[ay1 ay2],'LineStyle','-','linewidth',0.2,'Color',[0 0 0]);
	cidx = 1+mod(i,numcol);
	r = cmap(cidx,1); g = cmap(cidx,2); b = cmap(cidx,3);
	ln1 = line([ax1 ax2],[ay1 ay2],'LineStyle','-','LineWidth',linewidth,'Color',[r g b]);
	%set(ln1,'LineWidth',linewidth);	% RUN IN 2013a --- DOES NOT WORK IN 2015a
	% http://stackoverflow.com/questions/28685604/draw-bold-axes-in-matlab-properly
	%pause(0.02);

	% draw an arrow halfway on the distance vector (only 2-D)
	cx = (ax1+ax2)/2.0;
	cy = (ay1+ay2)/2.0;
	scatter(y1i,y2i,dotsize,colors(colidx),dotstyle ); %,'filled'); 
	%plot (ax1, ay1, '.', 'MarkerSize', 6, 'Color',[r g b]);
	% Paint the point with the color of its class
	[~,idx] = ismember(clss(i),classes);
	plot (ax1, ay1, '.', 'MarkerSize', 12, 'Color',colors(idx));

	%fprintf('athresh=%e dynorm(%d)=%e\n',athresh,i,dynorm(i));
	if dynorm(i) >= athresh
		%----------------------------------------------------
		auxx = px; auxy = py;
		angrotate = atan2(dy2(i)/dy,dy1(i)/dx) - pi;
		sintheta = sin(angrotate); costheta = cos(angrotate);
		rotmat(1,1) = costheta; rotmat(1,2) = -sintheta;
		rotmat(2,1) = sintheta; rotmat(2,2) =  costheta;
		pr =  rotmat * [auxx;auxy];
		auxx = pr(1,:);
		auxy = pr(2,:);
		auxx = auxx * dx * arrowscale;
		auxy = auxy * dy * arrowscale;
		p1 = patch(auxx+cx,auxy+cy,[r g b]);
		% http://www.mathworks.com/help/matlab/ref/patch.html (filled polygon)
		%----------------------------------------------------
	end
	%plot (cx, cy, '*', 'MarkerSize', 4);

end

%plot (y1(1), y2(1), '.', 'MarkerSize', 10, 'Color', [1 0 0]); % First red
%plot (y1(end), y2(end), '.', 'MarkerSize', 10, 'Color', [0 0 1]); % Last blue
[~,idx] = ismember(clss(1),classes); % Class index of first sample
plot (y1(1), y2(1),     '.', 'MarkerSize', 20, 'Color', colors(idx) ); % First: color of first class 
[~,idx] = ismember(clss(end),classes); % Class index of last sample
plot (y1(end), y2(end), '.', 'MarkerSize', 20, 'Color', colors(idx) ); % Last: color of last class

t = text(y1(1)+t0dx, y2(1)+t0dy, '$$t=0$$', 'Interpreter','latex','FontSize',fontsize);
set(t, 'HorizontalAlignment','center','VerticalAlignment','middle')
t = text(y1(end)+tmaxdx, y2(end)+tmaxdy, '$$t=t_{\mathrm{max}}$$', 'Interpreter','latex','FontSize',fontsize);
set(t, 'HorizontalAlignment','center','VerticalAlignment','middle')

xlabelpos = (xmin+xmax)/2;
ylabelpos = ymin+scatdylabel;
txlabel = text(xlabelpos,ylabelpos,'$$\mathrm{PCA}_{1}$$','Interpreter','latex','FontSize',fontsize);
set(txlabel, 'HorizontalAlignment','left','VerticalAlignment','middle')

xlabelpos = xmin-scatdxlabel;
ylabelpos = (ymin+ymax)/2;
tylabel = text(xlabelpos-1.6,ylabelpos,'$$\mathrm{PCA}_{2}$$','Interpreter','latex','FontSize',fontsize);
set(tylabel, 'HorizontalAlignment','right','VerticalAlignment','middle', 'Rotation', 90)

% Place the y text labels -- the value of delta modifies how far the labels 
% are from the axis.

hax = gca;

xtick = get(hax,'XTick');
numxticks = size(xtick,2);
set(hax,'xticklabel',[]); % clear x axis labels
for i=1:numxticks
	txtick = text( xtick(i), ymin,...
			['$$' num2str(xtick(i)) '$$'],'Interpreter','latex','FontSize',fontsize);
	set(txtick, 'HorizontalAlignment','center','VerticalAlignment','top')
end

ytick = get(hax,'YTick');
numyticks = size(ytick,2);
set(hax,'yticklabel',[]); % clear y axis labels
for i=1:numyticks
	tytick = text( xmin+scatdxtick, ytick(i),...
			['$$' num2str(ytick(i)) '$$'],'Interpreter','latex','FontSize',fontsize);
	set(tytick, 'HorizontalAlignment','right','VerticalAlignment','middle')
end




% Dump colored encapsulated PostScript
figwidthcm = 8.89;	% 3.5 inch = 252.0pt In LaTeX visualize with: \typeout{####### The column width is \the\columnwidth}
figheightcm = 4.0;
figheightcm = 8.89;
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
%fprintf('<Enter> to close ...\n'); pause;
%close(h);
