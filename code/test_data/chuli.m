
clc
clear all
% a=xlsread('globelheatpara.xlsx');
% b=xlsread('globleheatres.xlsx');

a=xlsread('5.0版本全球para.xlsx');
b=xlsread('5.0版本全球res.xlsx');

histogram(a(:,10))

for i=1:length(a(:,1))
    if a(i,10)<-1000
        a(i,10)=(a(i+1,10)+a(i-1,10))/2;
    end
end

mu1 = mean(a);
sig1 = std(a);
mu2 = mean(b);
sig2 = std(b);


for i = 1:numel(a(:,1))
    a1(i,:) = (a(i,:) - mu1) ./ (sig1);
    b1(i,:) = (b(i,:) - mu2) ./ (sig2);
end

randn(1,4034)';
histogram(ans)


