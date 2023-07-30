%Self organizing map for CSTR Simulator

load cstr_matlab.txt

[T, D] = size(cstr_matlab);
cstr_norm = zeros(T,D);
maxVal = max(cstr_matlab);
maxVal = max(maxVal);
minVal = min(cstr_matlab);
minVal = min(minVal);

for i=1:T
    for j=1:D
        cstr_norm(i,j) = (cstr_matlab(i,j) - minVal)/(maxVal - minVal);
    end
end

net = selforgmap([4 4]);
net = configure(net, cstr_norm);
net.trainParam.epochs = 1000;
net = train(net, cstr_norm);

%Teste
%y = net(cstr_norm(22,:));
%y = vec2ind(y');