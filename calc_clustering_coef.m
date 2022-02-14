% load('Data\\COBRE_inc_mat.mat');
% �����Ĺ��췽ʽ
inc_mat = inc_mat_FW_lasso;

num_subjects = size(inc_mat, 3);
num_roi = size(inc_mat, 1);
cc_all = zeros(32, num_subjects);

% ÿ���߱�������ϵ������
edge_num = size(inc_mat, 2);
left_num = 5;   % �����ĸ���


for sub = 1:num_subjects
    inc_mat_i = inc_mat(:, :, sub);
    % ÿ�������߱���left���ڵ�
    for i = 1:edge_num
        edge_sort = sort(inc_mat_i(:, i), 'descend');
        min_coef = edge_sort(left_num); % ������left_num��ϵ��
        edge = inc_mat_i(:, i);
        edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
        inc_mat_i(:, i) = edge;
        
    end
    inc_mat(:, :, sub) = inc_mat_i;
end


for sub = 1:num_subjects

    % ��i��������
%     H = double(inc_mat(:,:,sub) > 0);
    H = inc_mat(:, :, sub);
    H(H < 0) = 0;

    edges_v = zeros(5, 1); % �����ڵ�v�ĳ���

    num_others = 0;
    cluster_coef = zeros(num_roi, 1);

    for i = 1:num_roi
        edges_v = find(H(i, :));
        Nv = nnz( sum(H(2:end, edges_v), 2) ); %�ڵ�v���ھӵĸ���
        if size(edges_v, 2) <= 1
            cluster_coef(i) = 0;
            continue
        end
        cluster_coef(i) = ( 2 * nnz(H(2:end, edges_v))  - Nv )  / ( Nv * (size(edges_v, 2) - 1) );

    end

    cc_all(:, sub) = cluster_coef;

end

% ��������
label = [zeros(74, 1); ones(71, 1)];
cc_train = [cc_all', label];

%%
label = [zeros(117, 1); ones(49, 1)];
cc_train_open = [cc_all', label];
