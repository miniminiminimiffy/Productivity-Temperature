%gpp-tas-pr-rsds，计算gpp和tas的偏相关系数，偏最小二乘系数
%输入：每个模型从2000-2100年的gpp tas pr rsds
%输出：gpp和tas的偏相关系数矩阵，20年的滑动平均，2019-2100年的partialCorr矩阵和pval矩阵

clear

%读入gpp数据
sourceGppPath='E:\workplace\productivity temperature\result\year_con\gpp\gpp-tas-pr-rsds\spring_NH\ssp245_2000-2100\';
his = dir(sourceGppPath);
size0 = size(his);
length = size0(1);%文件夹中文件的数量
for i=3:length
   gppName = strcat(sourceGppPath,his(i,1).name); 
   if i==3
       gppPathes=gppName;
   else
   gppPathes = char(gppPathes,gppName);%垂直拼接字符串，将文件夹下文件夹的名称读取出来
   end
end

%读入tas数据
sourceTasPath='E:\workplace\productivity temperature\result\year_con\tas\gpp-tas-pr-rsds\spring_NH\ssp245_2000-2100\';
 for i=3:length
     tasPath=strcat(sourceTasPath,his(i,1).name);
     if i==3
     tasPaths=tasPath;
     else
     tasPaths=char(tasPaths,tasPath);
     end
 end
 
%读入pr数据
sourcePrPath='E:\workplace\productivity temperature\result\year_con\pr\gpp-tas-pr-rsds\spring_NH\ssp245_2000-2100\';
 for i=3:length
     prPath=strcat(sourcePrPath,his(i,1).name);
     if i==3
     prPaths=prPath;
     else
     prPaths=char(prPaths,prPath);
     end
 end

%读入rsds数据
sourceRsdsPath='E:\workplace\productivity temperature\result\year_con\rsds\gpp-tas-pr-rsds\spring_NH\ssp245_2000-2100\';
 for i=3:length
     rsdsPath=strcat(sourceRsdsPath,his(i,1).name);
     if i==3
     rsdsPaths=rsdsPath;
     else
     rsdsPaths=char(rsdsPaths,rsdsPath);
     end
 end

 %保存偏相关系数的路径
  saveSourceCorrPath='E:\workplace\productivity temperature\result\ne_year\gpp-tas-pr-rsds\spring_NH\gpp-tas\ssp245_2019-2100\parCorr\9model\';
 for i=3:length
     saveCorrPath=strcat(saveSourceCorrPath,his(i,1).name);
     if i==3
     saveCorrPaths=saveCorrPath;
     else
     saveCorrPaths=char(saveCorrPaths,saveCorrPath);
     end
 end
 
%保存p值的路径
 savePCorrPath='E:\workplace\productivity temperature\result\ne_year\gpp-tas-pr-rsds\spring_NH\gpp-tas\ssp245_2019-2100\pval\9model\';
 for i=3:length
     savePPath=strcat(savePCorrPath,his(i,1).name);
     if i==3
     savePPaths=savePPath;
     else
     savePPaths=char(savePPaths,savePPath);
     end
 end
 
 %保存sensitivity的路径
 saveSenRootPath='E:\workplace\productivity temperature\result\sensitivity\spring_NH\gpp-tas\ssp245_2019-2100\9model\';
 for i=3:length
     saveSenPath=strcat(saveSenRootPath,his(i,1).name);
     if i==3
     saveSenPaths=saveSenPath;
     else
     saveSenPaths=char(saveSenPaths,saveSenPath);
     end
 end

 %遍历每个模型计算偏相关系数与首次达到负相关的年份
 for i=9:9
     fun_gppTasPartialCorr3(gppPathes(i,:),tasPaths(i,:),prPaths(i,:),rsdsPaths(i,:),saveCorrPaths(i,:),savePPaths(i,:),saveSenPaths(i,:));
 end
