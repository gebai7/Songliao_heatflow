function [XTrain,YTrain] = prepareDataTrain2m(filenamePredictors1)

dataTrain = dlmread(filenamePredictors1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% dataTrain(:,8)=[];
% dataTrain(:,10)=[];
% dataTrain(:,10)=[];
% dataTrain(:,5)=[];
% dataTrain(:,4)=dataTrain(:,4)-10;
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
    
    X = dataTrain(i,2:end)';
    XTrain{i} = X;
    
    Y = dataTrain(i,1)';
%     Y = dataTrain(idx,3)';
    YTrain{i} = Y;
end

end