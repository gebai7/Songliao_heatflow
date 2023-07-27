
clc 
clear all


dataFolder = '全新中西部数据5.0';


%% Training Data Preparation %%
% filenamePredictors = fullfile(dataFolder,'5.1版本全球训练数据加东北数据new.txt');
filenamePredictors = fullfile(dataFolder,'5.2版本全球训练数据加英文加区域热流插值.txt');
filenamePredictors1 = fullfile(dataFolder,'5.1版本中西部数据.txt');
% filenamePredictors1 = fullfile(dataFolder,'5.2版本0.3精度松辽中西部扩边数据.txt');
filenameResponses = fullfile(dataFolder,'5.1版松辽盆地英文加区域热流插值.txt');
% filenameResponses = fullfile(dataFolder,'5.0版本长白山内蒙东北部真数据.txt');



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
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(50)
    dropoutLayer(0.5)
    fullyConnectedLayer(numResponses)
    regressionLayer];


%% solver 'adam'%%

maxEpochs = 300;
miniBatchSize = 100;
maxEpochs = 100;
miniBatchSize = 128;
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

XTest = prepareDataTrain(filenamePredictors1);

mu1 = mean([XTest{:}],2);
sig1 = std([XTest{:}],0,2);
mu1(4,:)=mu(4,:);
sig1(4,:)=sig(4,:);
for i = 1:numel(XTest)
    XTest{i} = (XTest{i} - mu) ./ (sig);
    
end

% YPred = predict(net,XTrain,'MiniBatchSize',1);
YPred = predict(net,XTest,'MiniBatchSize',1);
%% RMSE %%

for i = 1:numel(YPred)
%     YTestLast(i) = YTest{i}(end);
    YPredLast(i) = YPred{i}(end);
end

figure
vyy = dlmread(filenameResponses);
vxx= dlmread(filenamePredictors1);

ao=[vxx(:,1) vxx(:,2) YPredLast'];

scatter(vxx(:,1),vxx(:,2),[],YPredLast','filled');colormap('jet')
hold on
% figure
scatter(vyy(:,1),vyy(:,2),[],vyy(:,3),'filled');colormap('jet')
hold on
dasd=dlmread(fullfile(dataFolder,'5.0版本中西部数据.txt'));
scatter(dasd(:,1),dasd(:,2),[],dasd(:,3),'filled');colormap('jet')
figure
dasd=dlmread(fullfile(dataFolder,'5.0版本全球训练数据.txt'));
scatter(dasd(:,1),dasd(:,2),[],dasd(:,3),'filled');colormap('jet')
hold on
scatter(vxx(:,1),vxx(:,2),[],YPredLast','filled');colormap('jet')


x1=[vxx(:,1); vyy(:,1)];
y1=[vxx(:,2); vyy(:,2)];
z1=[YPredLast'; vyy(:,3)];
fg=[x1 y1 z1];
fg1=[vxx(:,1) vxx(:,2) YPredLast'];

%  save llailai.txt -ascii fg1 

% fg(:,3)=smooth(fg(:,3));
% scatter(x1,y1,[],z1,'filled');colormap('jet')
% scatter(fg(:,1),fg(:,2),[],fg(:,3),'filled');colormap('jet')
