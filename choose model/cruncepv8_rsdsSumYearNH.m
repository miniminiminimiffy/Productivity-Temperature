%将6hour cruncep SWdown数据换算成每年夏季的太阳辐射
%输入数据：每年一个.nc文件的 6-8月 cruncep SWdown 6hour分辨率数据
%输出数据：2001-2015年夏季 cruncep SWdown
%数据换算：6hour 数据的单位是J/m2，但是这个单位不太对，李师姐说应该已经换算成了w/m2

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
sourcePath='D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\CRUNCEP\v8\6hour_2001-2015\SWdown_June-August\';
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
    
    %6,7，8月分别平均，保持原始单位w/m2
    mon678=nan(row,col,3);
    mon678(:,:,1)=mean(thisFile(:,:,1:30*4),3);
    mon678(:,:,2)=mean(thisFile(:,:,30*4+1:61*4),3);
    mon678(:,:,3)=mean(thisFile(:,:,61*4+1:92*4),3);
    %三个月加总
    thisResult=sum(mon678,3); %加总，6-8月的总辐射量
    
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
save('D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\CRUNCEP\v8\1yr_2001-2015\SWdown_June-August_sum.mat','result');

