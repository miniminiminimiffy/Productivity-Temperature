%计算cruncep Tair 和 FLUXCOM GPP之间的偏相关系数，控制变量为cruncep SWdown和cruncep Rainf

clear

row=180;
col=720;
years=20;

sif=load("E:\workplace\productivity temperature\result\afters\SIF-temp\June-August\CSIF.mat");
sif=sif.result;
tair=load("E:\workplace\productivity temperature\result\afters\SIF-temp\June-August\tmp.mat");
tair=tair.result;
swdown=load("E:\workplace\productivity temperature\result\afters\SIF-temp\June-August\rsds.mat");
swdown=swdown.result;
rainf=load("E:\workplace\productivity temperature\result\afters\SIF-temp\June-August\pr.mat");
rainf=rainf.result;

%预定义结果矩阵，需要根据要求自行更改
result=nan(row,col);
result_pval=nan(row,col);

%判断哪个栅格点为可计算格网点的矩阵
catMatrix=cat(3,sif,tair,swdown,rainf);
calMatrix=sum(catMatrix,3);

%遍历所有格网
for i_lon=1:col
    for i_lat=1:row
        if(isnan(calMatrix(i_lat,i_lon)))
            continue;
        else
            %重塑为1*15数组，否则无法应用detrend
            gpp_reshape=reshape(sif(i_lat,i_lon,:),1,years);
            tair_reshape=reshape(tair(i_lat,i_lon,:),1,years);
            rainf_reshape=reshape(rainf(i_lat,i_lon,:),1,years);
            swdown_reshape=reshape(swdown(i_lat,i_lon,:),1,years);
            
            %计算2001-2015年的偏相关系数
            gpp_detrend=detrend(gpp_reshape);
            tair_detrend=detrend(tair_reshape);
            rainf_detrend=detrend(rainf_reshape);
            swdown_detrend=detrend(swdown_reshape);
            
            %计算偏相关系数，rho是2*2相关系数矩阵，pval是p值。每一列是一个变量。
            [rho,pval]=partialcorr([gpp_detrend' tair_detrend'],[rainf_detrend' swdown_detrend']);
            result(i_lat,i_lon)=rho(1,2);
            result_pval(i_lat,i_lon)=pval(1,2);
        end
    end
    disp(i_lon);
end

figure;
imagesc(result);colorbar;

%保gpp和tas的偏相关系数结果矩阵
save('E:\workplace\productivity temperature\result\afters\SIF-temp\parCorr\parCorr_2001-2020.mat','result');
save('E:\workplace\productivity temperature\result\afters\SIF-temp\parCorr\pval_2001-2020.mat','result_pval');

