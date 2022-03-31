%%%将每月的pr数据处理为以年为分辨率的值。
%输入：CMIP6 pr数据，分辨率为月，一个模型可以有多个文件。
%输出：原始单位为kg m-2 s-1输出数据的单位为mm yr-1。

function[]=fun_prSumYear(path_data,path_growingSeason,path_save)

%去掉路径中的空格，否则无法从字符串中提取年份信息
path_data(isspace(path_data)) = [];
%从路径中提取年份信息
year1=str2double(path_data(length(path_data)-15:length(path_data)-12));
year2=str2double(path_data(length(path_data)-8:length(path_data)-5));

%读入生长季数据
GS=load(path_growingSeason);
GS=GS.globalMonthlyGS;%此处的GS仅仅起到判断栅格是否为植被覆盖的栅格
%计算植被覆盖范围
veCover=sum(GS,3);
veCover((veCover == 0)) = nan;
%仅计算北半球
veCover=veCover(1:180,:);

%定义空间分辨率
row=180; col=720;

%每月及每年有多少天
daysMonth=[31,28,31,30,31,30,31,31,30,31,30,31];%非闰年
daysMonth_leap=[31,29,31,30,31,30,31,31,30,31,30,31];%闰年

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
    tasmax=ncread(path_data,'pr',startLoc,count);
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
    for i_lon=1:col
        for i_lat=1:row
            %如果该栅格非植被覆盖区域，则直接为Nan
            if(isnan(veCover(i_lat,i_lon)))
                continue;
            end
            %将原始单位kg m-2 s-1换算为mm day-1
            tasmax_grow=tasmax(i_lat,i_lon,:)*86400;
            tasmax_reshape=reshape(tasmax_grow,1,12);
            %判断是否为闰年，换算为mm mon-1
            if(rem(i_year,100)~=0&&rem(i_year,4)==0)
                tasmax_month=tasmax_reshape.*daysMonth_leap;%闰年
            else
                tasmax_month=tasmax_reshape.*daysMonth;%非闰年
            end
            
            %将该年每月的pr加总，换算为mm yr-1
            result(i_lat,i_lon,tag)=sum(tasmax_month(1,[9 10 11]),'omitnan');           
        end
    end
    tag=tag+1;
end

%保存结果
save(path_save,'result');
