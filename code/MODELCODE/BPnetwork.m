%% I. ��ջ�������
clear all
clc

%% II. ѵ����/���Լ�����
%%
% 1. ��������
% load spectra_data.mat
dataFolder = '�������������ز�ģ��';

%% Training Data Preparation %%
filenamePredictors = fullfile(dataFolder,'ȫ��ѵ��3500��.txt');
filenamePredictors1 = fullfile(dataFolder,'ȫ����֤500��.txt');
% dataFolder = 'ȫ������������3.0�汾';
% 
% % Training Data Preparation %%
% filenamePredictors = fullfile(dataFolder,'3.0�汾ȫ��ѵ�����ݼ�������.txt');
% filenamePredictors1 = fullfile(dataFolder,'3.0�汾������������.txt');
%% Training Data Preparation %%

P = dlmread(filenamePredictors);
T = dlmread(filenamePredictors1 );
%%
% 2. �������ѵ�����Ͳ��Լ�
P_train=P(:,4:end);
T_train=P(:,3);
P_test=T(:,4:end);
T_test=T(:,3);


% P_train1=P(:,4:end);
% T_train1=P(:,3);
% temp = randperm(size(P_train1,1))';
% % % % ѵ��������50������
% P_train = P_train1(temp(1:3500),:);
% T_train = T_train1(temp(1:3500),:);
% % % % ���Լ�����10������
% P_test = P_train1(temp(3501:end),:);
% T_test = T_train1(temp(3501:end),:);



N = size(P_test,1);
%% III. ���ݹ�һ��
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

%% IV. BP�����紴����ѵ�����������
%%
% 1. ��������
for i=37:43
net = newff(p_train',t_train',[i i i i i], {'tansig','purelin'}, 'trainbfg');
net.trainParam.epochs = 2000;
net.trainParam.max_fail=10;  

net = init(net);
net.trainParam.goal=0.0001;             %������Ӧ�Ĳ���
net.trainParam.show=25;
net.trainParam.mc=0.9;
net.trainParam.lr=0.05;
% validation checks
%%
% 3. ѵ������

net = train(net,p_train',t_train');

%%
% 2. ����ѵ������


%%
% 4. �������
T_sim = sim(net,P_test');

%%
% 5. ���ݷ���һ��
% T_sim = mapminmax('reverse',t_sim,ps_output);

%% V. ��������
%%
% 1. ������error
error = abs(T_sim - T_test)./T_test;

%%
% 2. ����ϵ��R^2
R2 = (N .* sum(T_sim .* T_test) - sum(T_sim) .* sum(T_test)).^2 / ((N .* sum((T_sim).^2) - (sum(T_sim)).^2) * (N .* sum((T_test).^2) - (sum(T_test)).^2));

%%
% 3. ����Ա�
% result = [T_test' T_sim ]

%% VI. ��ͼ
figure
plot(1:N,T_test,'b:*',1:N,T_sim','r-o')
legend('��ʵֵ','Ԥ��ֵ')
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
