%% ��������
% clear
% load('COBRE_Data\\COBRE_32.mat');
% load('OpenNERO_Data\\OpenNERO_32.mat');
dataSize = size(ROI_time_series);
numSubjects = dataSize(3);
numROI = dataSize(2);

inc_mat = zeros(numROI, numROI, numSubjects);

%% ����ϡ���ʾ��ֵ��ʹ��lasso
for i = 1:numSubjects
    sub_i = ROI_time_series(:, :, i); % ��i��������
    if i==1||mod(i, 10)==0||i==numSubjects
        fprintf('The %3dth subject.\n', i);
    end

    for j = 1:numROI
        roi_i = sub_i(:, j);
        A = sub_i;
        A(:, j) = 0; % ��j����������
        [x, info] = lasso(A, roi_i, 'Lambda', 0.09);
        inc_mat(:, j, i) = x;
        % fprintf('lambda = %6f.\n', info.Lambda(64));
        % fprintf('The %3dth ROI.\n', j);
    end
    
    if i==1||mod(i, 10)==0||i==numSubjects
        fprintf('The %3dth subject done.\n', i);
    end
end

%% �����ļ�
save('Data\\COBRE_inc_mat_new.mat', 'inc_mat');

%% �����ļ�
save('Data\\OpenNEURO_inc_mat_new.mat', 'inc_mat');
