%计算所有模型到达最适温度时间的中位数
clear;clc;

row=180;
col=720;
 
sourceHisPath='D:\workplace\productivity temperature\result\opt_year\June-August_NH\diff_CRU_2001-2013\ssp585_8\';
his = dir(sourceHisPath);
length = size(his,1);%文件夹中文件的数量
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

%求16%和84%分位数相差的年数
%排序
opt_YearAll_sort=sort(opt_YearAll,3);
%计算16%和84%的分位数
prc=prctile(opt_YearAll_sort,[25,75],3);

figure;
subplot(1,2,1)
imagesc(prc(:,:,1));
colorbar
subplot(1,2,2)
imagesc(prc(:,:,2));
colorbar

%保存结果
result=prc(:,:,1);
save('D:\workplace\productivity temperature\result\opt_year\June-August_NH\diff_CRU_2001-2013\ModelMean\8\ssp585_pr25.mat','result');
result=prc(:,:,2);
save('D:\workplace\productivity temperature\result\opt_year\June-August_NH\diff_CRU_2001-2013\ModelMean\8\ssp585_pr75.mat','result');

