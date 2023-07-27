function [trainedResTempSVMModel, validationRMSE] = trainResTempSVMModel(trainingData)
% returns a trained regression model and its RMSE. This code recreates the

% Extract predictors and response
inputTable = trainingData;
predictorNames = {'Location', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
predictors = inputTable(:, predictorNames);
response = inputTable.TemperatureC;
isCategoricalPredictor = [true, false, false, false, false, false, false, false];

% Train a regression model
responseScale = iqr(response);
if ~isfinite(responseScale) || responseScale == 0.0
    responseScale = 1.0;
end
boxConstraint = responseScale/1.349;
epsilon = responseScale/13.49;
regressionSVM = fitrsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', boxConstraint, ...
    'Epsilon', epsilon, ...
    'Standardize', true);

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(regressionSVM, x);
trainedResTempSVMModel.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedResTempSVMModel.RequiredVariables = {'Location', 'pH', 'ECConductivity', 'Kmgl', 'Namgl', 'Boronmgl', 'SiO2mgl', 'Clmgl'};
trainedResTempSVMModel.RegressionSVM = regressionSVM;

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
    % This code specifies all the model options and trains the model.
    responseScale = iqr(trainingResponse);
    if ~isfinite(responseScale) || responseScale == 0.0
        responseScale = 1.0;
    end
    boxConstraint = responseScale/1.349;
    epsilon = responseScale/13.49;
    regressionSVM = fitrsvm(...
        trainingPredictors, ...
        trainingResponse, ...
        'KernelFunction', 'linear', ...
        'PolynomialOrder', [], ...
        'KernelScale', 'auto', ...
        'BoxConstraint', boxConstraint, ...
        'Epsilon', epsilon, ...
        'Standardize', true);
    
    % Create the result struct with predict function
    svmPredictFcn = @(x) predict(regressionSVM, x);
    validationPredictFcn = @(x) svmPredictFcn(x);
    
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
