clc
clear all


dataTrain = xlsread('globelheatpara.xlsx');
dataTrain2 = xlsread('globleheatres.xlsx');
% datazhen = dlmread('qqzhen.txt');
% test = xlsread('ai.xlsx');

% dataTrain(:,14)=[];dataTrain(:,11)=[];dataTrain(:,8)=[];dataTrain(:,5)=[];dataTrain(:,2)=[];
% dataTrain(:,19)=[];dataTrain(:,18)=[];dataTrain(:,13)=[];dataTrain(:,12)=[];dataTrain(:,4)=[];
dataTrain=[dataTrain2 dataTrain];


[COEFF,SCORE,hhh]= pca(dataTrain);
% [COEFF1,SCORE]= pca(datazhen);
% [test1,SCORE]= pca(test);
ssss=sum(hhh);
d1=hhh(1)/ssss;
d2=hhh(2)/ssss;
d3=hhh(3)/ssss;
d=d1+d2+d3;
gg1=dataTrain*COEFF(:,1);
gg2=dataTrain*COEFF(:,2);
gg3=dataTrain*COEFF(:,3);
% hh1=datazhen*COEFF1(:,1);
% hh2=datazhen*COEFF1(:,2);
% hh3=datazhen*COEFF1(:,3);
% % tt1=test*test1(:,3);
% % tt2=test*test2(:,3);
% % tt3=test*test3(:,3);

figure
scatter3(gg1,gg2,gg3,'fill')
figure
scatter(gg1,gg2,'fill')
% hold on 
% scatter3(hh1,hh2,hh3,'fill')
% hold on 
% scatter3(tt1,tt2,tt3,'fill')


dataTrain1=dataTrain(:,3:end);
datazhen1=datazhen(:,3:end);

[COEFF2,SCORE]= pca(dataTrain1);
[COEFF21,SCORE]= pca(datazhen1);

ggg1=dataTrain1*COEFF2(:,1);
ggg2=dataTrain1*COEFF2(:,2);
ggg3=dataTrain1*COEFF2(:,3);
hhh1=datazhen1*COEFF21(:,1);
hhh2=datazhen1*COEFF21(:,2);
hhh3=datazhen1*COEFF21(:,3);
figure
scatter3(ggg1,ggg2,ggg3,'fill')
hold on 
scatter3(hhh1,hhh2,hhh3,'fill')



