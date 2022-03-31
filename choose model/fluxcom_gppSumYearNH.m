%将1mon FLUXCOM GPP数据换算成每年夏季的总和
%输入数据：每年一个.nc文件的 FLUXCOM GPP 1mon分辨率数据
%输出数据：2001-2015年夏季 FLUXCOM GPP数据
%数据换算：1mon 数据的单位是gC m-2 day-1,1yr 数据的单位是gC m-2 summer-1

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
sourcePath='D:\data\模型GPP\FLUXCOM\RS\05deg\monthly\ensemble\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

result=nan(row,col,years);
days=[30,31,31];   %6,7,8月的天数
days1=repmat(days,[180 1 1]);
days2=repmat(days1,[1 1 720]);
days2=permute(days2,[1 3 2]);

for i_file=1:fileNum
    %读入本文件
    thisFilePath=[sourcePath,files(i_file).name];
    thisFile=ncread(thisFilePath,'GPP');
    
    %转换为合适的坐标
    thisFile=permute(thisFile,[2 1 3]); 
    thisFile(thisFile<0)=nan;  %去除fill value
    thisFile=thisFile(1:180,:,:);   %北半球
    
    %换算，将gC m-2 day-1加总为gC m-2 summer-1
    thisFile_summer=thisFile(:,:,6:8).*days2;
    thisResult=sum(thisFile_summer,3); %加总
    
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
save("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\FLUXCOM GPP\GPP_June-August_2001-2015.mat",'result');

