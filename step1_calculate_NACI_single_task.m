clc; clear;

% 路径设置
data_path = './data/';
out_path = './outputs/';

if ~exist(out_path, 'dir')
    mkdir(out_path);
end

% 加载任务激活数据（400 × N）
Tvector = importdata(fullfile(data_path, 'task_activation.mat'))';

[n_regions, num_subjects] = size(Tvector);

NACI_values = zeros(num_subjects, 1);

fc_dir = fullfile(data_path, 'FC_matrices');

for subj = 1:num_subjects

    subj_idx = sprintf('%04d', subj);
    matrix_path = fullfile(fc_dir, [subj_idx '.txt']);

    SubjectFC = load(matrix_path);
    SubjectFC(isinf(SubjectFC)) = 0;

    observed_activation = Tvector(:, subj);

    predicted_activation = zeros(n_regions, 1);

    for i = 1:n_regions
        connections = SubjectFC(:, i);
        valid_idx = find(connections ~= 0);

        predicted_activation(i) = mean( ...
            observed_activation(valid_idx) .* connections(valid_idx) ...
        );
    end

    stats = regstats(observed_activation, predicted_activation);

    beta_coef = stats.tstat.beta(2);

    if beta_coef >= 0
        NACI_values(subj) = sqrt(stats.adjrsquare);
    else
        NACI_values(subj) = -sqrt(stats.adjrsquare);
    end
end

save(fullfile(out_path, 'NACI_values.mat'), 'NACI_values');

disp('NACI calculation completed.');