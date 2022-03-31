%用于CMIP6模型的清点与空文件的删除。
%输入：装有CMIP6模型的文件夹路径。
%输出：ModelsName是模型清点的结果，√为全，LACK为缺少，MORE为多余。

clear;clc

%需要自定义的参数：
%historical
startYear=1850;endYear=2014;
%senorio
% startYear=2015;endYear=2100;

%列出文件夹中所有文件的信息
sourceHisPath='D:\data\CMIP6\r1i1pifi\npp\historical\';
his = dir(sourceHisPath);
length = size(his,1); % 文件夹中文件的数量

%删除大小为0的文件
for i=3:length
    if(his(i).bytes==0)
        fileName=[sourceHisPath,his(i).name];
        delete(fileName);
    end
end

%获取所有文件的名称
for i=3:length
   hisName = his(i,1).name; 
   if i==3
       hisPathes=hisName;
   else
   hisPathes = char(hisPathes,hisName);%垂直拼接字符串，将文件夹下文件夹的名称读取出来
   end
end

%CMIP模型的第3与第7分别为模型名称与时间
ModelName_id=3;ModelDate_id=7;

%创建分割字符串后的数组
rows=size(strsplit(hisPathes(1,:),'_'),2);
strSplit=cell(length-2,rows);
for i=1:length-2
    strSplit(i,:)=strsplit(hisPathes(i,:),'_');
end
%在第一行和最后一行增加一行空的cell
strSplitEmpty=cell(1,rows);
strSplitEmpty(1,ModelName_id)=cellstr('Empty');
strSplitEmpty(1,ModelDate_id)=cellstr('201501-210012.nc');
strSplit=[strSplitEmpty;strSplit;strSplitEmpty];

%遍历每一个文件名，将所有模型的时间列出
tag=1;
for i=2:length
    %获取模型名称
    ModelName_before=strSplit(i-1,ModelName_id);
    ModelName_this=strSplit(i,ModelName_id);
    
    %获取模型时间
    ModelTime_before=char(strSplit(i-1,ModelDate_id));
    ModelTime_this=char(strSplit(i,ModelDate_id));
    ModelTime_befor_split=strsplit(ModelTime_before,'-');
    ModelTime_this_split=strsplit(ModelTime_this,'-');
    %file befor的时间
    ModelTime_before10=char(ModelTime_befor_split(1,1));
    ModelTime_before1=str2double(ModelTime_before10(1:4));
    ModelTime_before20=char(ModelTime_befor_split(1,2));
    ModelTime_before2=str2double(ModelTime_before20(1:4));
    %file this的时间
    ModelTime_this10=char(ModelTime_this_split(1,1));
    ModelTime_this1=str2double(ModelTime_this10(1:4));
    ModelTime_this20=char(ModelTime_this_split(1,2));
    ModelTime_this2=str2double(ModelTime_this20(1:4));
    
    if(~strcmp(ModelName_this,ModelName_before))
        %保存模型名称
        ModelName(tag,1)=ModelName_before;%由于预先不知道模型的数量，只能采用动态数组
        tag=tag+1;
        %保存模型时间，如果模型变化了，就将tag_date重置为1
        tag_date=1;
        ModelDate(tag,tag_date)=ModelTime_this1;
        ModelDate(tag,tag_date+1)=ModelTime_this2;
        tag_date=tag_date+2;
    else
        %保存模型时间
        ModelDate(tag,tag_date)=ModelTime_this1;
        ModelDate(tag,tag_date+1)=ModelTime_this2;
        tag_date=tag_date+2;
    end
end

%从第二行开始遍历，因为第一行是另外添加上去方便程序编写的
ModelNum=size(ModelName,1);
for i=2:ModelNum
    isOK=1;
    %去掉数组中的0
    thisDate=ModelDate(i,:);
    thisDate(thisDate==0)=[];
    
    %如果不包含2015和2100年的数据，则此模型不合格，跳过
    DateNum=size(thisDate,2);
    if(thisDate(1,1)~=startYear||thisDate(1,DateNum)~=endYear)
        if(thisDate(1,1)<startYear||thisDate(1,DateNum)>endYear)
            ModelName(i,2)=cellstr('MORE');
        else
            ModelName(i,2)=cellstr('LACK');
        end
        continue;
    end
        
    %遍历每一个时间
    for j=1:(DateNum/2)-1
        dateDiff=thisDate(1,j*2+1)-thisDate(1,j*2);
        %如果中间出现时间的跳跃，则此模型不合格，跳过
        if(dateDiff~=1&&dateDiff~=0)
            isOK=0;
            ModelName(i,2)=cellstr('LACK');
            break;
        end
    end
    if(isOK==1)
        ModelName(i,2)=cellstr('√');
    end
end
ModelName(1,:)=[];
result=ModelName;


%读入CMIP6模型汇总，取得必要参数
[~,allModels]=xlsread("E:\researches\research content\temperature-NEE\模型列表.xlsx");
allModels_num=size(allModels,1);
models_num=size(result,1);

%为allModels增加一列，用于储存结果
allModels(:,2)=cell(allModels_num,1);

%allModels中所有模型名称
for i=1:allModels_num
    %遍历result中所有模型
    thisName=char(allModels(i,1));
    thisName(isspace(thisName))=[];
    for j=1:models_num
        %将结果写入对应的模型处
        if(strcmp(thisName,result(j,1)))
            allModels(i,2)=result(j,2);
        end
    end
end
