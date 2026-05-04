clc; clear;

data_path = './data/';
out_path = './outputs/';

if ~exist(out_path, 'dir')
    mkdir(out_path);
end

file = fullfile(data_path, 'GSR-CDM.xlsx');
T = readtable(file, 'PreserveVariableNames', true);

vars = T.Properties.VariableNames;
tasks = {'LAN','WM','EMO','MOT','REL','GAM','SOC'};

results = [];

for i = 1:length(tasks)
    task = tasks{i};

    idx1 = find(contains(vars,[task ' no gsr400']),1);
    idx2 = find(contains(vars,[task ' gsr400']),1);
    idx3 = find(contains(vars,[task ' no gsr400+pos']),1);
    idx4 = find(contains(vars,[task ' no gsr360']),1);

    if isempty(idx1) || isempty(idx2) || isempty(idx3) || isempty(idx4)
        continue
    end

    x = T.(vars{idx1});
    y1 = T.(vars{idx2});
    y2 = T.(vars{idx3});
    y3 = T.(vars{idx4});

    [r1,p1] = corr(x,y1,'rows','complete');
    [r2,p2] = corr(x,y2,'rows','complete');
    [r3,p3] = corr(x,y3,'rows','complete');

    results = [results; {task,r1,p1,r2,p2,r3,p3}];
end

ResultTable = cell2table(results,...
    'VariableNames',{'Task','r_GSR','p_GSR','r_POS','p_POS','r_360','p_360'});

writetable(ResultTable, fullfile(out_path,'Task_Correlation_Results.xlsx'));

disp('Robustness analysis completed.');