clc; clear;

data_path = './data/';
out_path = './outputs/';

if ~exist(out_path, 'dir')
    mkdir(out_path);
end

file = fullfile(data_path,'GSR-CDM.xlsx');
T = readtable(file);

c1 = string(T.noGsr400Cluster);
c2 = string(T.gsr400Cluster);

valid = ~ismissing(c1) & ~ismissing(c2);

consistency = mean(c1(valid)==c2(valid));

confMat = confusionmat(categorical(c1(valid)),categorical(c2(valid)));

p0 = trace(confMat)/sum(confMat(:));
pe = sum(sum(confMat,1).*sum(confMat,2)')/sum(confMat(:))^2;
kappa = (p0 - pe)/(1 - pe);

ResultTable = table(consistency*100, kappa,...
    'VariableNames',{'Consistency_percent','Kappa'});

writetable(ResultTable, fullfile(out_path,'Cluster_Consistency.xlsx'));

disp('Cluster consistency analysis completed.');