%%%将每月的tasmax数据处理为每年*6-8月（此处划重点）*的平均值。
%文件名：tasmax:变量名;summer:一年中参与计算的月份为北半球夏季6-8月;Nh:只计算北半球;MtoY:原始CMIP6分辨率为月现将其计算为每年的均值。
%输入：CMIP6 tasmax数据，分辨率为月，一个模型可以有多个文件。
%输出：每年6-8月的平均值，一个模型有多个文件。
%单位：原始单位为K，输出单位为℃。

function[]=fun_tasmaxSummerNhMtoY(path_tasmax,path_GS,path_save)
%去掉路径中的空格，否则无法从字符串中提取年份信息
path_tasmax(isspace(path_tasmax)) = [];

%从路径中提取年份信息
year1=str2double(path_tasmax(length(path_tasmax)-15:length(path_tasmax)-12));
year2=str2double(path_tasmax(length(path_tasmax)-8:length(path_tasmax)-5));

%读入生长季数据
GS=load(path_GS);
GS=GS.globalMonthlyGS;
%计算植被覆盖范围
veCover=sum(GS,3);
veCover((veCover == 0)) = nan;
%仅计算北半球
veCover=veCover(1:180,:);

%定义空间分辨率
row=180; col=720;

%结果矩阵
result=nan(row,col,year2-year1+1);

startId=1;
tag=1;
for i_year=year1:year2
    endId=startId-1+12;
    count_3=12;
    
    %读入数据，一次读入一年的数据
    startLoc=[1,1,startId];
    count=[Inf,Inf,count_3];
    tasmax=ncread(path_tasmax,'tas',startLoc,count);
    
    %将读入数据重采样为360*720，并上下翻转
    tasmax=imresize(permute(tasmax,[2 1 3]),[360,720],'bilinear');
    tasmax=flip(tasmax);
    %将数据重新拼接为-180~180度的范围
    tasmax1=tasmax(:,1:360,:);
    tasmax2=tasmax(:,361:720,:);
    tasmax=[tasmax2,tasmax1];
    %只计算北半球的数据
    tasmax=tasmax(1:180,:,:);
    
    startId=endId+1;
    
    %计算每年平均值，并保存在矩阵中 
    %遍历每一个格网    
    tasmax_thisYear = mean(tasmax(:,:,9:11),3,'omitnan');
    tasmax_thisYear(isnan(veCover)) = nan;
    result(:,:,tag) = tasmax_thisYear;
    
%     for i_lon=1:col
%         for i_lat=1:row
%             %如果该栅格非植被覆盖区域，则直接为Nan
%             if(isnan(veCover(i_lat,i_lon)))
%                 continue;
%             end
%             tasmax_thisGrid=reshape(tasmax(i_lat,i_lon,:),1,12);
%             %将该年春或夏或秋季数据取均值
%             result(i_lat,i_lon,tag)=mean(tasmax_thisGrid(1,[3 4 5]),'omitnan');           
%         end
%     end
    
    tag=tag+1;
end

result=result-273.15;
save(path_save,'result');
