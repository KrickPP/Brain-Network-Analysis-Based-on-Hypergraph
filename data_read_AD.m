%% ��ȡ�������� ԭʼ����
% 32����
data_path = 'D:\QQ_files\MCI_Data';

num_subjects = 56;
ROI_num = 32;
ROI_time_series = cell(1, ROI_num, num_subjects);


for i = 1:num_subjects
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = data(4:35);
    fprintf('ROI_Subject%03d_Session001.mat has been read.\n', i);
end
save('AD_32.mat', 'ROI_time_series');

%% 132����
data_path = 'D:\QQ_files\MCI_Data';

num_subjects = 56;
ROI_num = 132;
ROI_time_series = cell(1, ROI_num, num_subjects);

for i = 1:num_subjects
    load(fullfile(data_path, sprintf('ROI_Subject%03d_Session001.mat', i)));
    ROI_time_series(:, :, i) = data(36:167);
    fprintf('ROI_Subject%03d_Session001.mat has been read.\n', i);
end

% save('AD_132.mat', 'ROI_time_series');

%% �����ϲ�

AD_132roi(:,:,1:19)=ROI_time_series(:,:,1:19);
AD_132roi(:,:,20:28)=ROI_time_series_2(:,:,1:9);
AD_132roi(:,:,29:34)=ROI_time_series(:,:,20:25);
AD_132roi(:,:,35:54)=ROI_time_series_2(:,:,10:29);

%%
AD_32roi = ADHD_32roi;
save('AD_32.mat', 'AD_32roi');

%% ͳ�Ƴ���
load('AD_132.mat')
num_subjects = 54;
time_series = cell(1,32);
length = zeros(num_subjects, 1);

for i = 1:num_subjects
    time_series = cell2mat(AD_132roi(:,:,i));
    length(i) = size(time_series, 1);
end



