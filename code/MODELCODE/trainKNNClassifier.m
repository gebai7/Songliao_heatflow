function [trainedKNNClassifier, validationAccuracy] = trainKNNClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'TemperatureC', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.EnthalpyCategory;
isCategoricalPredictor = [false, false, false, false, false, false, false, false];

% Train a classifier
classificationKNN = fitcknn(...
    predictors, ...
    response, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 1, ...
    'DistanceWeight', 'Equal', ...
    'Standardize', true, ...
    'ClassNames', categorical({'HIGH'; 'LOW'; 'MEDIUM'}));

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
knnPredictFcn = @(x) predict(classificationKNN, x);
trainedKNNClassifier.predictFcn = @(x) knnPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedKNNClassifier.RequiredVariables = {'TemperatureC', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
trainedKNNClassifier.ClassificationKNN = classificationKNN;

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'TemperatureC', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.EnthalpyCategory;
isCategoricalPredictor = [false, false, false, false, false, false, false, false];

% Perform cross-validation
partitionedModel = crossval(trainedKNNClassifier.ClassificationKNN, 'KFold', 5);

% Compute validation predictions
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
