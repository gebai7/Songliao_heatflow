
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
    cdata = get(h,'YData'); %��ȡBar�ĸ߶�
    cdata_new = [cdata/6 0.1 1-cdata/6];% [r g b] %��һ��
    set(h,'FaceColor',cdata_new,'BarWidth',1,'EdgeColor','k') % FaceColor����Bar����ɫ
    hold on
end



% h.FaceColor = 'flat';
% for in=1:length(ss)
%     if h.YData(in)>10%��������
%         h.CData(in,:)=[.5 0 .5];%������ɫ
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
    cdata = get(h,'YData'); %��ȡBar�ĸ߶�
    cdata_new = [cdata/6 0.1 1-cdata/6];% [r g b] %��һ��
    set(h,'FaceColor',cdata_new,'BarWidth',1,'EdgeColor','k') % FaceColor����Bar����ɫ
    hold on
end
a01='����';
a02='γ��';
a1='ȫ�����';
a2='Ī�������';
a3='LAB����';
a4='��½��ʯȦ����';
a5='�����쳣';
a6='�ؿǺ��';
a7='�ϵ���ܶ��쳣';
a8='���쳣';
a9='�ϵؿǺ��';
a10='�µؿǺ��';
a11='������';
a12='��һ���ȹ����¼�������';
a13='�ϵ���ٶȽṹ';
a14='��ʯ����';
a15='�󼹾���';
a16='ɽ�����';
a17='�ѹȾ���';
a18='��ɽ����';
a19='ɽ������';
a20='��Ȫ����';
a21='��ʯȦ���';
a22='��ʯȦ����ݶ�';
a23='��������';
a24='�������';
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
xlabel('��������Ӧֵ');
view([0 -90]);

% figure
% bar(ss1);
% % 
% % [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]
% % [8;14;5;2;11;1;9;10;17;6;15;16;20;7;3;19;12;4;18;13]