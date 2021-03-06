%%%将每月的rsds数据处理为每年（没有考虑生长季）的平均值。
%输入：CMIP6 GPP数据，分辨率为月，一个模型可以有多个文件。
%输出：每年每个月的总和，一个模型有多个文件。
%单位：原始单位与输出单位均为w m-2。

clear;clc;

%（1）读入nc文件
%读入nc文件路径
sourceHisPath='E:\data\CMIP6\r1i1pifi\rsds\mon\historical\';
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

%读入模型列表
[~,modelList]=xlsread("E:\workplace\productivity temperature\supplement\modelList-gpp_tas_pr_rsds.xlsx");
modelList_num=size(modelList,1);

%将每个文件的模型名称单独列出来
his(1:2,:)=[];
hisPathes_split=cell(length-2,1);
%分割hisPathes
for i=1:length-2
    this_split=strsplit(his(i).name,'_');
    hisPathes_split(i,1)=this_split(3);
    a=1;
end

%挑选需计算的模型
%至此，所有和路径相关的矩阵的维度已都一致
%遍历hisPathes_split，判断是否为此次ModelList上需计算的模型，否则删除之
for i=length-2:-1:1
    tag=0;
    path_modelName=char(hisPathes_split(i));
    %遍历模型列表
    for j=1:modelList_num
        list_modelName=char(modelList(j));
        %如果该nc为ModelList需要计算的模型
        if(strcmp(path_modelName,list_modelName))
            tag=1;
            break;
        end
    end
    %如果不是ModelList中需要计算的模型，删除之
    if(tag==0)
        hisPathes(i,:)='';
        his(i)=[];
    end
end

%（2）保存结果的路径和名称
length_compute=size(his,1);%得到参与计算的文件数量
saveSourcePath='E:\workplace\productivity temperature\result\year\rsds\gpp-tas-pr-rsds\autumn_NH\historical\';
 for i=1:length_compute
     savePath=strcat(saveSourcePath,his(i).name);
     savePath=strrep(savePath,'.nc','');
     if i==1
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end
 
 path_growingSeason='E:\data\phenology\growing season\globalMonthlyGS.mat';
 
 %（3）调用function
 for i=1:length_compute
     fun_rsdsSumYear(hisPathes(i,:),path_growingSeason,savePaths(i,:));
 end
 
 