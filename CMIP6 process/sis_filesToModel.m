%将每个模型年tasmax的均值组合为一个.mat
clear;clc;

%模型数量，需要根据文件夹中模型的数量更改
model_num=9;
%senorio
% year1=2015;year2=2100;
%historical
year1=1850;year2=2014;

sourceHisPath='E:\workplace\productivity temperature\result\year\gpp\gpp-tas-pr-rsds\autumn_NH\historical\';
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

split_str=cell(length-2,8);
id=zeros(model_num,2);
id(1,1)=1;
id(model_num,2)=length-2;
%将相同模型的序号找出，并存储在id数组中
for i=1:length-2
    split_str(i,:)=strsplit(hisPathes(i,:),'_');    
end

tag=1;
for i=2:length-2
    model_name1=char(split_str(i-1,4));
    model_name2=char(split_str(i,4));
    if(strcmp(model_name1,model_name2))
        continue;
    else
        id(tag,2)=i-1;
        id(tag+1,1)=i;
        tag=tag+1;
    end
end

k=0;
%将相同的模型合并
for i=1:model_num
    %得到模型文件的个数
    file_num=id(i,2)-id(i,1)+1;
    %将文件依次拼合在一起
    result=load(hisPathes(id(i,1),:));
    result=result.result;
    k=k+1;
    if(file_num>1)
        for j=2:file_num
            file=load(hisPathes(id(i,1)+j-1,:));
            file=file.result;
            result=cat(3,result,file);
            k=k+1;
        end
    end
    
    %检查result是否包含正确的年份数，包含所有年份才保存文件
    yearCheck=year2-year1+1;
    result_year=size(result,3);
    if(yearCheck==result_year)
        save_path=strcat('E:\workplace\productivity temperature\result\year_con\gpp\gpp-tas-pr-rsds\autumn_NH\historical_1850-2014\', char(split_str(k,4)));
        save(save_path,'result');
    end
end

