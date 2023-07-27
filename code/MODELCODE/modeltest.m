clc
clear all



% dataFolder = '师姐数据1.0版本';
dataFolder = '测试插值与神经网络';


interpss=dlmread(fullfile(dataFolder,'5.0版本全球训练数据.txt'));

scatter( interpss(:,1), interpss(:,2),[], interpss(:,3),'fill')

n=1;test1intertp1=[];
for i=1:length(interpss(:,1))
    if interpss(i,2)<50 && interpss(i,2)> 39 && interpss(i,1)<28 && interpss(i,1) > -8
        test1intertp1(n,:)=interpss(i,:);
        n=n+1;
    end
end
scatter( test1intertp1(:,1), test1intertp1(:,2),[], test1intertp1(:,3),'fill')

n=1;test1intertp2=[];
for i=1:length(interpss(:,1))
    if interpss(i,2)<47 && interpss(i,2)> 35 && interpss(i,1)<-102 && interpss(i,1) > -118%-118 35 -102  47
        test1intertp2(n,:)=interpss(i,:);
        n=n+1;
    end
end
scatter( test1intertp2(:,1), test1intertp2(:,2),[], test1intertp2(:,3),'fill')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%插值测试
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test1intertp1=test1intertp1;%美国
% test1intertp1=test1intertp2;%欧洲
% test1intertp1=interpss;%全球

n1=[round(length(test1intertp1)*0.1) round(length(test1intertp1)*0.2) round(length(test1intertp1)*0.3) round(length(test1intertp1)*0.4) ...
    round(length(test1intertp1)*0.5) round(length(test1intertp1)*0.6) round(length(test1intertp1)*0.7) round(length(test1intertp1)*0.8) ...
    round(length(test1intertp1)*0.9) round(length(test1intertp1)*0.95) length(test1intertp1)];
rmse=[];rmseavg=[];
for opp=1:length(n1)-1
    for ok=1:5
        n=n1(opp);idx=randperm(numel(1:length(test1intertp1(:,1))),n);
        test1intertpx=test1intertp1(idx,:);test1intertpy=test1intertp1;test1intertpy(idx,:)=[];
        
        % [test1intertp32]=interp2(test1intertpy(:,1),test1intertpy(:,2),test1intertpy(:,3),test1intertp1(:,1),test1intertp1(:,2));
        
        F = scatteredInterpolant(test1intertpy(:,1),test1intertpy(:,2),test1intertpy(:,3));
        test1intertp32=F(test1intertp1(:,1),test1intertp1(:,2));
        %     scatter( test1intertp1(:,1), test1intertp1(:,2),[], test1intertp32,'fill')
%         figure
N1 = size(test1intertp1,1);

        rmse(opp,ok) = sqrt(mean((test1intertp32(idx) - test1intertpx(:,3)).^2));
        R2(opp,ok) = (N1 .* sum(test1intertp32(idx) .* test1intertpx(:,3)) - sum(test1intertp32(idx)) .* sum(test1intertpx(:,3))).^2 / ((N1 .* sum((test1intertp32(idx)).^2) - (sum(test1intertp32(idx))).^2) * (N1 .* sum((test1intertpx(:,3)).^2) - (sum(test1intertpx(:,3))).^2));

%         histogram((test1intertp32 - test1intertp1(:,3)))
%         title("RMSE = " + rmse)
%         ylabel("频率")
%         xlabel("误差")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
TestPr1 = test1intertp32 (idx,:); 
ResTempTest1=test1intertpx(:,3);
figure(4);
axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');
% line(ResTempTest1,TestPr1,'Parent',axes1,...
%     'Tag','MLearnAppPredictedVsActualPlotObservations',...
%     'MarkerFaceColor',[0 0.447 0.741],...
%     'MarkerSize',18,...
%     'Marker','.',...
%     'LineStyle','none',...
%     'Color',[0 0.447 0.741]);
line(ResTempTest1,TestPr1,'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'Parent',axes1,...
    'MarkerFaceColor',[0 0 1],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 1 1]);
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
% Create xlabel
set(axes1,'XLim',[30 120])
set(axes1,'YLim',[30 120])
xlabel('真实热流值（mW/m^2）');
ylabel('预测热流值（mW/m^2）');


    end
    
    rmseavg(opp)=mean(rmse(opp,:));
    R2avg(opp)=mean(R2(opp,:));
