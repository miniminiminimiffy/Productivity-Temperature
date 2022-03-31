%%%将每月的tasmax数据处理为每年*6-8月（此处划重点）*的平均值。
%文件名：tasmax:变量名;summer:一年中参与计算的月份为北半球夏季6-8月;Nh:只计算北半球;MtoY:原始CMIP6分辨率为月现将其计算为每年的均值。
%输入：CMIP6 tasmax数据，分辨率为月，一个模型可以有多个文件。
%输出：每年6-8月的平均值，一个模型有多个文件。
%单位：原始单位为K，输出单位为℃。

clear

%（1）读入nc文件
%读入nc文件路径
sourceHisPath='E:\data\CMIP6\r1i1pifi\tas\mon\historical\';
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
    path_modelName(isspace(path_modelName)) = [];
    %遍历模型列表
    for j=1:modelList_num
        list_modelName=char(modelList(j));
        list_modelName(isspace(list_modelName)) = [];        
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

%（2）保存处理后mat文件的路径
length_compute=size(his,1);%得到参与计算的文件数量
saveSourcePath='E:\workplace\productivity temperature\result\year\tas\gpp-tas-pr-rsds\autumn_NH\historical\';
 for i=1:length_compute
     savePath=strcat(saveSourcePath,his(i).name);
     savePath=strrep(savePath,'.nc','');
     if i==1
     savePaths=savePath;
     else
     savePaths=char(savePaths,savePath);
     end
 end
 
%需要从生长季得到植被覆盖区域
path_GS='E:\data\phenology\growing season\globalMonthlyGS.mat';
 
 %（3）调用function
 for i=1:length_compute
     fun_tasmaxSummerNhMtoY(hisPathes(i,:),path_GS,savePaths(i,:));
 end
 