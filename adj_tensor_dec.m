%% �ֽ��������õ�Ƶ�ʷ���
% load('Data\\adj_ts.mat')

%% �ֽ������
% �����ΪN=32
rank = 32;
% control_adj = ts_group{1};

[T, fit] = CP_ORTHO(control_adj, rank);
% T_full = full(T);
% save(sprintf('T_%.2f.mat', fit), 'T') % ���ֽ���T���浽�ļ�

% ���adj_ts�ǳ��ԳƵģ�U{i} 32*order��������Ӧ�����
% �ֽ���ÿ��ȷʵ������ȣ������������ȡ��ֵ
U = T.U;
lambda_c = T.lambda;
U_aver_c = (U{1} + U{2} + U{3}) / 3;

%% �ֽ⻼����
% patient_adj = ts_group{2};
[T, fit] = CP_ORTHO(patient_adj, rank);
% T_full = full(T);

U = T.U;
lambda_p = T.lambda;
U_aver_p = (U{1} + U{2} + U{3}) / 3;

%% ��ͼ
figure;
imagesc(U_aver_c);
colorbar;
% title('control frequency')

figure
imagesc(U_aver_p);
colorbar;
% title('patient frequency')


%% ��������
save('Data\\COBRE_U_aver_c.mat', 'U_aver_c', 'lambda_c')
save('Data\\COBRE_U_aver_p.mat', 'U_aver_p', 'lambda_p')


%% ��������
save('Data\\Open_U_aver_c.mat', 'U_aver_c', 'lambda_c')
save('Data\\Open_U_aver_p.mat', 'U_aver_p', 'lambda_p')

%% ��������
save('Data\\ADHD_U_aver_c.mat', 'U_aver_c', 'lambda_c')
save('Data\\ADHD_U_aver_p.mat', 'U_aver_p', 'lambda_p')






