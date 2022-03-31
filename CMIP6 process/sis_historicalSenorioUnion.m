%将historical（1850-2014）和senorio（2015-2100）的数据合并为一个文件，仅取2000-2100年的数据

clear; clc;

%historical的文件路径
sourceHisPath='E:\workplace\productivity temperature\result\year_con\rsds\gpp-tas-pr-rsds\spring_NH\historical_1850-2014\';
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

%senorio的文件路径
SourceSspPath='E:\workplace\productivity temperature\result\year_con\rsds\gpp-tas-pr-rsds\spring_NH\ssp245_2015-2100\';
 for i=3:length
     sspPath=strcat(SourceSspPath,his(i,1).name);
     if i==3
     sspPaths=sspPath;
     else
     sspPaths=char(sspPaths,sspPath);
     end
 end

 %保存文件的路径
 saveSourcePath='E:\workplace\productivity temperature\result\year_con\rsds\gpp-tas-pr-rsds\spring_NH\ssp245_2000-2100\';
 for i=3:length
     savePath=strcat(saveSourcePath,his(i,1).name);
     if i==3
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end
 
 %遍历所有模型，拼合两个文件
 for i=1:length-2
     historical=load(hisPathes(i,:));
     ssp=load(sspPaths(i,:));
     historical=historical.result;
     ssp=ssp.result;
     
     result=cat(3,historical(:,:,151:165),ssp);
     save(savePaths(i,:),'result');
 end
 
 figure;
 imagesc(result(:,:,101));
 colorbar;
 figure;
 plot(reshape(result(47,655,:),1,101));