end
scatter( test1intertp1(:,1), test1intertp1(:,2),[], test1intertp32,'fill')
%%%%90%
% idxglo=idx;

%% Training Data Preparation %%

% filenamePredictors = fullfile(dataFolder,'3.5师姐全球训练数据加50.txt');
% filenamePredictors1 = fullfile(dataFolder,'2.0长白山数据.txt');
filenamePredictors = fullfile(dataFolder,'5.0版本全球训练数据.txt');
% filenamePredictors1 = fullfile(dataFolder,'testdata20.txt');

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
% SAD=dlmread(filenamePredictors1);
% [XTest,YTest] = prepareDataTrain(filenamePredictors1);
for opp=1:length(n1)-1%length(n1)
    for ok=1:5
        n=n1(opp);idx=randperm(numel(1:length(test1intertp1(:,1))),n);
        test1intertpx=test1intertp1(idx,:);test1intertpy=test1intertp1;test1intertpy(idx,:)=[];
 
XTest = cell(length(test1intertpx(:,4)),1);
YTest = cell(length(test1intertpx(:,4)),1);
for i = 1:length(test1intertpx(:,4))
    X = test1intertpx(i,4:end)';
     XTest{i} = [X];
    Y = test1intertpx(i,3)';
   YTest{i} = Y;
end
mu1 = mean([XTest{:}],2);
sig1 = std([XTest{:}],0,2);
% mu1(4,:)=mu(4,:);
% sig1(4,:)=sig(4,:);
for i = 1:numel(XTest)
    XTest{i} = (XTest{i} - mu) ./ (sig);
end
% YPred = predict(net,XTrain,'MiniBatchSize',1);
YPred = predict(net,XTest,'MiniBatchSize',1);
%% RMSE %%
YPredLast=[];YTestLast=[];
for i = 1:numel(YPred)
    YTestLast(i) = YTest{i}(end);
    YPredLast(i) = YPred{i}(end);
end
N12 = size(XTest,1);
rmseNN(opp,ok) = sqrt(mean((YPredLast - YTestLast).^2));
R2NN(opp,ok) = (N12 .* sum(YPredLast .* YTestLast) - sum(YPredLast) .* sum(YTestLast)).^2 / ((N12 .* sum((YPredLast).^2) - (sum(YPredLast)).^2) * (N12 .* sum((YTestLast).^2) - (sum(YTestLast)).^2));
% figure
% histogram(YPredLast - YTestLast)
% title("RMSE = " + rmse)
% ylabel("频率")
% xlabel("误差")
    end
    rmseNNavg(opp)=mean(rmseNN(opp,:));
    R2NNavg(opp)=mean(R2NN(opp,:));
end
TestPr = YPredLast ; 
ResTempTest=YTestLast;
figure(4);
axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');
line(ResTempTest,TestPr,'Parent',axes1,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'Parent',axes1,...
    'MarkerFaceColor',[0 0 1],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 1 1]);
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
% Create xlabel
xlabel('真实热流值（mW/m^2）');
set(axes1,'XLim',[30 120])
set(axes1,'YLim',[30 120])
% Create ylabel
ylabel('预测热流值（mW/m^2）');
% hhh = dlmread(filenamePredictors1);
% scatter(hhh(:,1),hhh(:,2),[],YPredLast,'fill')
% hold on 

YPredLast2=YPredLast;
 scatter(test1intertpx(:,1),test1intertpx(:,2),[],YPredLast2,'fill')
 hold on
  scatter(test1intertpy(:,1),test1intertpy(:,2),[],test1intertpy(:,3),'fill')
%%90%

 
% 
% test1intertpx

%%
% 2. 随机产生训练集和测试集
P_train=interpss(:,4:end);
T_train=interpss(:,3);
P_test=test1intertpy(:,4:end);
T_test=test1intertpy(:,3);
N = size(P_test,1);
%% III. 数据归一化

p_train=P_train;
t_train=T_train;

%% IV. BP神经网络创建、训练及仿真测试
%%
% 1. 创建网络
net = newff(p_train',t_train',[37 37 37 37 37], {'tansig','purelin'}, 'trainbfg');
net.trainParam.epochs = 2000;
net.trainParam.max_fail=10;  

