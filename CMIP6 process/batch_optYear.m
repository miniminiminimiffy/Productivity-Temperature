%功能：得到全球每个格网最适温度到达的年份
%输入：year_con中每个模型或者模型平均的360*720*100（2001-2100年）的温度数据
%输出：何时达到最适温度的矩阵（360*720*1）

clear;clc;

sourceHisPath='D:\workplace\productivity temperature\result\year_con\tasmax\June-August_NH\diff_CRUv8_2001-2013\ssp585_diff_2000-2100_8\';
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

%保存最适温度达到时间的路径
 saveSourcePath='D:\workplace\productivity temperature\result\opt_year\June-August_NH\diff_CRU_2001-2013\ssp585_8\';
 for i=3:length
     savePath=strcat(saveSourcePath,his(i,1).name);
     if i==3
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end
 
path_tasOpt="D:\workplace\productivity temperature\result\tas_opt\Topt_modis_NIRv_pattern_filterMean_mask.mat";

 %用function
 for i=1:length-2
     fun_optYear(hisPathes(i,:),path_tasOpt,savePaths(i,:));
 end
 
 