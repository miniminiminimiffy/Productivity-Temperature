%计算cruncep Tair 和 FLUXCOM GPP之间的偏相关系数，控制变量为cruncep SWdown和cruncep Rainf

clear

row=180;
col=720;
years=15;

gpp=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\FLUXCOM GPP\GPP_June-August_2001-2015.mat");
gpp=gpp.result;
tair=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\CRUNCEP\v8\1yr_2001-2015\Tair_June-August_mean.mat");
tair=tair.result;
swdown=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\CRUNCEP\v8\1yr_2001-2015\SWdown_June-August_sum.mat");
swdown=swdown.result;
rainf=load("D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\CRUNCEP\v8\1yr_2001-2015\Rainf_June-August_sum.mat");
rainf=rainf.result;

%取2001-2014年
gpp=gpp(:,:,1:15);
tair=tair(:,:,1:15);
swdown=swdown(:,:,1:15);
rainf=rainf(:,:,1:15);

%预定义结果矩阵，需要根据要求自行更改
result=nan(row,col);
result_pval=nan(row,col);

%判断哪个栅格点为可计算格网点的矩阵
catMatrix=cat(3,gpp,tair,swdown,rainf);
calMatrix=sum(catMatrix,3);

%遍历所有格网
for i_lon=1:col
    for i_lat=1:row
        if(isnan(calMatrix(i_lat,i_lon)))
            continue;
        else
            %重塑为1*15数组，否则无法应用detrend
            gpp_reshape=reshape(gpp(i_lat,i_lon,:),1,years);
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
save('D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\parCorr\parCorr_2001-2015.mat','result');
save('D:\workplace\productivity temperature\result\afters\chooseModel\Satellite\parCorr\pval_2001-2015.mat','result_pval');

