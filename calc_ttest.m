% ʹ�þ�����з��ࣨת��������
%% COBRE ���ʵ�t����

num_roi = 32;
power = zeros(145, num_roi);
for i =1:145
    series = ROI_time_series(:,:,i);
    power(i, :) = mean(series.^2); % ÿ����һ���������ź�, power��1*32
    
%     power(i, :) = mean(abs(series));
end


[h, p] = ttest2(power(1:74, :), power(75:end, :), 'Alpha', 0.05);
figure
stem(h)

%% ʱ������T����
[h_time, p_time] = ttest2(ROI_time_series(:,:,1:74), ...
                        ROI_time_series(:,:,75:end), 'Dim', 3);
imagesc(h_time, [0,1])
colorbar

%% ԭʼinc_mat��t����
% inc_matת���������ࣺ
% ����������ö�ֵ��inc_mat����
inc_mat = inc_mat_elastic;

% H_vec = zeros(num_subjects, 32*32);
% for i = 1:num_subjects
%     H = double(inc_mat(:, :, sub) > 0);
%     
%     H_vec(i, :) = vec(H);
% end

[h_inc, p_inc] = ttest2(inc_mat(:,:,1:74), inc_mat(:,:,75:end), 'Dim', 3);
figure
imagesc(h_inc, [0,1])
colorbar
%% ԭʼadj_mat��t����

[h_adj, p_adj] = ttest2(adj_mat_all(:,:,1:74), adj_mat_all(:,:,75:end), 'Dim', 3);
figure
imagesc(h_adj, [0,1])
colorbar

%% A=HH-D����
A = zeros(32,32,145);
for i = 1:145
    inc = inc_mat(:,:,i);
    dv = sum(inc, 2);
    Dv = diag(dv);
    A(:,:,i) = inc * inc' - Dv;
end

[h_A, p_A] =ttest2(A(:,:,1:74), A(:,:,75:end), 'Dim', 3);
figure
imagesc(h_A, [0,1])
colorbar


%% S����t����
% �����Ĺ��췽ʽ
inc_mat = inc_mat_FW_lasso;

num_subjects = size(inc_mat, 3);
S_all = zeros(32, 32, num_subjects);
S_vec = zeros(num_subjects, 32*32);
for i = 1:num_subjects
    H = double(inc_mat(:, :, sub) > 0);
    W = diag(w_norm(:,i));
    de = sum(H, 1);
    De = diag(de);
    S_all(:,:,i) = H * W * De^-1 * H';
    S_vec(i, :) = vec(S_all(:,:,i));
end
[h_s, p_s] =ttest2(S_all(:,:,1:74), S_all(:,:,75:end), 'Dim', 3);
figure
imagesc(h_s, [0,1])
colormap parula
colorbar

%% ѵ������
label = [zeros(74, 1); ones(71,1)];
train_S_COBRE = [S_vec, label];

%% AHHD��һ��
label = [zeros(50, 1); ones(49,1)];
train_S_open = [S_vec, label];

%% ADHD
label = [zeros(44, 1); ones(55,1)];
train_S_ADHD = [S_vec, label];

%% 
label = [zeros(26, 1); ones(31,1)];
train_S_LMCI = [S_vec, label];