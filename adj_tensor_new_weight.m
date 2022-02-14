% �����Ҳ�ͬ��ϡ���ʾ->incƽ��->�ڽӾ�����Ȩ��->��������
% ���ۣ�����Ҷ�任����ͻ���A(i1,i2,i3)��ʽ�����ṹȨ�ؽ�����ơ�

%% �����������
clear;
load('Data\\COBRE_inc_mat_new.mat')

%% ���ò���COBRE
% COBREǰ74control����71patient
num_control = 74;
num_patient = 71;

%% ƽ��ϡ���ʾ����
% �ֿ��ڽӾ���
num_subjects = size(inc_mat, 3); % �������߸���

control_inc_all = inc_mat(:, :, 1:num_control);
patient_inc_all = inc_mat(:, :, (num_control + 1):num_subjects);

% ����������󣬷ֱ�ƽ��
control_inc_aver = mean(control_inc_all, 3);
patient_inc_aver = mean(patient_inc_all, 3);

%% �����ڽ�������ʹ���ڽӾ����е�Ȩ��
edge_num = 32;
left_num = 3;   % �����ĸ���
involves = cell(32, 2); % ������������

% �Կ�����inc����
% ÿ�������߱���3���ڵ�
inc_mat_i = control_inc_aver;
sub = 1;
for i = 1:edge_num
    edge_sort = sort(inc_mat_i(:, i), 'descend');
    min_coef = edge_sort(left_num); % ������left_num��ϵ��
    edge = inc_mat_i(:, i);
    edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
    inc_mat_i(:, i) = edge;
    ind = find(edge); % ��������������������
    involves{i, sub} = ind;
end

% �Ի�����inc����
% ÿ�������߱���3���ڵ�
inc_mat_i = patient_inc_aver;
sub = 2;
for i = 1:edge_num
    edge_sort = sort(inc_mat_i(:, i), 'descend');
    min_coef = edge_sort(left_num); % ������left_num��ϵ��
    edge = inc_mat_i(:, i);
    edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
    inc_mat_i(:, i) = edge;
    ind = find(edge); % ��������������������
    involves{i, sub} = ind;
end

%% ���ڽӾ���ȡ��Ȩ��
% ����Ȩ��
edges_weight = zeros(edge_num, 2);

adj_aver_c = mean(adj_mat_all(:, :, 1:num_control), 3);
adj_aver_p = mean(adj_mat_all(:, :, (num_control + 1):num_subjects), 3);

adj_i = adj_aver_c;
involve = involves(:,1);
for i = 1:edge_num
    edge_ind = involve{i};
    edges_weight(i, 1) = sum(adj_i(i, edge_ind));
end

adj_i = adj_aver_p;
involve = involves(:,2);
for i = 1:edge_num
    edge_ind = involve{i};
    edges_weight(i, 2) = sum(adj_i(i, edge_ind));
end
    

%% �����ڽ�����

order = 3;
ts_group = cell(2, 1);

for sub = 1:2
    ts = sptensor([32,32,32]);
    inds_cell = cell(27*32, 1);
    i_all = 1;
    inv_i = involves(:, sub);
    for i = 1:edge_num
        edge_i = inv_i{i};
        % �������������ϣ�3*3*3=27��Ԫ�ر�ʾһ������
        if length(edge_i) < 3
            continue;
        end
        for i1 = 1:order
            for i2 = 1:order
                for i3 = 1:order
                    inds_cell{i_all} = [edge_i(i1), edge_i(i2), edge_i(i3)];
                    ts(inds_cell{i_all}) = edges_weight(i, sub);
                    i_all = i_all + 1;
                end
            end
        end
    end
    
    ts_group{sub} = ts;
    
end


