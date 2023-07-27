function [XTest,YTest] = prepareDataTest(filenamePredictors,filenameResponses)

XTest = prepareDataTrain(filenamePredictors);

RULTest = dlmread(filenameResponses);

numObservations = length(RULTest);

YTest = cell(numObservations,1);
for i = 1:numObservations
    X = XTest{i};
    sequenceLength = size(X,2);
    
    rul = RULTest(i);
%     YTest{i} = rul+sequenceLength-1:-1:rul;
    YTest{i} = rul;
end

end