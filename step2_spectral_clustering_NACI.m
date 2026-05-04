clc; clear; close all;

data_path = './data/';
out_path = './outputs/';

if ~exist(out_path, 'dir')
    mkdir(out_path);
end

file_excel = fullfile(data_path, 'GSR-CDM.xlsx');
T = readtable(file_excel);

subject_ids = T{:,1};
NACI_matrix = real(T{:,2:8});

task_names = {'Lan','Soc','Wm','Emo','Mot','Gam','Rel'};

%% 相似性矩阵
sigma = 1;
dist_matrix = pdist2(NACI_matrix, NACI_matrix);
similarity_matrix = exp(-dist_matrix.^2 / (2*sigma^2));

%% 谱聚类
num_clusters = 2;
cluster_labels = spectralcluster(similarity_matrix, num_clusters, 'Distance', 'precomputed');

cluster_result = table(subject_ids, cluster_labels, ...
    'VariableNames', {'Subject','Cluster'});

writetable(cluster_result, fullfile(out_path, 'cluster_result.xlsx'));

%% Silhouette
k_range = 2:6;
mean_silhouette = zeros(length(k_range),1);

for i = 1:length(k_range)
    k = k_range(i);
    labels = spectralcluster(similarity_matrix, k, 'Distance', 'precomputed');
    s = silhouette(NACI_matrix, labels);
    mean_silhouette(i) = mean(s);
end

sil_table = table(k_range', mean_silhouette, ...
    'VariableNames', {'NumClusters','MeanSilhouette'});

writetable(sil_table, fullfile(out_path, 'silhouette_results.xlsx'));

%% 组间比较
group1 = NACI_matrix(cluster_labels==1,:);
group2 = NACI_matrix(cluster_labels==2,:);

n_tasks = size(NACI_matrix,2);
p_values = zeros(n_tasks,1);

for j = 1:n_tasks
    x1 = group1(:,j);
    x2 = group2(:,j);

    if lillietest(x1)==0 && lillietest(x2)==0
        [~,p] = ttest2(x1,x2);
    else
        p = ranksum(x1,x2);
    end
    p_values(j) = p;
end

stats_table = table(task_names', p_values, ...
    'VariableNames', {'Task','PValue'});

writetable(stats_table, fullfile(out_path, 'group_comparison_stats.xlsx'));

disp('Spectral clustering completed.');