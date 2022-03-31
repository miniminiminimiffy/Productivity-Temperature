%将CRU/NCEP V7的数据提取出TBOT(temperature at the lowest atm level)数据，并拼合为1年的
%输入：CRU/NCEP V7 一个文件是一个月，每个文件时间分辨率为 6hour的数据
%输出：CRU/NCEP V7 一个文件是一年，每个文件时间分辨率为 6hour的数据

clear;clc;

sourceHisPath='I:\data\CRU-NCEP\V7\TPQWL\2014\';
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
 saveSourcePath='I:\workplace\最适温度\supplement\CRUNCEP_V7\TBOT_6hour\';
 for i=3:length
     savePath=strcat(saveSourcePath,his(i,1).name);
     savePath=strrep(savePath,'.nc','');
     if i==3
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end
 
 %先读入第一个月的数据
 result=ncread(hisPathes(1,:),'TBOT');
 %将之后读入的数据依次拼接在第一个文件之后
 for i=2:length-2
     nextFile=ncread(hisPathes(i,:),'TBOT');
     result=cat(3,result,nextFile);
 end
 result=ncRejoin(result);
 
 save('I:\workplace\最适温度\supplement\CRUNCEP_V7\TBOT_6hour\cruncepv7_halfdeg_2014','result');
 