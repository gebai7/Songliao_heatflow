
clc 
clear all


dataFolder = '全新中西部数据5.0';
filenamePredictors = fullfile(dataFolder,'5.1版本全球训练数据加东北数据.txt');
filenameResponses = fullfile(dataFolder,'5.1版本绝对真实中西部数据.txt');
Testone=dlmread(fullfile(dataFolder,'5.1版本绝对真实中西部数据.txt'));

dataTrain = dlmread(filenamePredictors);
testobj = dlmread(filenameResponses);
ss=dlmread(fullfile(dataFolder,'dgsa_measuresxin5.txt'));
ss(end)=[];ss(1:2)=[];
[ssA,ind]=sort(ss,'descend');
% okk=[6 9 11 13 15 17 20 24];
okk=[4 6 8 10 12 14 16 19 23];
coornum=[0 0.3 0.5 0.7];
% coornum=[0 0.3 0.5 0.7];
landa=1;
%% Training Data Preparation %%
for al=1:length(okk)
paratest=dataTrain(:,4:end);
testobjle=testobj(:,4:end);
% paratest=paratest(:,find(ind<okk(al)));paratest=[dataTrain(:,1:3) paratest ];
% responetest=testobjle(:,find(ind<okk(al)));responetest=[testobj(:,1:3) responetest ];

paratest=paratest(:,ind(1:okk(al)));paratest=[dataTrain(:,1:3) paratest ];
responetest=testobjle(:,ind(1:okk(al)));responetest=[testobj(:,1:3) responetest ];

mu = mean(paratest,1);
sig = std(paratest,0,1);
paratest1=[];responetest1=[];
for i = 1:length(paratest(:,1))
    paratest1(i,:) = (paratest(i,:) - mu) ./ (sig);
end
for i = 1:length(responetest(:,1))
    responetest1(i,:) = (responetest(i,:) - mu) ./ (sig);
end
corr=zeros(length(paratest1(:,1)),length(responetest1(:,1)));

for i=1:length(paratest1(:,1))
    for j=1:length(responetest1(:,1))
        A=corrcoef(paratest1(i,3:end),responetest1(j,3:end));
        corr(i,j)=A(1,2);
    end
end
meancorr=mean(corr,2);
absmeancorr=abs(meancorr);
absmeancorr1(al)=mean(absmeancorr);


for op=1:length(coornum)
n=1;corrtrain=[];
for i=1:length(absmeancorr)
    if absmeancorr(i)>coornum(op)
       corrtrain(n,:)=paratest(i,:);
       n=n+1;
    end
end


numObservations = length(corrtrain(:,1));
XTrain = cell(numObservations,1);
YTrain = cell(numObservations,1);
for i = 1:numObservations
    X = corrtrain(i,4:end)';
     XTrain{i} = [X];
    Y = corrtrain(i,3)';
    
    YTrain{i} = Y;
end
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
     'Plots','none',...
    'Verbose',0);
net = trainNetwork(XTrain,YTrain,layers,options);

%%%%%%%%%%%
Ytrianpred = predict(net,XTrain,'MiniBatchSize',1);
for i = 1:numel(Ytrianpred)
    Ytrianpred1(i) = Ytrianpred{i}(end);
    YTrain1(i) = YTrain{i}(end);
end
N133 = size(XTrain,1);
R2score(al,op) = (N133 .* sum(Ytrianpred1 .* YTrain1) - sum(Ytrianpred1) .* sum(YTrain1)).^2 / ((N133 .* sum((Ytrianpred1).^2) - (sum(Ytrianpred1)).^2) * (N133 .* sum((YTrain1).^2) - (sum(YTrain1)).^2));
%%%%%%%%%%%
% 'Plots','training-progress',...
%% Test the Network %%
[XTest1] = dlmread(fullfile(dataFolder,'5.1版本中西部数据.txt'));
[XTest2] = dlmread(fullfile(dataFolder,'5.1版本超大东北部验证数据.txt'));
[XTest3] = dlmread(fullfile(dataFolder,'5.1版本东北部精度0.5验证数据.txt'));
XTest11=XTest1(:,4:end);XTest21=XTest2(:,4:end);XTest31=XTest3(:,4:end);
% XTest11=XTest11(:,find(ind<okk(al)));XTest1=[XTest1(:,1:3) XTest11];
% XTest21=XTest21(:,find(ind<okk(al)));XTest2=[XTest2(:,1:3) XTest21];
% XTest31=XTest31(:,find(ind<okk(al)));XTest3=[XTest3(:,1:3) XTest31];

XTest11=XTest11(:,ind(1:okk(al)));XTest1=[XTest1(:,1:3) XTest11];
XTest21=XTest21(:,ind(1:okk(al)));XTest2=[XTest2(:,1:3) XTest21];
XTest31=XTest31(:,ind(1:okk(al)));XTest3=[XTest3(:,1:3) XTest31];

[XTest1]=dgsa_corr_praperadata(XTest1);
[XTest2]=dgsa_corr_praperadata(XTest2);
[XTest3]=dgsa_corr_praperadata(XTest3);

for i = 1:numel(XTest1)
    XTest1{i} = (XTest1{i} - mu) ./ (sig);
end
for i = 1:numel(XTest2)
    XTest2{i} = (XTest2{i} - mu) ./ (sig);
end
for i = 1:numel(XTest3)
    XTest3{i} = (XTest3{i} - mu) ./ (sig);
