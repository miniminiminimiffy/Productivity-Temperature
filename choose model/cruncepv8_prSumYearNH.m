%将6hour cruncep Prec数据换算成每年夏季的总降水量
%输入数据：每年一个.nc文件的 6-8月 cruncep Prec 6hour分辨率数据
%输出数据：2001-2015年夏季 cruncep Prec总降水量，输出一个矩阵
%数据换算：6hour数据的单位是kg m-2 s-1,先换算成 mm/6hour(6小时总降雨量)，之后在6-8月上直接加总
%水的密度10^3kg/m^3,所以1kg=10^-3m3,所以10^-3m^3 m-2 s-1,所以10^-3m s-1,所以mm s-1

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
sourcePath='D:\workplace\productivity temperature\result\afters\chooseModel\CRUNCEP\v8\6hour_2001-2015\Rainf_June-August\';
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
    
    %换算：kg m-2 s-1等于mm s-1后换算为mm/6hour(每6小时降了多少雨)
    thisFile=thisFile*60*60*6;  %换算，每6小时降了多少雨
    thisResult=sum(thisFile,3); %加总，6-8月总共降了多少雨
    
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
save('D:\workplace\productivity temperature\result\afters\chooseModel\CRUNCEP\v8\1yr_2001-2015\Rainf_June-August_sum','result');

