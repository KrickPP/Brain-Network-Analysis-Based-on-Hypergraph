%% ����ÿ���˵Ĺ�������
clear;
load('Data\\COBRE_inc_mat.mat');
%% ��������
dataSize = size(inc_mat);
num_subjects = dataSize(3);
num_node = dataSize(1);

%% ����ÿ���˵��ڽ�����
adj_all = cell(num_subjects, 1);

for i = 1:num_subjects
    adj_all{i} = inc_to_adj(inc_mat(:, :, i));
end
save('Data\\adj_all.mat', 'adj_all');
%% ��ÿ���˶���������CP�ֽ�
order = num_node; % 32��
T_all = cell(num_subjects, 1);
lambda_all = zeros(num_node, num_subjects);
U_aver_all = zeros(num_node, num_node, num_subjects);

% ÿ���˷ֽ��Σ�ѡ��ѽ��
% ������ѡlambda�����̵ģ�������ѡ���ģ����в��ԣ�
dec_times = 1;
for i = 1:74
    [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
    curr_dec = T_all{i};
    lambda_all(:, i) = T_all{i}.lambda;
    curr_length = sum(lambda_all(:, i) ~= 0);
    while dec_times <= 3
        [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
        next_dec = T_all{i};
        lambda_all(:, i) = T_all{i}.lambda;
        next_length = sum(lambda_all(:, i) ~= 0);
        if next_length < curr_length
            % �·ֽ���̣������·ֽ⣬�������ɷֽ�
            curr_dec = next_dec;
        end
        
        dec_times = dec_times +1;
    end
    dec_times = 1;
    % ����������ȡƽ��
    U = curr_dec.U;
    lambda_all(:, i) = curr_dec.lambda;
    U_aver_all(:, :, i) = (U{1} + U{2} + U{3}) / 3;
    
    fprintf('The %3dth subject CP_ORTHO Done.\n', i);
    
end
% ������
for i = 75:145
    [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
    curr_dec = T_all{i};
    lambda_all(:, i) = T_all{i}.lambda;
    curr_length = sum(lambda_all(:, i) ~= 0);
    while dec_times <= 3
        [T_all{i}, fit] = CP_ORTHO(adj_all{i}, order);
        next_dec = T_all{i};
        lambda_all(:, i) = T_all{i}.lambda;
        next_length = sum(lambda_all(:, i) ~= 0);
        if next_length < curr_length
            % �·ֽ���̣������·ֽ⣬�������ɷֽ�
            curr_dec = next_dec;
        end
        
        dec_times = dec_times +1;
    end
    dec_times = 1;
    % ����������ȡƽ��
    U = curr_dec.U;
    lambda_all(:, i) = curr_dec.lambda;
    U_aver_all(:, :, i) = (U{1} + U{2} + U{3}) / 3;
    
    fprintf('The %3dth subject CP_ORTHO Done.\n', i);
    
end

save('T_all', 'T_all');
save('lambda_all', 'lambda_all');
save('U_aver_all', 'U_aver_all');
fprintf('All Subjects CP_ORTHO Done and Saved.\n');
datestr(now)
%% ÿ���˶����㸵��Ҷ�任
s_fourier = zeros(num_node, num_subjects);

for i = 1:num_subjects
    % ÿ�������ߵ�ʱ�����У�����*�ڵ���
    timeseries = ROI_time_series(:, :, i);

    % �����źŵĹ��ʣ���Ϊһ���������ź�
    power = mean(timeseries.^2); % ÿ����һ���������ź�,power��1*N

    % ʹ�þ���ֵ�ľ�ֵ
%     power = mean(abs(timeseries));

    % V ��[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_all(:,:,i)';
    s_fourier(:, i) = (V * s).^2;
    fprintf('The %3dth subject Fourier Done.\n', i);
end

%% ����Ҷ�任�����ͼ
figure
imagesc(s_fourier, [0, 15]);
colorbar;
title('fourier transform')

%% ��������
label = [zeros(74, 1); ones(71, 1)];
cobre_train = [lambda_all', label];
