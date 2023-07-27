%% I. 清空环境变量
clear all
clc

%% II. 训练集/测试集产生
%%
% 1. 导入数据
% load spectra_data.mat
dataFolder = '测试神经网络隐藏层模型';

%% Training Data Preparation %%
filenamePredictors = fullfile(dataFolder,'全球训练3500点.txt');
filenamePredictors1 = fullfile(dataFolder,'全球验证500点.txt');
% dataFolder = '全新中西部数据3.0版本';
% 
% % Training Data Preparation %%
% filenamePredictors = fullfile(dataFolder,'3.0版本全球训练数据加中西部.txt');
% filenamePredictors1 = fullfile(dataFolder,'3.0版本真中西部数据.txt');
%% Training Data Preparation %%

P = dlmread(filenamePredictors);
T = dlmread(filenamePredictors1 );
%%
% 2. 随机产生训练集和测试集
P_train=P(:,4:end);
T_train=P(:,3);
P_test=T(:,4:end);
T_test=T(:,3);


% P_train1=P(:,4:end);
% T_train1=P(:,3);
% temp = randperm(size(P_train1,1))';
% % % % 训练集——50个样本
% P_train = P_train1(temp(1:3500),:);
% T_train = T_train1(temp(1:3500),:);
% % % % 测试集——10个样本
% P_test = P_train1(temp(3501:end),:);
% T_test = T_train1(temp(3501:end),:);



N = size(P_test,1);
%% III. 数据归一化
% for i=1:length
% [p_train, ps_input] = mapminmax(P_train,0,1);
% p_test = mapminmax('apply',P_test,ps_input);
% 
% [t_train, ps_output] = mapminmax(T_train,0,1);

% m = min([P_train],[],1);
% M = max([P_train],[],1);
% idxConstant = M == m;
% 
% for i = 1:numel(P_train(:,1))
%     P_train(idxConstant,:) = [];
% end


% % mu = mean(P_train,1);
% % sig = std(P_train,0,1);
% % 
% % for i = 1:numel(P_train(:,1))
% %     P_train(i,:) = (P_train(i,:) - mu) ./ (sig);
% % end
% % 
% % for i = 1:numel(P_test(:,1))
% %     P_test(i,:) = (P_test(i,:) - mu) ./ (sig);
% % end



p_train=P_train;
t_train=T_train;

%% IV. BP神经网络创建、训练及仿真测试
%%
% 1. 创建网络
for i=37:43
net = newff(p_train',t_train',[i i i i i], {'tansig','purelin'}, 'trainbfg');
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
% 2. 设置训练参数


%%
% 4. 仿真测试
T_sim = sim(net,P_test');

%%
% 5. 数据反归一化
% T_sim = mapminmax('reverse',t_sim,ps_output);

%% V. 性能评价
%%
% 1. 相对误差error
error = abs(T_sim - T_test)./T_test;

%%
% 2. 决定系数R^2
R2 = (N .* sum(T_sim .* T_test) - sum(T_sim) .* sum(T_test)).^2 / ((N .* sum((T_sim).^2) - (sum(T_sim)).^2) * (N .* sum((T_test).^2) - (sum(T_test)).^2));

%%
% 3. 结果对比
% result = [T_test' T_sim ]

%% VI. 绘图
figure
plot(1:N,T_test,'b:*',1:N,T_sim','r-o')
legend('真实值','预测值')
% 
figure
rmse = sqrt(mean((T_test' - T_sim).^2));
histogram(T_test' - T_sim)
title("RMSE = " + rmse)
ylabel("Frequency")
xlabel("Error")


TestPr = T_test' ; 
ResTempTest=T_sim;
figure;
% subplot(5,10,i)
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
% xlabel('True Response');
set(axes1,'XLim',[0 150])
set(axes1,'YLim',[0 150])
end
