%将6hour cruncep BOTB数据换算成每年夏季的平均气温
%输入数据：每年一个.nc文件的 6-8月 cruncep Tair 6hour分辨率数据
%输出数据：2001-2013年夏季 cruncep Tairmax (先取每天4个数据的最大值，之后平均) 6hour分辨率数据的均值，输出一个矩阵

row=180;
col=720;
years=13;

%读入生长季数据，得到植被覆盖区域
GS=load("D:\workplace\productivity temperature\result\growingSeason\globalMonthlyGS.mat");
GS=GS.globalMonthlyGS;
GSCover=sum(GS,3);
GSCover(GSCover==0)=nan;
GSCover=GSCover(1:180,:);

%输入目录
sourcePath='D:\workplace\productivity temperature\result\CRU-NCEP\V8\Tair\Tair_6hour_June-August_2001-2013\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

result_eachYr=nan(row,col,years);
for i_file=1:fileNum
    %读入本文件
    thisFilePath=[sourcePath,files(i_file).name];
    thisFile=load(thisFilePath);
    thisFile=thisFile.result;
    
    thisFile(thisFile==1e+20)=nan;  %去除fill value
    thisFile=thisFile(1:180,:,:);   %北半球
    thisFile=thisFile-273.15;   %换算为℃
    
    %取每天四个数据的最大值
    days=92;    %每年的6-8月都是92天
    thisTairMax=nan(row,col,days);
    
    for i_days=1:4:days*4    %遍历每一天
        TairToday=thisFile(:,:,i_days:i_days+3);
        thisTairMax(:,:,(i_days+3)/4)=max(TairToday,[],3);
    end
    
%     subplot(3,5,i_file);
%     plot(reshape(thisTairMax(90,190,:),1s,92));
    
    thisResult=mean(thisTairMax,3);    %每年夏季的均值
    thisResult(isnan(GSCover))=nan; %去除非植被覆盖区域
    result_eachYr(:,:,i_file)=thisResult;
end

%计算2001-2013年夏季日最高温度的均值
result=mean(result_eachYr,3);

%保存结果
save('D:\workplace\productivity temperature\result\CRU-NCEP\V8\Tair\TairMax_yearMean_June-August\TairMax_yearMean6-8_2001-2013.mat','result');

