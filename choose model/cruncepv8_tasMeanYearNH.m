%将6hour cruncep BOTB数据换算成每年夏季的平均气温
%输入数据：每年一个.nc文件的 6-8月 cruncep Tair 6hour分辨率数据
%输出数据：2001-2015年夏季 cruncep Tair 6hour分辨率数据的均值，输出一个矩阵

row=180;
col=720;
years=15;

%读入生长季数据，得到植被覆盖区域
GS=load("D:\workplace\productivity temperature\result\growingSeason\globalMonthlyGS.mat");
GS=GS.globalMonthlyGS;
GSCover=sum(GS,3);
GSCover(GSCover==0)=nan;
GSCover=GSCover(1:180,:);

%输入目录
sourcePath='D:\workplace\productivity temperature\result\afters\chooseModel\CRUNCEP\v8\6hour_2001-2015\Tair_June-August\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

result=nan(row,col,years);
for i_file=1:fileNum
    %读入本文件
    thisFilePath=[sourcePath,files(i_file).name];
    thisFile=load(thisFilePath);
    thisFile=thisFile.result;
    
    thisFile(thisFile==1e+20)=nan;  %去除fill value
    thisFile=thisFile(1:180,:,:);   %北半球
    thisFile=thisFile-273.15;   %换算为℃
    
    thisResult=mean(thisFile,3);    %每年夏季的均值
    thisResult(isnan(GSCover))=nan; %去除非植被覆盖区域
    result(:,:,i_file)=thisResult;
end

%检验结果
figure
for i=1:15
    subplot(3,5,i)
    imagesc(result(:,:,i));
    colorbar;
end

%保存结果
save('D:\workplace\productivity temperature\result\afters\chooseModel\CRUNCEP\v8\1yr_2001-2015\Tair_June-August_mean','result');

