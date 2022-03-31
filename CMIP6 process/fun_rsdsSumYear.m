%作用：将每个月的rsds取平均得到一年的平均rsds
%输入：CMIP6的rsds数据，分辨率为月，一个模型有多个文件
%输出：每年12个月平均的rsds，分辨率为年，一个模型有多个文件

function[]=fun_rsdsSumYear(path_data,path_growingSeason,path_save)

%去掉路径中的空格，否则无法从字符串中提取年份信息
path_data(isspace(path_data)) = [];
%从路径中提取年份信息
year1=str2double(path_data(length(path_data)-15:length(path_data)-12));
year2=str2double(path_data(length(path_data)-8:length(path_data)-5));

%读入生长季数据
GS=load(path_growingSeason);
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
    tasmax=ncread(path_data,'rsds',startLoc,count);
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
    for i_lat=1:row
        for i_lon=1:col
           %如果该栅格非植被覆盖区域，则直接为Nan
            if(isnan(veCover(i_lat,i_lon)))
                continue;
            end
            
            %将每年12个月的rsds加总起来
            tasmax_reshape=reshape(tasmax(i_lat,i_lon,:),1,12);
            result(i_lat,i_lon,tag)=sum(tasmax_reshape(1,[9 10 11]),'omitnan');           
        end
    end
    tag=tag+1;
end

%保存结果
save(path_save,'result');
