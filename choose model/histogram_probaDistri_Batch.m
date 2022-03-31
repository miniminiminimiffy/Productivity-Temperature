%绘制偏相关系数的概率分布图

clear;

row=180;
col=720;

%模型计算所得偏相关系数
sourcePath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6\parCorr_2001-2014\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

%基于观测数据的偏相关系数
observe=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\parCorr\parCorr_2001-2014.mat");
observe=observe.result;
observe_re=reshape(observe,1,row*col);

%保存图像的路径
saveRootPath='D:\workplace\productivity temperature\result\pictures\pictures9\sfig1_modelsParCorr2001-2014\model_densityDistribution\';

%读入每个文件
for i_file=1:fileNum
    %取得每个文件夹下的数据矩阵
    thisModelPath=[sourcePath,files(i_file).name];
    thisModel=load(thisModelPath);
    thisModel=thisModel.result;
    
    thisModel_re=reshape(thisModel,1,row*col);
    
    %去除nan
    observe_re(isnan(observe_re))=[];
    thisModel_re(isnan(thisModel_re))=[];
    
    figure
    %绘制概率分布函数
    ho=histogram(observe_re);
    hold on
    hm=histogram(thisModel_re);
    
    ho.Normalization='probability';
    ho.BinWidth=0.1;
    hm.Normalization='probability';
    hm.BinWidth=0.1;
    
    myColor=brewermap(10,'Paired');
    ho.FaceColor = myColor(3,:);
    hm.FaceColor = myColor(5,:);
    
    %根据数据调整图形y轴
    if(i_file==1 || i_file==2 || i_file==4 || i_file==7 || i_file==8 || i_file==9)
        yUp=0.1;
        yTick=0:0.05:yUp;
    elseif(i_file==3)
        yUp=0.13;
        yTick=0:0.05:yUp;
    else
        yUp=0.24;
        yTick=0:0.1:yUp;
    end
    
    %设置图形参数
    box on;
    axis([-1,1,0,yUp]);

    set(gca,'XTick',-1:1:1);
    set(gca,'XTickLabel',-1:1:1);
    set(gca,'YTick',yTick);
    set(gca,'YTickLabel',yTick);

%     xlabel('R_G_P_P_-_T_A_S');
%     ylabel('Probability');
%     
%     legend('Observation','Model','location','northoutside')
%     legend('boxoff')
    
    set(gca,'FontSize',10)
    
    set(gcf, 'position', [100,100,160,130]);

    %保存结果
    thisSavePath1=[saveRootPath,strrep(files(i_file).name,'.mat','.png')];  %栅
    saveas(gcf,thisSavePath1)
    thisSavePath2=[saveRootPath,strrep(files(i_file).name,'.mat','.svg')];  %矢
    saveas(gcf,thisSavePath2)
    
    close(gcf)
end

