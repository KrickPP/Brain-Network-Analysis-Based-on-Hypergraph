%% �����������
clear;
load('Data\\COBRE_inc_mat_new.mat')

%% ���ò���COBRE
% COBREǰ74control����71patient
num_control = 74;
num_patient = 71;

%% ���ò���OPenNEURO
% OpenNEROǰ117control����49patient����166
num_control = 117;
num_patient = 49;

%% ���ò���ADHD
% ADHD_inattensive, ǰ44control����55 patient_inattensive
num_control = 44;
num_patient = 55;

%% ���ò���AD_LMCI
% AD_LMCI, ǰ26control����31 patient_LMCI
num_control = 26;
num_patient = 31;

%% ����ƽ���ڽ�����

% �ֿ��ڽӾ���
num_subjects = size(inc_mat, 3); % �������߸���

control_inc_all = inc_mat(:, :, 1:num_control);
patient_inc_all = inc_mat(:, :, (num_control + 1):num_subjects);

% ����������󣬷ֱ�ƽ��
control_inc_aver = mean(control_inc_all, 3);
patient_inc_aver = mean(patient_inc_all, 3);

% % �������Ľڵ�
% control_inc_aver = control_inc_aver + eye(32);
% patient_inc_aver = patient_inc_aver + eye(32);

% �����ڽ�����
control_adj = inc_to_adj(control_inc_aver);
patient_adj = inc_to_adj(patient_inc_aver);

%6Ԫ�ر�ʾһ������
% control_adj = inc_to_adj_6entry(control_inc_aver);
% patient_adj = inc_to_adj_6entry(patient_inc_aver);

% 4������
% control_adj = inc_to_adj_4order(control_inc_aver);
% patient_adj = inc_to_adj_4order(patient_inc_aver);


%% ���浽�ļ�
save('Data\\Open_adj_ts.mat', 'control_adj', 'patient_adj')

%% ���浽�ļ�
save('Data\\COBRE_adj_ts.mat', 'control_adj', 'patient_adj')
