%计算observation和modles矩阵空间分布序列的R和RMSE

clear

%定义空间分辨率
row=180;
col=720;

%输入models目录
% sourceModelsPath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6\parCorr_2001-2014\';
sourceModelsPath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6\gpp_2001-2014_mean\';
files=dir(sourceModelsPath);
files(1:2,:)=[];
fileNum=size(files,1);

%读入satellite
% satellite=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\parCorr\parCorr_2001-2014.mat");
satellite=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\FLUXCOM GPP\GPP_June-August_mean_2001-2014.mat");
satellite=satellite.result;

% saveRootPath='D:\workplace\productivity temperature\result\afters\chooseModel\pictures\scatter\parCorr\';
% saveRootPath='D:\workplace\productivity temperature\result\afters\chooseModel\pictures\scatter\parCorr\';

accu=nan(9,3);
for i_file=1:fileNum
    %读入数据
    thisModelPath=[sourceModelsPath,files(i_file).name];
    thismodel=load(thisModelPath);
    thismodel=thismodel.result;
    
    %去除nan
    thismodel_re=reshape(thismodel,1,row*col);
    satellite_re=reshape(satellite,1,row*col);
    thismodel_sc=thismodel_re;
    satellite_sc=satellite_re;
    thismodel_sc(isnan(thismodel_re) | isnan(satellite_re))=[];
    satellite_sc(isnan(thismodel_re) | isnan(satellite_re))=[];
    
    %计算相关系数
    [corr,pval]=corrcoef(thismodel_sc',satellite_sc');
    accu(i_file,1)=corr(1,2);
    accu(i_file,2)=pval(1,2);
    %计算RMSE
    rmse=sqrt(sum((thismodel_sc'-satellite_sc').^2)/numel(thismodel_sc'));
    accu(i_file,3)=rmse;
    
%     %scatter
%     scatter(thismodel_sc,satellite_sc,1);
%     %1:1 line
%     hold on
%     x=-1:1:1200;
%     y=x;
%     plot(x,y,'r','LineWidth',0.8);
%     
%     %图形调整
%     box on;
%     axis([0,1200,0,1200]);
%     axis([-1,1,-1,1]);
%     
%     xlabel('Model GPP (gC m^-^2 summer^-^1)');
%     ylabel('FLUXCOM GPP (gC m^-^2 summer^-^1)');
%     xlabel('Model  R_G_P_P_T_A_S');
%     ylabel('FLUXCOM  R_G_P_P_T_A_S');
% 
%     
%     set(gcf, 'position', [100,100,350,300]);
% 
%     %保存图像
%     thisSavePath=[saveRootPath,strrep(files(i_file).name,'.mat','.png')];
%     saveas(gcf,thisSavePath);
%     
%     close(gcf)
end

xlswrite('D:\workplace\productivity temperature\result\afters\chooseModel\pictures\scatter\gpp\corrPval.xlsx',accu)

