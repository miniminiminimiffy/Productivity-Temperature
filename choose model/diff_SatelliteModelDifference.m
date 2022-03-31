%计算每个模型和卫星数据GPP和相关系数的差异

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

saveRootPath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6-Satellite\parCorr\';

for i_file=1:fileNum
    %读入本文件
    thisFilePath=[sourcePath,files(i_file).name];
    thisFile=load(thisFilePath);
    thisFile=thisFile.result;
    
    %差值
    result=thisFile-satellite;
    
    figure
    imagesc(result);
    colorbar
    pause(2)
    close(gcf)
    
    %保存结果
    thisSavePath=[saveRootPath,files(i_file).name];
    save(thisSavePath,'result');
end


