%% ��ȡ��������
data_path = 'D:\Data\code_Du\COBRE\data_ROI';

num_subjects = 146;
ROI_num = 32;
time_length = 150;
ROI_time_series = zeros(time_length, ROI_num, num_subjects);

% ǰ74control�� ��72patient
for i = 1:num_subjects
    if i==112  % 112�ĳ���Ϊ67
        continue;
    end
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = cell2mat(data(1, 4:35));
    fprintf('ROI_Subject%03d_Session001.mat has been read.\n', i);
end


%% ��ȡȥ������������
data_path = 'D:\Data\code_Du\COBRE\denoise';

num_subjects = 145;
ROI_num = 32;
time_length = 150;
ROI_time_series = zeros(time_length, ROI_num, num_subjects);

% ǰ74control�� ��72patient
for i = 1:num_subjects
    if i==112  % 112�ĳ���Ϊ67
        continue;
    end
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Condition000.mat', i)));
    ROI_time_series(:, :, i) = cell2mat(data(1, 4:35));
    fprintf('ROI_Subject%03d_Condition000.mat has been read.\n', i);
end

%% ����
save('COBRE_denoise_32', 'ROI_time_series');



