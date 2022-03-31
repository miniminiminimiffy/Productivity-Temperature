%gpp-tas-pr-rsds，计算gpp和tas的偏相关系数，偏最小二乘系数
%输入：每个模型从2000-2100年的gpp tas pr rsds
%输出：gpp和tas的偏相关系数矩阵，20年的滑动平均，2019-2100年的partialCorr矩阵和pval矩阵

function[]=fun_gppTasPartialCorr3(gpp_path,tas_path,pr_path,rsds_path,saveCorr_path,saveP_path,saveSen_path)

%给定空间分辨率与时间分辨率，需要根据要求自行更改
row=180;
col=720;
years=101;
years_result=82;

%读入gpp
gpp=load(gpp_path);
gpp=gpp.result;
%读入tas
tas=load(tas_path);
tas=tas.result;
%读入pr
pr=load(pr_path);
pr=pr.result;
%读入rsds
rsds=load(rsds_path);
rsds=rsds.result;

%预定义结果矩阵，需要根据要求自行更改
result=nan(row,col,years_result);     
result_pval=nan(row,col,years_result);
sensitivity = nan(row,col,years_result);  % 偏最小二乘系数

%判断哪个栅格点为可计算格网点的矩阵
catMatrix=cat(3,gpp,tas,pr,rsds);
calMatrix=sum(catMatrix,3);

%遍历每一个栅格
for i_lon=1:col
    for i_lat=1:row
        if(isnan(calMatrix(i_lat,i_lon)))
            continue;
        else
            %重塑为1*101数组，否则无法应用detrend
            gpp_reshape=reshape(gpp(i_lat,i_lon,:),1,years);
            tas_reshape=reshape(tas(i_lat,i_lon,:),1,years);
            pr_reshape=reshape(pr(i_lat,i_lon,:),1,years);
            rsds_reshape=reshape(rsds(i_lat,i_lon,:),1,years);
            
            %20年滑动平均，使用去趋势后的数据计算偏相关系数(2020-2100年)
            for i_year=1:years_result
                %取得滑动平均区间的数据
                gpp_thisYear=gpp_reshape(i_year:i_year+19);
                tas_thisYear=tas_reshape(i_year:i_year+19);
                pr_thisYear=pr_reshape(i_year:i_year+19);
                rsds_thisYear=rsds_reshape(i_year:i_year+19);
                %去除一阶线性趋势
                gpp_detrend=detrend(gpp_thisYear);
                tas_detrend=detrend(tas_thisYear);
                pr_detrend=detrend(pr_thisYear);
                rsds_detrend=detrend(rsds_thisYear);
                
                %计算偏相关系数，rho是2*2相关系数矩阵，pval是p值。每一列是一个变量。
                [rho,pval]=partialcorr([gpp_detrend' tas_detrend'],[pr_detrend' rsds_detrend']);
                result(i_lat,i_lon,i_year)=rho(1,2);
                result_pval(i_lat,i_lon,i_year)=pval(1,2);
                
                %计算偏最小二乘系数
                if(length(unique(gpp_detrend))<3 || length(unique(tas_detrend))<3 || length(unique(pr_detrend))<3 ||  length(unique(rsds_detrend))<3)
                    continue
                end
                X = [tas_detrend' pr_detrend' rsds_detrend'];
                [~,~,~,~,beta,~,~,~] = plsregress(X,gpp_detrend');
                sensitivity(i_lat,i_lon,i_year) = beta(2);
            end
        end
    end
    disp(i_lon);
end

%保gpp和tas的偏相关系数结果矩阵,与偏最小二乘系数矩阵
save(saveCorr_path,'result');
save(saveP_path,'result_pval');
save(saveSen_path,'sensitivity');

