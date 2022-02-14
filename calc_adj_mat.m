%% �����ڽӾ���(Pearson�����)

num_subjects = size(ROI_time_series, 3);
num_ROIs = size(ROI_time_series, 2);
adj_mat = zeros(num_ROIs, num_ROIs);
adj_mat_all = zeros(num_ROIs, num_ROIs, num_subjects);

for sub = 1:num_subjects
    series = ROI_time_series(:, :, sub);

%     for i = 1:num_ROIs
%         for j = 1:num_ROIs
%             adj_mat(i, j) = corr(series(:, i), series(:, j));
%         end
%     end
    % ����ֱ����corr(X)���м��������
    adj_mat = corr(series);

    adj_mat_all(:, :, sub) = adj_mat;
    
end
