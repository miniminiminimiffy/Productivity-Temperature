%计算一个文件夹中所有三维矩阵的均值，适用于是x*y*z的三维矩阵

clear;

%空间分辨率
row = 180;
col = 720;
years = 82;

%保存结果路径
saveRootPath = "D:\workplace\productivity temperature\result\ne_year\gpp-tas-pr-rsds\June-August_NH\gpp-tas\modelMean\withouBCC\justWithoutBCC\ssp585\pval_2019-2100.mat";

%顺序读入待平均文件
rootPath='D:\workplace\productivity temperature\result\ne_year\gpp-tas-pr-rsds\June-August_NH\gpp-tas\ssp585_2019-2100\pval\withoutBCC\';
files = dir(rootPath);
files(1:2,:) = [];
fileNum = size(files,1);

%预定义结果矩阵
result = nan(row,col,years);

for i_file = 1:fileNum
    %读入本文件
    thisFilePath = [rootPath,files(i_file).name];
    mat = load(thisFilePath);
    mat = mat.result_pval;
    
    if(i_file == 1)
        result = mat;
    else
        matCat = cat(4,result*((i_file-1)/i_file),mat*(1/i_file));
        result = sum(matCat,4,'omitnan');
    end
end

%将无数据区域赋值为nan
result(result==0) = nan;

%保存结果
save(saveRootPath,'result');
