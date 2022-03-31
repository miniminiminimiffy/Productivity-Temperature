%计算一个文件夹中二维矩阵的均值，适用的是x*y的二维矩阵

clear;clc;

row=180;
col=720;
 
sourceHisPath='D:\workplace\productivity temperature\result\sensitivity\June-August_NH\gpp-tas\ssp585_2019-2100\change[2081-2100][2001-2020]\';
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

opt_YearAll=zeros(row,col,length-2);

%遍历每一个文件，拼接为一个文件
for i=1:length-2
    opt_year=load(hisPathes(i,:));
    opt_year=opt_year.result;
    %遍历两个文件的每一年
    opt_YearAll(:,:,i)=opt_year;
end

%求均值
result=mean(opt_YearAll,3,'omitnan');

%检验结果
% figure
% imagesc(result);
% colorbar

%保存数据
save("D:\workplace\productivity temperature\result\sensitivity\June-August_NH\gpp-tas\modelMean\withoutBCC\ssp585_change[2001-2020][2081-2100].mat",'result');