end
% YPred = predict(net,XTrain,'MiniBatchSize',1);
YPred1 = predict(net,XTest1,'MiniBatchSize',1);
YPred2 = predict(net,XTest2,'MiniBatchSize',1);
YPred3 = predict(net,XTest3,'MiniBatchSize',1);
for i = 1:numel(YPred1)
    YPredLast1(i) = YPred1{i}(end);
end
for i = 1:numel(YPred2)
    YPredLast2(i) = YPred2{i}(end);
end
for i = 1:numel(YPred3)
    YPredLast3(i) = YPred3{i}(end);
end

result_zhongxibu(:,al,op)=YPredLast1;
result_chaodongbei(:,al,op)=YPredLast2;
result_dongbei(:,al,op)=YPredLast3;

Testone1=Testone(:,4:end);
% Testone11=Testone1(:,find(ind<okk(al)));Testone1=[Testone(:,1:3) Testone11];
Testone11=Testone1(:,ind(1:okk(al)));Testone1=[Testone(:,1:3) Testone11];

[XTestone,YTestone]=dgsa_corr_praperadata(Testone1);
for i = 1:numel(XTestone)
    XTestone{i} = (XTestone{i} - mu) ./ (sig);
end
YPredone = predict(net,XTestone,'MiniBatchSize',1);
for i = 1:numel(YPredone)
    YTestLast(i) = YTestone{i}(end);
    YPredLast(i) = YPredone{i}(end);
end
rmse(al,op) = sqrt(mean((YPredLast - YTestLast).^2));
histormse(:,al,op)=YPredLast - YTestLast;
resultYPredLast(:,al,op)=YPredLast;
landa=landa+1;
N1 = size(XTestone,1);
R2(al,op) = (N1 .* sum(YPredLast .* YTestLast) - sum(YPredLast) .* sum(YTestLast)).^2 / ((N1 .* sum((YPredLast).^2) - (sum(YPredLast)).^2) * (N1 .* sum((YTestLast).^2) - (sum(YTestLast)).^2));
Rdatapower(al,op)=size(corrtrain,1);
fprintf('努力输出中…特征数据%d   相关系数%d   进度%d\n',okk(al),coornum(op),(100*landa/(length(okk)*length(coornum))))
end
end

R2norm=normalize(R2,'range');
rmsenorm=normalize(1./rmse,'range');
Rdatapowernorm=normalize(Rdatapower,'range');
jingyannorm=normalize(R2norm+rmsenorm+Rdatapowernorm,'range');
jingyannorm=(R2norm+rmsenorm+Rdatapowernorm)/3;

for lo=1:length(result_zhongxibu(:,1,1))
        maxresult_zhongxibu(lo)=max(max(result_zhongxibu(lo,:,:)));
        minresult_zhongxibu(lo)=min(min(result_zhongxibu(lo,:,:)));
end

diffresult_zhongxibu=(maxresult_zhongxibu-minresult_zhongxibu);
dasd=dlmread(fullfile(dataFolder,'5.1版本中西部数据.txt'));
   scatter(dasd(:,1),dasd(:,2),[],diffresult_zhongxibu,'filled');colormap('jet')

okkkk=[dasd(:,1) dasd(:,2) diffresult_zhongxibu'];
   
   
result.rmse=rmse;
result.histormse=histormse;
result.resultYPredLast=resultYPredLast;
result.result_zhongxibu=result_zhongxibu;
result.result_chaodongbei=result_chaodongbei;
result.result_dongbei=result_dongbei;
result.absmeancorr1=absmeancorr1;
result.R2=R2;
result.Rdatapower=Rdatapower;
result.R2score=R2score;
% save new_resultsimple_3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%plot
figure
dasd=dlmread(fullfile(dataFolder,'5.1版本中西部数据.txt'));
for lh1=1:length(okk)
    for lh2=1:length(coornum)  
        scatter3(dasd(:,1),dasd(:,2),result_zhongxibu(:,lh1,lh2),result_zhongxibu(:,lh1,lh2),'filled');colormap('jet')
%   scatter(dasd(:,1),dasd(:,2),[],result_zhongxibu(:,lh1,lh2),'filled');colormap('jet')
        hold on
        drawnow 
%         pause
    end
end
figure
dasd=dlmread(fullfile(dataFolder,'5.1版本超大东北部验证数据.txt'));result_chaodongbei1=result_chaodongbei;
for pl1=1:length(result_chaodongbei(:,8,1))
    if isnan(result_chaodongbei(pl1,8,1))
        result_chaodongbei1(pl1,:,:)=nan;
    end
end    
for lh1=1:length(okk)
    for lh2=1:length(coornum)
        
        scatter(dasd(:,1),dasd(:,2),[],result_chaodongbei1(:,lh1,lh2),'filled');colormap('jet')
        drawnow 
    end
end
figure
dasd=dlmread(fullfile(dataFolder,'5.1版本东北部精度0.5验证数据.txt'));result_dongbei1=result_dongbei;
for pl1=1:length(result_dongbei(:,8,1))
    if isnan(result_dongbei(pl1,8,1))
        result_dongbei1(pl1,:,:)=nan;
    end
end   
for lh1=1:length(okk)
    for lh2=1:length(coornum)
        scatter(dasd(:,1),dasd(:,2),[],result_dongbei1(:,lh1,lh2),'filled');colormap('jet')
        drawnow 
    end
end
figure;
for lh1=1:length(okk)
    for lh2=1:length(coornum)
TestPr = resultYPredLast(:,lh1,lh2) ; 
ResTempTest=YTestLast;

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
ylabel('预测热流值（mW/m^2）');
drawnow
    end
end
scatter(corrtrain(3:end,1),corrtrain(3:end,2),[],corrtrain(3:end,3),'filled');colormap('jet')




