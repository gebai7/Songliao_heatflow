function [XTrain,YTrain] = prepareDataTrain(filenamePredictors)

dataTrain = dlmread(filenamePredictors);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cut final 5
% dataTrain(:,14+3)=[];
% dataTrain(:,11+3)=[];
% dataTrain(:,8+3)=[];
% dataTrain(:,5+3)=[];
% dataTrain(:,2+3)=[];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numObservations = max(dataTrain(:,1));
numObservations = length(dataTrain(:,1));
% 
XTrain = cell(numObservations,1);
YTrain = cell(numObservations,1);
% XTrain = cell(1,1);
% YTrain = cell(1,1);
for i = 1:numObservations
% for i = 1:length(dataTrain(:,1))
%     idx = dataTrain(:,1) == i;
    
%     X = dataTrain(idx,3:end)';
% %         X = dataTrain(i,4:end)';zhongxibu
    X = dataTrain(i,4:end)';
    %%%%%%%%%%%%%%%%%%%
%     X1 = dataTrain(i,1:2)';
%    
%%%%%%%%%%%%%%%%
     XTrain{i} = [X];

       % Y = dataTrain(i,3)';    zhongxibu
    Y = dataTrain(i,3)';
%     Y = dataTrain(idx,3)';
    YTrain{i} = Y;
end

end