%将cru.ts4.0.5温度数据重采样为2001-2020年
%原始数据0.5°,mon
%输出数据0.5°,mon，每年一个mat

clear

%读入2001-2010年数据
ncdisp("E:\data\leaf senescence\CRU.TS\cru.ts4.0.5\pre\cru_ts4.05.2001.2010.pre.dat.nc")
pr1 = ncread("E:\data\leaf senescence\CRU.TS\cru.ts4.0.5\pre\cru_ts4.05.2001.2010.pre.dat.nc",'pre');
pr1 = rot90(pr1);
pr1 = pr1(1:180,:,:);

%读入2011-2020年数据
pr2 = ncread("E:\data\leaf senescence\CRU.TS\cru.ts4.0.5\pre\cru_ts4.05.2011.2020.pre.dat.nc",'pre');
pr2 = rot90(pr2);
pr2 = pr2(1:180,:,:);

pr = cat(3,pr1,pr2);

%为了方便后续计算，将每年的12个月单独存储为一个文件
saveRootPath = 'E:\workplace\productivity temperature\result\afters\SIF-temp\mon\pr\';

%从1982-2018年
for i_year = 1:20
    startId = i_year*12-11;
    endId = i_year*12;
    tmp_this = pr(:,:,startId:endId);
    
    thisYear = 2000+i_year;
    
    %保存文件
    result = tmp_this;
    thisSavePath = [saveRootPath,num2str(thisYear)];
    save(thisSavePath,'result');
end

