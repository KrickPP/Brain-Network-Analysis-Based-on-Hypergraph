%% ����ADHD����
% clear
% load('ADHD\\ADHD_32.mat');
dataSize = size(ROI_time_series);

numSubjects = dataSize(3);
numROI = dataSize(2);

inc_mat = zeros(numROI, numROI, numSubjects);

%% ����ϡ���ʾ��ֵ��ʹ��lasso
for i = 1:numSubjects
    sub_i = cell2mat(ROI_time_series(:, :, i)); % ��i��������
    
    if i==1||mod(i, 10)==0||i==numSubjects
        fprintf('The %3dth subject.\n', i);
    end

    for j = 1:numROI
        roi_i = sub_i(:, j);
        A = sub_i;
        A(:, j) = 0; % ��j����������
        [x, info] = lasso(A, roi_i, 'Lambda', 0.1);
        inc_mat(:, j, i) = x;
        % fprintf('lambda = %6f.\n', info.Lambda(64));
        % fprintf('The %3dth ROI.\n', j);
    end
    
    if i==1||mod(i, 10)==0||i==numSubjects
        fprintf('The %3dth subject done.\n', i);
    end
end

%% �����ļ�
save('Data\\ADHD_inc_mat.mat', 'inc_mat');

%% �����ļ�AD
save('Data\\AD_inc_mat.mat', 'inc_mat');



