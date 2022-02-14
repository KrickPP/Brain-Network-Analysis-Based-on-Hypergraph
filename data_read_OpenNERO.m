data_path = 'F:\OpenNERO';

num_subjects = 167;
ROI_num = 132;
time_length = 152;
ROI_time_series = zeros(time_length, ROI_num, num_subjects);

% 4:35��network��36:167��atlas
% ǰ118control����49patient����167
for i = 1:num_subjects
    if i==45  % ��45������128
        continue;
    end
    fprintf('The %3dth sunject.\t', i);
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = cell2mat(data(1, 36:167));
    fprintf('Done.\n');
end

save('OpenNERO_132.mat', 'ROI_time_series')