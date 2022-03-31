%%%使用CRUNCEP的数据，计算非CMIP6模型模拟情况下2001-2013每年*夏季（6-8月）*年平均最高温
%输入：CRUNCEP原始的以6小时为分辨率的数据
%输出：2001-2013每年生长季温度的平均最高值，每天取4个温度中max的温度，再将生长季所有最高温度平均

clear;clc;

sourceHisPath='D:\workplace\productivity temperature\result\CRU-NCEP\V8\Tair\Tair_6hour_June-August_2001-2013\';
his = dir(sourceHisPath);
size0 = size(his);
length = size0(1);%文件夹中文件的数量
for i=3:length
   hisName = strcat(sourceHisPath,his(i,1).name); 
   if i==3
       hisPathes=hisName;
   else
   hisPathes = char(hisPathes,hisName);%垂直拼接字符串，将文件夹下文件夹的名称读取出来
   end
end

%保存结果矩阵的路径和名称
 saveSourcePath='D:\workplace\productivity temperature\result\CRU-NCEP\V8\Tair\TairMax_year_June-August_2001-2013\';
 for i=3:length
     savePath=strcat(saveSourcePath,his(i,1).name);
     savePath=strrep(savePath,'.nc','');
     if i==3
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end
 
 path_growingSeason="D:\workplace\productivity temperature\result\growingSeason\globalMonthlyGS.mat";
 
 %用function
 for i=1:length-2
     fun_CruFundYearSummerNh(hisPathes(i,:),path_growingSeason,savePaths(i,:));
 end
 
 