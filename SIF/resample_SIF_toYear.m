%处理SIF数据
%输入数据为（1）6-hour分辨率
%输出的数据为（1）月分辨率，取每月所有数据的最大值（2）180*720（3）每年一个mat
%原始输入数据为data中分辨率为0.05°，全球的CSIF数据

clear

%定义空间分辨率
row = 180;
col = 720;
years = 20;

%保存结果路径
saveRootPath = 'E:\workplace\productivity temperature\result\afters\SIF-temp\mon\CSIF\';

%给定根文件夹
rootPath = 'E:\data\drought threshold\CSIF\';
foldersYear = dir(rootPath);
foldersYear(1:2) = [];

%定义每个月的结束id
monDay1s = [1,32,60,91,121,152,182,213,244,274,305,335];%非闰年起始序号
monDay1e = [31,59,90,120,151,181,212,243,273,304,334,365];%非闰年止序号
monDay2s = [1,32,61,92,122,153,183,214,245,275,306,336];%闰年起始序号
monDay2e = [31,60,91,121,152,182,213,244,274,305,335,366];%闰年止序号

%遍历文件夹，i_folder还代表年份
for i_folder = 2:21
    thisFolderPath = [foldersYear(i_folder).folder,'\',foldersYear(i_folder).name];
    files = dir(thisFolderPath);
    files(1:2) = [];
    fileNum0 = size(files);
    fileNum = fileNum0(1);
    
    %预定义结果矩阵
    result = zeros(row,col,12)-9999;
    
    %遍历每一个文件
    for i_file = 1:fileNum
        %读取本文件
        thisFilePath = [files(i_file).folder,'\',files(i_file).name];
        thisFile = ncread(thisFilePath,'clear_daily_SIF');
        %调整矩阵方向,将-9999换为nan
        thisFile = rot90(thisFile);
        thisFile(thisFile==-9999) = nan;
        %重采样
        thisFile_re = nan(row,col);
        for i_lon = 1:col
            for i_lat = 1:row
                window = thisFile(i_lat*10-9:i_lat*10,i_lon*10-9:i_lon*10);
                window_r = reshape(window,1,100);
                thisFile_re(i_lat,i_lon) = mean(window_r,'omitnan');
            end
        end
        %取北半球
        thisFile_re = thisFile_re(1:row,:);
        %取得本文件的序号
        thisFileName = files(i_file).name;
        thisFileName_split = strsplit(thisFileName,'.');
        thisFileNo = char(thisFileName_split(5));
        thisFileNo = str2double(thisFileNo(5:7));
        %判断本文件属于哪个月份
        for i_mon = 1:12
            if(rem(i_folder,4)~=0)%非闰年
                if(thisFileNo>=monDay1s(i_mon) && thisFileNo<=monDay1e(i_mon))
                    thisFileMonth=  i_mon;
                end
            else%闰年
                if(thisFileNo>=monDay2s(i_mon) && thisFileNo<=monDay2e(i_mon))
                    thisFileMonth = i_mon;
                end
            end
        end
        
        %取该年该月份的文件，与本文件合并为一个多维矩阵
        matCom = cat(3,thisFile_re,result(:,:,thisFileMonth));
        matMax = max(matCom,[],3,'omitnan');
        matMax(matMax==-9999) = nan;
        %比较大小后，赋值给结果矩阵
        result(:,:,thisFileMonth) = matMax;
    end
    disp(i_folder);
    %保存结果
    thisSavePath = [saveRootPath,num2str(1999+i_folder,'%2d')];
    save(thisSavePath,'result')
end

%%
% 检验结果
for i=1:12
    subplot(3,4,i)
    imagesc(result(:,:,i),[0 0.6]);colorbar
    title(num2str(i))
end
