%计算CMIP6所有模型(2001-2013)tasmax 和(2001-2013)年cruncep Tairmax的差值，作为二者的△
%将△加在CMIP6(2000-2100)年tasmax数据上

%输入：CMIP6模型模拟的2000-2100年tasmax、CRUNCEP2001-2013年真实数据
%输出：CMIP6和经CRU/NCEP校正的2000-2100年tasmax数据
clear;clc;

%定义参数
row=180;
col=720;

%读入CRUNCEP数据
CRUNCEP_mean=load("D:\workplace\productivity temperature\result\CRU-NCEP\V8\Tair\TairMax_yearMean_June-August\TairMax_yearMean6-8_2001-2013.mat");
CRUNCEP_mean=CRUNCEP_mean.result;

%读入模型的数据目录
sourceHisPath='D:\workplace\productivity temperature\result\year_con\tasmax\June-August_NH\ssp585_2000-2100_8\';
his = dir(sourceHisPath);
size0 = size(his);
length1 = size0(1);%文件夹中文件的数量
for i=3:length1
   hisName = strcat(sourceHisPath,his(i,1).name); 
   if i==3
       hisPathes=hisName;
   else
   hisPathes = char(hisPathes,hisName);%垂直拼接字符串，将文件夹下文件夹的名称读取出来
   end
end

%定义保存路径
saveSourcePath='D:\workplace\productivity temperature\result\year_con\tasmax\June-August_NH\diff_CRUv8_2001-2013\ssp585_diff_2000-2100_8\';
 for i=3:length1
     savePath=strcat(saveSourcePath,his(i,1).name);
     if i==3
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end

%读入每一个文件
for i_file=1:length1-2
    %结果矩阵从2000-2100年
    result=nan(row,col,101);
    
    %读入本CMIP6文件，文件是360*720*101的矩阵（2000-2100年）
    thisFile=load(hisPathes(i_file,:));
    thisFile=thisFile.result;
    
    %计算本CMIP6文件2001-2013年的均值
    CMIP6_mean=mean(thisFile(:,:,2:14),3,'omitnan');
    %计算本CRU/NCEP与本CMIP6文件在2001-2013年上的差值
    delta=CRUNCEP_mean-CMIP6_mean;
    
    %为result添加2000-2100年的数据
    for i_year=1:101
        result(:,:,i_year)=thisFile(:,:,i_year)+delta;
    end
    
    %保存结果 
    save(savePaths(i_file,:),'result');
end

