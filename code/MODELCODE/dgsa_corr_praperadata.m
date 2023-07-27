function [XTest1,YTest1]=dgsa_corr_praperadata(dataTrain)

numObservations = length(dataTrain(:,1));
% 
XTest1 = cell(numObservations,1);
YTest1 = cell(numObservations,1);

for i = 1:numObservations
    X = dataTrain(i,4:end)';

     XTest1{i} = [X];

       % Y = dataTrain(i,3)';    zhongxibu
    Y = dataTrain(i,3)';
%     Y = dataTrain(idx,3)';
    YTest1{i} = Y;
end