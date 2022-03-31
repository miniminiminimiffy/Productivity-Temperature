%绘制偏相关系数的概率分布图

clear;

row=180;
col=720;

%基于观测数据的偏相关系数
observe=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\parCorr\parCorr_2001-2014.mat");
observe=observe.result;
observe_re=reshape(observe,1,row*col);

    
%去除nan
observe_re(isnan(observe_re))=[];

figure
%绘制概率分布函数
ho=histogram(observe_re);
ho.Normalization='probability';
ho.BinWidth=0.1;

myColor=brewermap(10,'Paired');
ho.FaceColor = myColor(3,:);

%设置图形参数
box on;
axis([-1,1,0,0.1]);

set(gca,'XTick',-1:1:1);
set(gca,'XTickLabel',-1:1:1);
set(gca,'YTick',0:0.05:0.1);
set(gca,'YTickLabel',0:0.05:0.1);

%     xlabel('R_G_P_P_-_T_A_S');
%     ylabel('Probability');
%     
%     legend('Observation','Model','location','northoutside')
%     legend('boxoff')

set(gca,'FontSize',10)

set(gcf, 'position', [100,100,160,130]);

%保存结果
thisSavePath='D:\workplace\productivity temperature\result\pictures\pictures9\sfig1_modelsParCorr2001-2014\model_densityDistribution\observe';  
saveas(gcf,thisSavePath,'png')   %栅  
saveas(gcf,thisSavePath,'svg')   %矢


