clc
clear all
dataFolder = '全新中西部数据5.0';
result1=load( 'result1complex' );
result2=load( 'result2complex' );
result3=load( 'result3complex' );
result4=load( 'result4complex' );
result5=load( 'result5complex' );


rmseavg=(result2.rmse+result3.rmse+result4.rmse+result5.rmse)/4;
R2avg=(result3.R2+result4.R2+result5.R2)/3;
R2scoreavg=(result5.R2score);
Rdatapoweravg=(result3.Rdatapower+result4.Rdatapower+result5.Rdatapower)/3;

R2norm=mapminmax(R2avg,0,1);
rmsenorm=mapminmax(1./rmseavg,0,1);
Rdatapowernorm=mapminmax(Rdatapoweravg,0,1);
R2scoreavgnorm=mapminmax(R2scoreavg,0,1);
jingyan=(R2norm+rmsenorm+Rdatapowernorm+R2scoreavgnorm)/4;

plot(R2norm(:,2));hold on
plot(rmsenorm(:,2));hold on
plot(Rdatapowernorm(:,2));hold on
plot(R2scoreavgnorm(:,2));hold on
plot(jingyan(2,:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% zhongxibu
dasd=dlmread(fullfile(dataFolder,'5.1版本中西部数据.txt'));
   scatter(dasd(:,1),dasd(:,2),[],result4.result_zhongxibu(:,18,2),'filled');colormap('jet')
% figure
% for lh1=1:19
%     for lh2=1:9
%    scatter(dasd(:,1),dasd(:,2),[],result5.result_zhongxibu(:,lh1,lh2),'filled');colormap('jet')
%    pause()
%     end
% end
   
figure
dasd=dlmread(fullfile(dataFolder,'5.1版本中西部数据.txt'));
for lh1=1:length(result1.result_zhongxibu(1,:,1))
    for lh2=1:length(result1.result_zhongxibu(1,1,:))
        for lh3=1:length(result1.result_zhongxibu(:,1,1))
            if result1.result_zhongxibu(lh3,lh1,lh2)<0
                result1.result_zhongxibu(lh3,lh1,lh2)=nan;
            end         
            if result2.result_zhongxibu(lh3,lh1,lh2)<0
                result2.result_zhongxibu(lh3,lh1,lh2)=nan;
            end
            if result3.result_zhongxibu(lh3,lh1,lh2)<0
                result3.result_zhongxibu(lh3,lh1,lh2)=nan;
            end
            if result4.result_zhongxibu(lh3,lh1,lh2)<0
                result4.result_zhongxibu(lh3,lh1,lh2)=nan;
            end
            if result5.result_zhongxibu(lh3,lh1,lh2)<0
                result5.result_zhongxibu(lh3,lh1,lh2)=nan;
            end
        end
    end
end
          
% for lh1=1:length(result1.result_zhongxibu(1,:,1))
%     for lh2=1:length(result1.result_zhongxibu(1,1,:))  
%         scatter3(dasd(:,1),dasd(:,2),result1.result_zhongxibu(:,lh1,lh2),[],result1.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result2.result_zhongxibu(:,lh1,lh2),result2.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result3.result_zhongxibu(:,lh1,lh2),result3.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result4.result_zhongxibu(:,lh1,lh2),result4.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result5.result_zhongxibu(:,lh1,lh2),result5.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result6.result_zhongxibu(:,lh1,lh2),result6.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result7.result_zhongxibu(:,lh1,lh2),result7.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result8.result_zhongxibu(:,lh1,lh2),result8.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         drawnow 
% %         pause
%     end
% end
pic_num=1;
for lh1=1:length(result1.result_zhongxibu(1,:,1))
    for lh2=1:length(result1.result_zhongxibu(1,1,:))  
        scatter3(dasd(:,1),dasd(:,2),result1.result_zhongxibu(:,lh1,lh2),[],result1.result_zhongxibu(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result2.result_zhongxibu(:,lh1,lh2),[],result2.result_zhongxibu(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result3.result_zhongxibu(:,lh1,lh2),[],result3.result_zhongxibu(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result4.result_zhongxibu(:,lh1,lh2),[],result4.result_zhongxibu(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result5.result_zhongxibu(:,lh1,lh2),[],result5.result_zhongxibu(:,lh1,lh2),'filled');colormap('jet');hold on
      drawnow
        %%%%%%%%%%%%%%%%%%%%
%         F=getframe(gcf);
%     I=frame2im(F);
%     [I,map]=rgb2ind(I,256);
%     if pic_num == 1
%     imwrite(I,map,'test1.gif','gif','Loopcount',inf,'DelayTime',0.2);
%     else
%     imwrite(I,map,'test1.gif','gif','WriteMode','append','DelayTime',0.2);
%     end
%     pic_num = pic_num + 1;
    end
end
for lo=1:length(result1.result_zhongxibu(:,1,1))
        maxresult_zhongxibu(lo)=max(max([ result2.result_zhongxibu(lo,:,:) result3.result_zhongxibu(lo,:,:)...
            result4.result_zhongxibu(lo,:,:) result5.result_zhongxibu(lo,:,:)]));
        minresult_zhongxibu(lo)=min(min([result2.result_zhongxibu(lo,:,:) result3.result_zhongxibu(lo,:,:)...
            result4.result_zhongxibu(lo,:,:) result5.result_zhongxibu(lo,:,:)]));
end
diffresult_zhongxibu=(maxresult_zhongxibu-minresult_zhongxibu);
dasd=dlmread(fullfile(dataFolder,'5.1版本中西部数据.txt'));
   scatter(dasd(:,1),dasd(:,2),[],diffresult_zhongxibu,'filled');colormap('jet')
   ao=[dasd(:,1) dasd(:,2) diffresult_zhongxibu'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% diffresult_zhongxibucomplex=diffresult_zhongxibu;



%% dongbeiquyu
dasd=dlmread(fullfile(dataFolder,'5.1版本东北部精度0.5验证数据.txt'));
dasd1=dlmread(fullfile(dataFolder,'5.1版本长白山内蒙东北部真数据.txt'));

scatter(dasd(:,1),dasd(:,2),[],result8.result_dongbei(:,8,1),'filled');colormap('jet')
hold on
scatter(dasd1(:,1),dasd1(:,2),[],dasd1(:,3),'filled');colormap('jet')



what=(result8.result_dongbei(:,7,2)+result8.result_dongbei(:,8,1))/2;
scatter(dasd(:,1),dasd(:,2),[],what,'filled');colormap('jet')
hold on
scatter(dasd1(:,1),dasd1(:,2),[],dasd1(:,3),'filled');colormap('jet')

figure
dasd=dlmread(fullfile(dataFolder,'5.1版本东北部精度0.5验证数据.txt'));
for lh1=1:length(result1.result_dongbei(1,:,1))
    for lh2=1:length(result1.result_dongbei(1,1,:))
        for lh3=1:length(result1.result_dongbei(:,1,1))
            if result1.result_dongbei(lh3,lh1,lh2)<0
                result1.result_dongbei(lh3,lh1,lh2)=nan;
            end         
            if result2.result_dongbei(lh3,lh1,lh2)<0
                result2.result_dongbei(lh3,lh1,lh2)=nan;
            end
            if result3.result_dongbei(lh3,lh1,lh2)<0
                result3.result_dongbei(lh3,lh1,lh2)=nan;
            end
            if result4.result_dongbei(lh3,lh1,lh2)<0
                result4.result_dongbei(lh3,lh1,lh2)=nan;
            end
            if result5.result_dongbei(lh3,lh1,lh2)<0
                result5.result_dongbei(lh3,lh1,lh2)=nan;
            end
            if result6.result_dongbei(lh3,lh1,lh2)<0
                result6.result_dongbei(lh3,lh1,lh2)=nan;
            end
            if result7.result_dongbei(lh3,lh1,lh2)<0
                result7.result_dongbei(lh3,lh1,lh2)=nan;
            end
            if result8.result_dongbei(lh3,lh1,lh2)<0
                result8.result_dongbei(lh3,lh1,lh2)=nan;
            end
        end
    end
end
          
% for lh1=1:length(result1.result_zhongxibu(1,:,1))
%     for lh2=1:length(result1.result_zhongxibu(1,1,:))  
%         scatter3(dasd(:,1),dasd(:,2),result1.result_zhongxibu(:,lh1,lh2),[],result1.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result2.result_zhongxibu(:,lh1,lh2),result2.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result3.result_zhongxibu(:,lh1,lh2),result3.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result4.result_zhongxibu(:,lh1,lh2),result4.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result5.result_zhongxibu(:,lh1,lh2),result5.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result6.result_zhongxibu(:,lh1,lh2),result6.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result7.result_zhongxibu(:,lh1,lh2),result7.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         scatter3(dasd(:,1),dasd(:,2),result8.result_zhongxibu(:,lh1,lh2),result8.result_zhongxibu(:,lh1,lh2),'filled','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 1]);colormap('jet');hold on
%         drawnow 
% %         pause
%     end
% end
pic_num=1;
for lh1=1:length(result1.result_dongbei(1,:,1))
    for lh2=1:length(result1.result_dongbei(1,1,:))  
        scatter3(dasd(:,1),dasd(:,2),result1.result_dongbei(:,lh1,lh2),[],result1.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result2.result_dongbei(:,lh1,lh2),[],result2.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result3.result_dongbei(:,lh1,lh2),[],result3.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result4.result_dongbei(:,lh1,lh2),[],result4.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result5.result_dongbei(:,lh1,lh2),[],result5.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result6.result_dongbei(:,lh1,lh2),[],result6.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result7.result_dongbei(:,lh1,lh2),[],result7.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        scatter3(dasd(:,1),dasd(:,2),result8.result_dongbei(:,lh1,lh2),[],result8.result_dongbei(:,lh1,lh2),'filled');colormap('jet');hold on
        drawnow 
        %%%%%%%%%%%%%%%%%%%%
%         F=getframe(gcf);
%     I=frame2im(F);
%     [I,map]=rgb2ind(I,256);
%     if pic_num == 1
%     imwrite(I,map,'test1.gif','gif','Loopcount',inf,'DelayTime',0.2);
%     else
%     imwrite(I,map,'test1.gif','gif','WriteMode','append','DelayTime',0.2);
%     end
%     pic_num = pic_num + 1;
    end
end
for lo=1:length(result1.result_dongbei(:,1,1))
        maxresult_zhongxibu(lo)=max(max([result1.result_dongbei(lo,:,:) result2.result_dongbei(lo,:,:) result3.result_dongbei(lo,:,:)...
            result4.result_dongbei(lo,:,:) result5.result_dongbei(lo,:,:) result6.result_dongbei(lo,:,:) result7.result_dongbei(lo,:,:)...
            result8.result_dongbei(lo,:,:)]));
        minresult_zhongxibu(lo)=min(min([result1.result_dongbei(lo,:,:) result2.result_dongbei(lo,:,:) result3.result_dongbei(lo,:,:)...
            result4.result_dongbei(lo,:,:) result5.result_dongbei(lo,:,:) result6.result_dongbei(lo,:,:) result7.result_dongbei(lo,:,:)...
            result8.result_dongbei(lo,:,:)]));
end
diffresult_dobei=(maxresult_zhongxibu-minresult_zhongxibu);
dasd=dlmread(fullfile(dataFolder,'5.1版本东北部精度0.5验证数据.txt'));
   scatter(dasd(:,1),dasd(:,2),[],diffresult_dobei','filled');colormap('jet')
   ao=[dasd(:,1) dasd(:,2) result8.result_dongbei(:,8,1) diffresult_dobei'];   








