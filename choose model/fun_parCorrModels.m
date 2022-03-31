%gpp-tas-pr-rsds，计算gpp和tas的偏相关系数
%输入：每个模型从2000-2100年的gpp tas pr rsds
%输出：gpp和tas的偏相关系数矩阵，从2001-2015年

function[]=fun_parCorr2001to2015(gpp_path,tas_path,pr_path,rsds_path,saveCorr_path,saveP_path)

%给定空间分辨率与时间分辨率，需要根据要求自行更改
row=180;
col=720;
years=14;

%读入gpp
gpp=load(gpp_path);
gpp=gpp.result;
gpp=gpp(:,:,2:15);  %2001-2014年
%读入tas
tas=load(tas_path);
tas=tas.result;
tas=tas(:,:,2:15);  %2001-2014年
%读入pr
pr=load(pr_path);
pr=pr.result;
pr=pr(:,:,2:15);    %2001-2014年
%读入rsds
rsds=load(rsds_path);
rsds=rsds.result;
rsds=rsds(:,:,2:15);    %2001-2014年

%预定义结果矩阵，需要根据要求自行更改
result=nan(row,col);
result_pval=nan(row,col);

%判断哪个栅格点为可计算格网点的矩阵
catMatrix=cat(3,gpp,tas,pr,rsds);
calMatrix=sum(catMatrix,3);

%遍历每一个栅格
for i_lon=1:col
    for i_lat=1:row
        if(isnan(calMatrix(i_lat,i_lon)))
            continue;
        else
            %重塑为1*15数组，否则无法应用detrend
            gpp_reshape=reshape(gpp(i_lat,i_lon,:),1,years);
            tas_reshape=reshape(tas(i_lat,i_lon,:),1,years);
            pr_reshape=reshape(pr(i_lat,i_lon,:),1,years);
            rsds_reshape=reshape(rsds(i_lat,i_lon,:),1,years);
            
            %计算2001-2015年的偏相关系数
            gpp_detrend=detrend(gpp_reshape);
            tas_detrend=detrend(tas_reshape);
            pr_detrend=detrend(pr_reshape);
            rsds_detrend=detrend(rsds_reshape);
            
            %计算偏相关系数，rho是2*2相关系数矩阵，pval是p值。每一列是一个变量。
            [rho,pval]=partialcorr([gpp_detrend' tas_detrend'],[pr_detrend' rsds_detrend']);
            result(i_lat,i_lon)=rho(1,2);
            result_pval(i_lat,i_lon)=pval(1,2);
        end
    end
    disp(i_lon);
end

%保gpp和tas的偏相关系数结果矩阵
save(saveCorr_path,'result');
save(saveP_path,'result_pval');
