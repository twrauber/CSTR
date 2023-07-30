function data = cstrdataread( filename, sepchar, namenormalclass )
%CSTRDATAREAD
%   Reads classification information
%   from a CSV data file produced by the MIT-CSTR simulator
%
%   Syntax: data=cstrdataread( filename ) 
%
%   Inputs:
%     filename	-	name of the data file in CSV format with special
%			format: first line has number of features.
%			Each line has as the last column the name of the class
%     sepchar	-	CSV separator (';', char(9)=TAB, etc.)
%     namenormalclass - name of the normal class label, e.g. 'normal' or '0'
%
%   Outputs:
%     n		-	amount of data samples (number of lines of data matrix 'X')
%     nnormal	-	amount of data samples belonging to 'normal' class
%			(number of lines of data matrix 'XConditionNormal')
%     numfeat	-	amount of features (number of columns of data matrices 'X' and
%			'XConditionNormal'
%     clss	-	cell array with class label of each sample
%     classes 	-	The different class labels that appear in the file
%     numclass	-	amount of different class labels
%     X	-		data matrix of all 'n' samples
%     XConditionNormal	- data matrix of all 'nnormal' samples belonging to 'normal' class
%     idxConditionNormal - indices of all 'nnormal' samples belonging to 'normal' class





f = fopen(filename,'rt');
% count number of lines
k = 0;
numcommentlines = 0;
while ~feof(f)
	l = fgetl(f);	% don't call it 'line', since this overwrites the function 'line'
	%fprintf('Line #%4d = ''%s''\n', k+1, l );
	commentexpression = '[#]+'; % find comment character in string
	startIndex = regexp(l,commentexpression);
	if ~isempty(startIndex) % normal class
		numcommentlines = numcommentlines+1;
	end
	k = k + 1;
end
fclose(f);
n = k-numcommentlines-1;

f = fopen(filename,'rt');
for i=1:numcommentlines
	l = fgetl(f); % Read all comment lines
end
l = fgetl(f); % Read one header line
numfeat = sscanf(l,'%d');

X = zeros(n,numfeat);
clss = cell(n,1);
normalindex = zeros(n,1);
k = 1;
while ~feof(f)
	l = fgetl(f);	% don't call it 'line', since this overwrites the function 'line'
	%fprintf('Line #%4d = ''%s''\n', k+1, l );
	cols = strsplit(l,sepchar);
	%cols = strsplit(l,';')
	for j=1:numfeat
		%fprintf('Line #%4d j=%d cols(%d)=%f\n', k+1, j, j, str2double(cols(j)) );
		X(k,j) = str2double(cols(j));
	end
	clss(k) = strtrim(cols(numfeat+1));
	if isequal(clss(k),namenormalclass)
		normalinex(k) = true;
	end
	k = k + 1;
end
fclose(f);

% Filter out samples that belog to the normal class
idxConditionNormal = cellfun(@isequal, clss, repmat({namenormalclass},n,1));
idxConditionNormal = logical(idxConditionNormal);
XConditionNormal = X(idxConditionNormal,:);
nnormal = size(XConditionNormal,1); % Number of normal samples

data.n = n;
data.nnormal = nnormal;
data.numfeat = numfeat;
data.clss = clss;
data.classes = unique(clss);
data.numclass = size(data.classes,1);
data.X = X;
data.idxConditionNormal = idxConditionNormal;
data.XConditionNormal = XConditionNormal;

if 1
fprintf('Number of samples = %d\n', n );
fprintf('Number of normal samples = %d\n', nnormal );
fprintf('Number of features = %d\n', numfeat );
end

end