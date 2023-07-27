
clc
clear all

ss=load('dgsa_measuresxin6.txt')
% ss1=load('dgsa_measures2.txt')
% ss1=ss(1:21,1);
ss=ss/2;
h=bar(ss);
figure
for i=1:length(ss)
    h = bar(i,ss(i));
    cdata = get(h,'YData'); %获取Bar的高度
    cdata_new = [cdata/6 0.1 1-cdata/6];% [r g b] %归一化
    set(h,'FaceColor',cdata_new,'BarWidth',1,'EdgeColor','k') % FaceColor控制Bar的颜色
    hold on
end



% h.FaceColor = 'flat';
% for in=1:length(ss)
%     if h.YData(in)>10%分组条件
%         h.CData(in,:)=[.5 0 .5];%各组颜色
%     end
% end

[ssA,ind]=sort(ss,'descend');

indd=[];n=1;
for lpo=1:length(ssA)
    for lpp=1:length(ssA)
    if ss(lpp)== ssA(lpo)
        indd(n)=lpp;
        n=n+1;
    end
    end
end
indd=indd';


figure
% barh(ssA);

for i=1:length(ssA)
    h = barh(i,ssA(i),'Linewidth',1);
    cdata = get(h,'YData'); %获取Bar的高度
    cdata_new = [cdata/6 0.1 1-cdata/6];% [r g b] %归一化
    set(h,'FaceColor',cdata_new,'BarWidth',1,'EdgeColor','k') % FaceColor控制Bar的颜色
    hold on
end
a01='经度';
a02='纬度';
a1='全球地形';
a2='莫霍面深度';
a3='LAB界面';
a4='大陆岩石圈年龄';
a5='重力异常';
a6='地壳厚度';
a7='上地幔密度异常';
a8='磁异常';
a9='上地壳厚度';
a10='下地壳厚度';
a11='生热率';
a12='上一次热构造事件的年龄';
a13='上地幔速度结构';
a14='岩石类型';
a15='洋脊距离';
a16='山岭距离';
a17='裂谷距离';
a18='火山距离';
a19='山脊距离';
a20='温泉距离';
a21='岩石圈厚度';
a22='岩石圈厚度梯度';
a23='沉积物厚度';
a24='随机样本';
colormap(jet())
% a1='Global surface topography';
% a2='Depth to Moho';
% a3='Lithosphere-asthenosphere boundary';
% a4='Age';
% a5='Bougeur gravity anomaly';
% a6='Crustal thickness';
% a7='Upper mantle density anomaly';
% a8='Magnetic anomaly';
% a9='Thickness of upper crust';
% a10='Thickness of lower crust';
% a11='Heat production provinces';
% a12='Age of last thermotectonic event';
% a13='Upper Mantle velocity structure';
% a14='Rock type';
% a15='Distance to trench';
% a16='Distance to transform ridge';
% a17='Distance to young rift';
% a18='Distance to volcano';
% a19='Distance to ridge';
% a20='Distance to hot spot';a21='rand';




ak={a01 a02 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20,a21 a22 a23 a24 };
ak=ak(ind);

set(gca,'YTick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26],...
    'YTickLabel',...
    ak,...
    'YTickLabelRotation',0);
xlabel('灵敏度响应值');
view([0 -90]);

% figure
% bar(ss1);
% % 
% % [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]
% % [8;14;5;2;11;1;9;10;17;6;15;16;20;7;3;19;12;4;18;13]