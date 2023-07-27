function [trainedSVMClassifier, validationAccuracy] = trainSVMClassifier(trainingData)
% returns a trained classifier and its accuracy. 

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'Location', 'TemperatureC', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.EnthalpyCategory;
isCategoricalPredictor = [true, false, false, false, false, false, false, false, false];

% Train a classifier
template = templateSVM(...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', categorical({'HIGH'; 'LOW'; 'MEDIUM'}));

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedSVMClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedSVMClassifier.RequiredVariables = {'Location', 'TemperatureC', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
trainedSVMClassifier.ClassificationSVM = classificationSVM;

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'Location', 'TemperatureC', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.EnthalpyCategory;
isCategoricalPredictor = [true, false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedSVMClassifier.ClassificationSVM, 'KFold', 5);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
