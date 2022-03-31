%在一个文件夹下顺序创建文件夹

sourcePath='D:\data\CRU-NCEP\V7\Solr\';
for i=2001:2015
    new_folder=[sourcePath,num2str(i),'\'];
    mkdir(new_folder);
end