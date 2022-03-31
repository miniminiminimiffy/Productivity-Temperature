%计算每个模型和卫星数据parCorr符号是否一致
%符号一致的像元=1
%符号不一致像元=nan
%同时统计符号不一致像元占总像元数量的比例
clear

row=180;
col=720;

%读入卫星模拟数据
satellite=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\parCorr\parCorr_2001-2014.mat");
satellite=satellite.result;

%输入models模拟数据的目录
sourcePath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6\parCorr_2001-2014\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

saveRootPath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6-Satellite\sign\';

per=nan(9,1);
for i_file=1:fileNum
    %读入本文件
    thisFilePath=[sourcePath,files(i_file).name];
    thisFile=load(thisFilePath);
    thisFile=thisFile.result;
    
    %符号是否一致,如果符号一致，相乘为正
    result=nan(row,col);
    sign=thisFile.*satellite;
    result(sign>0)=1;
    %计算符号一致的栅格占总栅格的比例
    gridAll=numel(thisFile(~isnan(thisFile)));
    gridSign=numel(sign(sign>0));
    thisPer=gridSign/gridAll;
    per(i_file,1)=thisPer;
    
%     figure
%     imagesc(result);
%     colorbar
%     pause(2)
%     close(gcf)
    
    %保存结果
%     thisSavePath=[saveRootPath,files(i_file).name];
%     save(thisSavePath,'result');
end

xlswrite('D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6-Satellite\sign\percent.xlsx',per)