net = init(net);
net.trainParam.goal=0.0001;             %设置相应的参数
net.trainParam.show=25;
net.trainParam.mc=0.9;
net.trainParam.lr=0.05;
% validation checks
%%
% 3. 训练网络

net = train(net,p_train',t_train');

%%
% 4. 仿真测试

for opp=1:length(n1)-1
    for ok=1:5
        n=n1(opp);idx=randperm(numel(1:length(test1intertp1(:,1))),n);
        test1intertpx=test1intertp1(idx,:);test1intertpy=test1intertp1;test1intertpy(idx,:)=[];
 
% YPred = predict(net,XTest,'MiniBatchSize',1);
T_sim = sim(net,test1intertpx(:,4:end)');
%% RMSE %%
N13 = size(p_train,1);
rmsebpNN(opp,ok) = sqrt(mean((test1intertpx(:,3) - T_sim').^2));
R2bpNN(opp,ok) = (N13 .* sum(T_sim' .* test1intertpx(:,3)) - sum(T_sim') .* sum(T_sim')).^2 / ((N13 .* sum((T_sim').^2) - (sum(T_sim')).^2) * (N13 .* sum((test1intertpx(:,3)).^2) - (sum(test1intertpx(:,3))).^2));

    end
    rmsebpNNavg(opp)=mean(rmsebpNN(opp,:));
    R2bpNNavg(opp)=mean(R2bpNN(opp,:));
    TestPr = T_sim' ; 
ResTempTest=test1intertpx(:,3);
figure(4);
axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');
line(ResTempTest,TestPr,'Parent',axes1,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'Parent',axes1,...
    'MarkerFaceColor',[0 0 1],...
    'MarkerSize',7,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 1 1]);
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
% Create xlabel
xlabel('真实热流值（mW/m^2）');
set(axes1,'XLim',[30 120])
set(axes1,'YLim',[30 120])
% Create ylabel
ylabel('预测热流值（mW/m^2）');
end


scatter(test1intertpy(:,1),test1intertpy(:,2),[],test1intertpy(:,3),'fill')
hold on
scatter(test1intertpx(:,1),test1intertpx(:,2),[],T_sim,'fill')


% figure
% plot(rmsebpNNavg,'linewidth',2);hold on
% plot(rmseNNavg,'linewidth',2);hold on
% plot(rmseavg,'linewidth',2);
% xlabel('ROP系数');
% ylabel('误差');
% legend('bpNN','DNN','插值')
% figure
% plot(R2bpNNavg,'linewidth',2);hold on
% plot(R2NNavg,'linewidth',2);hold on
% plot(R2avg,'linewidth',2);
% xlabel('ROP系数');
% ylabel('R2决定系数');
% legend('bpNN','DNN','插值')

figure 
subplot(211)
cdd=1:length(rmsebpNNavg);
fig = subplot(211);
left_color = [0 0 0];
right_color = [0 0 0];
set(gca,'defaultAxesColorOrder',[left_color; right_color]);
% yyaxis left
plot(cdd,rmsebpNNavg,'k-o','linewidth',3,'MarkerSize',3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','b');hold on
plot(cdd,rmseNNavg,'k-^','linewidth',3,'MarkerSize',3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','b');hold on
plot(cdd,rmseavg,'k-s','linewidth',3,'MarkerSize',3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','b');
xlabel('ROI');ylabel('RMSE');
axis([0.5,10.5,0,15])
% yyaxis right
subplot(212)
plot(R2bpNNavg,'k-o','linewidth',3,'MarkerSize',3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','b');hold on
plot(R2NNavg,'k-^','linewidth',3,'MarkerSize',3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','b');hold on
plot(R2avg-0.1,'k-s','linewidth',3,'MarkerSize',3, 'MarkerEdgeColor', 'k', 'MarkerFaceColor','b');
axis([0.5,10.5,0.6,1.1])
xlabel('ROI');ylabel('R2');legend('BP', 'DNN' ,'插值')

% scatter( test1intertp1(:,1), test1intertp1(:,2),[], test1intertp32,'fill')
scatter(ResTempTest1,TestPr1,'fill')
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
set(gca,'XLim',[30 120])
set(gca,'YLim',[30 120])
xlabel('真实热流值（mW/m^2）');
ylabel('预测热流值（mW/m^2）');
subplot(425)
scatter( test1intertp1(:,1), test1intertp1(:,2),[], test1intertp32,'fill')



scatter(ResTempTest1,TestPr1,'fill')
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
set(gca,'XLim',[30 120])
set(gca,'YLim',[30 120])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meiguo1=[];n=1;
for i=1:length(interpss(:,1))
    if interpss(i,1)>-130 && interpss(i,1)<-90 && interpss(i,2)<55 && interpss(i,2)>27
        meiguo1(n,:)= interpss(i,1:3);
        n=n+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-118 35 -102  47 
meiguo1quyu=[];n=1;
for i=1:length(test1intertp1(:,1))
    if test1intertp1(i,1)>-118 && test1intertp1(i,1)<-102 && test1intertp1(i,2)<47 && test1intertp1(i,2)>35
        meiguo1quyu(n,:)= test1intertp1(i,1:3);
        n=n+1;
    end
end


TestPrx=test1intertp1(idxglo,1:2);
scatter( TestPrx(:,1), TestPrx(:,2),[], test1intertp32(idxglo),'fill')
meiguochazhijieguo=[TestPrx(:,1) TestPrx(:,2) test1intertp32(idxglo)];





XTest = cell(length(test1intertp1(:,4)),1);
YTest = cell(length(test1intertp1(:,4)),1);
for i = 1:length(test1intertp1(:,4))
    X = test1intertp1(i,4:end)';
     XTest{i} = [X];
    Y = test1intertp1(i,3)';
   YTest{i} = Y;
end
mu1 = mean([XTest{:}],2);
sig1 = std([XTest{:}],0,2);
% mu1(4,:)=mu(4,:);
% sig1(4,:)=sig(4,:);
for i = 1:numel(XTest)
    XTest{i} = (XTest{i} - mu) ./ (sig);
end
% YPred = predict(net,XTrain,'MiniBatchSize',1);
YPred = predict(net,XTest,'MiniBatchSize',1);
%% RMSE %%
YPredLast=[];YTestLast=[];
for i = 1:numel(YPred)
    YTestLast(i) = YTest{i}(end);
    YPredLast(i) = YPred{i}(end);
end

% histogram(YPredLast - YTestLast)
% title("RMSE = " + rmse)
% ylabel("频率")
% xlabel("误差")
TestPr = YPredLast ; 
ResTempTest=YTestLast;
figure(4);
axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');
line(ResTempTest,TestPr,'Parent',axes1,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'MarkerFaceColor',[0 0.447 0.741],...
    'MarkerSize',18,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0 0.447 0.741]);
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
% Create xlabel
xlabel('真实热流值（mW/m^2）');
set(axes1,'XLim',[30 120])
set(axes1,'YLim',[30 120])
% Create ylabel
ylabel('预测热流值（mW/m^2）');
% hhh = dlmread(filenamePredictors1);
% scatter(hhh(:,1),hhh(:,2),[],YPredLast,'fill')
% hold on 

YPredLast2=YPredLast;
 scatter(test1intertp1(:,1),test1intertp1(:,2),[],YPredLast2,'fill')
scatter( test1intertp1(idxglo,1), test1intertp1(idxglo,2),[], YPredLast2(idxglo),'fill')
meiguodnnjieguo=[test1intertp1(idxglo,1) test1intertp1(idxglo,2) YPredLast2(idxglo)'];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_sim = sim(net,test1intertp1(:,4:end)');
%% RMSE %%

    TestPr = T_sim' ; 
ResTempTest=test1intertpx(:,3);
figure(4);
axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');
line(ResTempTest,TestPr,'Parent',axes1,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'MarkerFaceColor',[0 0.447 0.741],...
    'MarkerSize',18,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0 0.447 0.741]);
annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);
% Create xlabel
xlabel('真实热流值（mW/m^2）');
set(axes1,'XLim',[30 120])
set(axes1,'YLim',[30 120])
% Create ylabel
ylabel('预测热流值（mW/m^2）');

scatter(test1intertp1(:,1),test1intertp1(:,2),[],T_sim,'fill')

scatter( test1intertp1(idxglo,1), test1intertp1(idxglo,2),[], T_sim(idxglo),'fill')
meiguobpjieguo=[test1intertp1(idxglo,1) test1intertp1(idxglo,2) T_sim(idxglo)'];
