%作用：将每月的GPP数据处理为每年的总和值，由于非生长季GPP可以忽略不计，所以不×生长季矩阵也可。
%输入：CMIP6的GPP数据，分辨率为月，一个模型有多个文件。
%输出：每年12个月累加起来的GPP，分辨率为年，一个模型有多个文件。

function[]=fun_gppSumYear(path_data,path_growingSeason,path_save)

%去掉路径中的空格，否则无法从字符串中提取年份信息
path_data(isspace(path_data)) = [];
%从路径中提取年份信息
year1=str2double(path_data(length(path_data)-15:length(path_data)-12));
year2=str2double(path_data(length(path_data)-8:length(path_data)-5));

%读入生长季数据，得到植被覆盖矩阵GSCover
GS=load(path_growingSeason);
GS=GS.globalMonthlyGS;
VeCover=sum(GS,3);
VeCover(VeCover==0)=nan;
%仅计算北半球
VeCover=VeCover(1:180,:);


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
    gpp=ncread(path_data,'gpp',startLoc,count);
    %将读入数据重采样为360*720，并上下翻转
    gpp=imresize(permute(gpp,[2 1 3]),[360,720],'bilinear');
    gpp=flip(gpp);
    %将数据重新拼接为-180~180度的范围
    gpp1=gpp(:,1:360,:);
    gpp2=gpp(:,361:720,:);
    gpp=[gpp2,gpp1];
    %仅计算北半球
    gpp=gpp(1:180,:,:);
    
    startId=endId+1;
    
    %计算每年平均值，并保存在矩阵中 
    %遍历每一个格网
    for i_lon=1:col
        for i_lat=1:row
            %如果非植被覆盖区域，直接跳过
            if(isnan(VeCover(i_lat,i_lon)))
                continue;
            end
            
            %将原始单位kg m-2 s-1换算为kg m-2 day-1
            gpp_grow=gpp(i_lat,i_lon,:)*86400;
            gpp_reshape=reshape(gpp_grow,1,12);
            %判断是否为闰年，换算为kg m-2 mon-1
            if(rem(i_year,100)~=0&&rem(i_year,4)==0)
                gpp_month=gpp_reshape.*daysMonth_leap;%闰年
            else
                gpp_month=gpp_reshape.*daysMonth;%非闰年
            end
            
            %将该年（n-m月）每月的GPP加总，换算为gC m-2 year-1
            gpp_month=gpp_month*1000;%kg换算为g
            result(i_lat,i_lon,tag)=sum(gpp_month(1,[9 10 11]),'omitnan');           
        end
    end
    tag=tag+1;
end

%保存结果
save(path_save,'result');
