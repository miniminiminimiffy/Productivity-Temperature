% 将月分辨率数据转换为每年夏季的数据
% SIF tmp 是6-8月mean
% rsds pr 是6-8月sum

clear

% 空间分辨率
row = 180;
col = 720;

rootPath = 'E:\workplace\productivity temperature\result\afters\SIF-temp\mon\rsds\';
files = dir([rootPath,'*.mat']);
fileNum = size(files,1);

% 预定义结果矩阵,2001-2020年
result = nan(row,col,20);

%读入生长季数据
GS=load("E:\data\phenology\growing season\globalMonthlyGS.mat");
GS=GS.globalMonthlyGS;
%计算植被覆盖范围
veCover=sum(GS,3);
veCover((veCover == 0)) = nan;
%仅计算北半球
veCover=veCover(1:180,:);

for i_file = 1:fileNum
    % 读入数据
    thisPath = [rootPath,files(i_file).name];
    thisMat = load(thisPath);
    thisMat = thisMat.result;
    
    % 取6-8月均值，适用于SIF和rsds
%     result_thisYear = mean(thisMat(:,:,6:8),3,'omitnan');
    % 取6-8月总和，适用于rsds和pr
    result_thisYear = sum(thisMat(:,:,6:8),3,'omitnan');
    
    result_thisYear(isnan(veCover)) = nan;
    result(:,:,i_file) = result_thisYear;
end

% 保存结果
savePath = 'E:\workplace\productivity temperature\result\afters\SIF-temp\June-August\rsds.mat';
save(savePath,'result')

%%
% 检验结果
figure
for i=1:20
    subplot(4,5,i)
    imagesc(result(:,:,i));colorbar
end
