function [XTest,YTest] = prepareDataTest2(filenamePredictors,filenameResponses)

XTest = prepareDataTrain(filenamePredictors);

RULTest = dlmread(filenameResponses);

numObservations = numel(RULTest(:,3));

YTest = cell(numObservations,1);
for i = 1:numObservations
    X = XTest{i};
    sequenceLength = size(X,2);
    
    rul = RULTest(i,3);
%     YTest{i} = rul+sequenceLength-1:-1:rul;
    YTest{i} = rul;
end

end