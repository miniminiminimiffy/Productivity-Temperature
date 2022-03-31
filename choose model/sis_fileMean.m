%计算平均GPP

%%
%计算2001-2014年FLUXNET平均GPP
data=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\FLUXCOM GPP\GPP_June-August_2001-2015.mat");
data=data.result;
data=data(:,:,1:14);
result=mean(data,3);

figure;
imagesc(result,[0 800])
colorbar

save('D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\FLUXCOM GPP\GPP_June-August_mean_2001-2014.mat','result');

%%
%计算每个模型2001-2014年平均GPP

%输入目录
sourcePath='D:\workplace\productivity temperature\result\year_con\gpp\gpp-tas-pr-rsds\June-August_NH\ssp585_2000-2100\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

savePath='D:\workplace\productivity temperature\result\afters\chooseModel\CMIP6\gpp_2001-2014_mean\';

figure
for i_file=1:fileNum
    %读入本文件
    thisFilePath=[sourcePath,files(i_file).name];
    thisFile=load(thisFilePath);
    thisFile=thisFile.result;
    
    %2001-2014年均值
    result=mean(thisFile(:,:,2:15),3,'omitnan');
    
    %保存结果
    thisSavePath=[savePath,files(i_file).name];
    save(thisSavePath,'result');
    
    %检验结果
    subplot(3,3,i_file)
    imagesc(result,[0 800])
    title(files(i_file).name)
end
