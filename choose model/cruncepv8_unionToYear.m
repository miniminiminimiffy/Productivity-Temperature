%提取CRUNCEP 6-8月份数据 单独存为一个文件
clear;

sourcePath='D:\data\CRU-NCEP\V8.1\2001-2015\';
files=dir(sourcePath);
files(1:2,:)=[];
fileNum=size(files,1);

saveRootPath='D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\CRUNCEP\v8\6hour_2001-2015\SWdown_June-August\';

%读入每个文件
for i_file=1:fileNum
    %取得每个文件夹下的数据矩阵
    thisFilePath=[sourcePath,files(i_file).name];
    data=ncread(thisFilePath,'SWdown');
    land=ncread(thisFilePath,'land');
    
    %取得年份
    i_year=2000+i_file;
    
    %将Tair有数据的地方赋值给Tworld，没数据的地方设置为nan
    N=length(data(1,:));
    dataWorld=nan(360*720,N);
    dataWorld(land,:)=data;
    
    clear data;
    dataWorld=reshape(dataWorld,720,360,N);
    dataWorld=permute(dataWorld,[2 1 3]);%将其变成360*720的矩阵
    
    %判断是否为闰年,只取每年的6-8月份
    if(rem(i_year,100)~=0 && rem(i_year,4)==0)
        result=dataWorld(:,:,152*4+1:244*4);    %闰年,2月有29天
    else
        result=dataWorld(:,:,151*4+1:243*4);    %非闰年
    end
    
    %保存结果
    thisSavePath=[saveRootPath,'SWdown_',num2str(i_year)];
    save(thisSavePath,'result')
end


