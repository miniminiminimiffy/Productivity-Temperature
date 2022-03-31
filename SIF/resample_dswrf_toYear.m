%将CRUJRA v2.2.5 地表向下短波辐射重采样为2001-2020年，取每个月的总量
%原始分辨率：6-hour,0.5°
%重采样后分辨率：1-mon,0.5°

clear

%空间分辨率
row = 180;
col = 720;

%每个月的起止日期
startIdx = [1,32,60,91,121,152,182,213,244,274,305,335];
endIdx= [31,59,90,120,151,181,212,243,273,304,334,365];
%一天有4个数据，换算成6-hour每个月的起止id
startIdx = startIdx*4-3;
endIdx = endIdx*4;

%保存结果的路径
saveRootPath = 'E:\workplace\productivity temperature\result\afters\SIF-temp\mon\rsds\';

rootPath = 'E:\data\leaf senescence\CRUJRA\crujra.v2.2.5d.dswrf\';
files = dir(rootPath);
files(1:2,:) = [];
filesNum = size(files,1);

%遍历2001-2020年每一年的nc文件
for i_file = 21:filesNum
    thisFilePath = [rootPath,files(i_file).name];                           
    
    %预定义该年的结果矩阵
    matThisYear = nan(row,col,12);
    
    %遍历每年的12个月
    for i_mon = 1:12    
        %读入该月在nc文件中的对应数据
        startLoc = [1 1 startIdx(i_mon)];                                
        count = [Inf Inf endIdx(i_mon)-startIdx(i_mon)+1];                
        mat_this = ncread(thisFilePath, 'dswrf',startLoc,count);
        
        %取该月辐射总量
        mat_sum = sum(mat_this,3,'omitnan');
        %调整矩阵
        mat_sum = rot90(mat_sum);
        mat_sum = mat_sum(1:180,:);
        mat_sum(mat_sum == 0) = nan;
        
        %检验结果
%         imagesc(mat_sum);colorbar
 
        matThisYear(:,:,i_mon) = mat_sum;
    end
    
    %保存结果
    result = matThisYear;
    thisSavePath = [saveRootPath,num2str(i_file+1980),'.mat'];
    save(thisSavePath,'result');
end