function [trainedResTempModel, validationRMSE] = trainResTempRegressionModel(trainingData)
% returns a trained regression model and its RMSE. 
%

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'Location', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.TemperatureC;
isCategoricalPredictor = [true, false, false, false, false, false, false, false];

% Train a regression model
concatenatedPredictorsAndResponse = predictors;
concatenatedPredictorsAndResponse.TemperatureC = response;
linearModel = fitlm(...
    concatenatedPredictorsAndResponse, ...
    'linear', ...
    'RobustOpts', 'off');

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
linearModelPredictFcn = @(x) predict(linearModel, x);
trainedResTempModel.predictFcn = @(x) linearModelPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedResTempModel.RequiredVariables = {'Location', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
trainedResTempModel.LinearModel = linearModel;

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'Location', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.TemperatureC;
isCategoricalPredictor = [true, false, false, false, false, false, false, false];

% Perform cross-validation
KFolds = 5;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% Initialize the predictions to the proper sizes
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;
    
    % Train a regression model
    concatenatedPredictorsAndResponse = trainingPredictors;
    concatenatedPredictorsAndResponse.TemperatureC = trainingResponse;
    linearModel = fitlm(...
        concatenatedPredictorsAndResponse, ...
        'linear', ...
        'RobustOpts', 'off');
    
    % Create the result struct with predict function
    linearModelPredictFcn = @(x) predict(linearModel, x);
    validationPredictFcn = @(x) linearModelPredictFcn(x);
    
    % Add additional fields to the result struct
    
    % Compute validation predictions
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);
    
    % Store predictions in the original order
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% Compute validation RMSE
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));
