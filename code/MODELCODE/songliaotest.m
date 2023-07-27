
clc 
clear all


% dataFolder = '师姐数据1.0版本';
dataFolder = '全新中西部数据5.0';

%% Training Data Preparation %%

% filenamePredictors = fullfile(dataFolder,'3.5师姐全球训练数据加50.txt');
% filenamePredictors1 = fullfile(dataFolder,'2.0长白山数据.txt');
filenamePredictors = fullfile(dataFolder,'5.0版本全球训练数据加东北数据.txt');
filenamePredictors1 = fullfile(dataFolder,'5.0版本绝对真实中西部数据.txt');

% % filenameResponses = fullfile(dataFolder,'qq_baihua(1).txt');
% % filename111 = fullfile(dataFolder,'qqzhen.txt');
% filenamePredictors = fullfile(dataFolder,'ResTempTrain.txt');


[XTrain,YTrain] = prepareDataTrain(filenamePredictors);




m = min([XTrain{:}],[],2);
M = max([XTrain{:}],[],2);
idxConstant = M == m;

for i = 1:numel(XTrain)
    XTrain{i}(idxConstant,:) = [];
end

% Normalization %%
mu = mean([XTrain{:}],2);
sig = std([XTrain{:}],0,2);

for i = 1:numel(XTrain)
    XTrain{i} = (XTrain{i} - mu) ./ (sig);
end

%% Define Network Architecture %%

numResponses = size(YTrain{1},1);
featureDimension = size(XTrain{1},1);
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(featureDimension)
    lstmLayer(numHiddenUnits,'OutputMode','sequence','StateActivationFunction','tanh')
    fullyConnectedLayer(50)
    dropoutLayer(0.5)
    fullyConnectedLayer(numResponses)
    regressionLayer];
% 
% layers = [ ...
%     imageInputLayer([28 28 1])
%     convolution2dLayer(5,20)
%     reluLayer
%     maxPooling2dLayer(2,'Stride',2)
%     fullyConnectedLayer(10)
%     softmaxLayer
%     classificationLayer];
%% solver 'adam'%%

maxEpochs = 100;%100
miniBatchSize = 128;%128

options = trainingOptions('adam', ...
    'GradientDecayFactor',0.9, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.005, ...
    'GradientThreshold',1, ...
    'GradientThresholdMethod','l2norm', ...
    'Shuffle','every-epoch', ...
     'Plots','training-progress',...
    'Verbose',0);


%% Train the Network %%

net = trainNetwork(XTrain,YTrain,layers,options);

%% Test the Network %%


% [XTest,YTest] = prepareDataTest2(filenamePredictors1,filenamePredictors1);
% SAD=dlmread(filenamePredictors1);
[XTest,YTest] = prepareDataTrain(filenamePredictors1);

mu1 = mean([XTest{:}],2);
sig1 = std([XTest{:}],0,2);
% mu1(4,:)=mu(4,:);
% sig1(4,:)=sig(4,:);
for i = 1:numel(XTest)
    XTest{i} = (XTest{i} - mu) ./ (sig);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XTest1=reshape(cell2mat(XTest),featureDimension,length(XTest))';
XTrain1=reshape(cell2mat(XTrain),featureDimension,length(XTrain))';
XTestandtrain=[XTrain1 ;XTest1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% YPred = predict(net,XTrain,'MiniBatchSize',1);
YPred = predict(net,XTest,'MiniBatchSize',1);
%% RMSE %%

for i = 1:numel(YPred)
    YTestLast(i) = YTest{i}(end);
    YPredLast(i) = YPred{i}(end);
end
figure

rmse = sqrt(mean((YPredLast - YTestLast).^2));
histogram(YPredLast - YTestLast)
title("RMSE = " + rmse)
ylabel("频率")
xlabel("误差")


TestPr = YPredLast ; 
ResTempTest=YTestLast;
figure(4);
subplot(211)
% axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');

line(ResTempTest,TestPr,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'MarkerFaceColor',[0 0 1],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 1 1]);
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);

% Create xlabel
xlabel('真实热流值（mW/m^2）');
set(gca,'XLim',[20 120])
set(gca,'YLim',[20 120])
% Create ylabel
ylabel('预测热流值（mW/m^2）');
subplot(212)
rmse = sqrt(mean((YPredLast - YTestLast).^2));
histogram(YPredLast - YTestLast)
title("RMSE = " + rmse)
ylabel("频率")
xlabel("误差")
% hhh = dlmread(filenamePredictors1);
% scatter(hhh(:,1),hhh(:,2),[],YPredLast,'fill')
% hold on 


% figure
% x=[1 2 3 4 5 6 7 8 9 10]
% y=[60 50 30  5 6 7 8 9 10]

mean(YPredLast-YTestLast)
