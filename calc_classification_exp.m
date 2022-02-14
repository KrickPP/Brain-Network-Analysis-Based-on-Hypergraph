% ����ʵ��
% ϡ���ʾ -- A��Ȩ�� -- AC�������

% ��������ϵ������
num_subjects = size(inc_mat, 3);
edge_num = 32;
left_num = 3;   % �����ĸ���
involves = cell(32, 145);

for sub = 1:num_subjects
    inc_mat_i = inc_mat(:, :, sub);
    % ÿ�������߱���3���ڵ�
    for i = 1:edge_num
        edge_sort = sort(inc_mat_i(:, i), 'descend');
        min_coef = edge_sort(left_num); % ������left_num��ϵ��
        edge = inc_mat_i(:, i);
        edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
        inc_mat_i(:, i) = edge;
        ind = find(edge); % ��������������������
        involves{i, sub} = ind;
    end
    inc_mat(:, :, sub) = inc_mat_i;
end

%% ȡ�ڽӾ����е�ϵ����ΪȨ��
edges_weight = zeros(edge_num, num_subjects);
for sub = 1:num_subjects
    adj_i = adj_mat_all(:,:,sub);
    involve = involves(:,sub);
    for i = 1:edge_num
        edge_ind = involve{i};
        
        edges_weight(i, sub) = sum(adj_i(i, edge_ind));
        
    end
    
end

%% ����ʵ��2-�����ھӷ���
num_subjects = size(adj_mat_all, 3);
edges_all = cell(num_subjects, 1);
for sub = 1:num_subjects
    adj_mat_i = adj_mat_all(:,:,sub);
    adj_mat_i(adj_mat_i < 0.6) = 0;
    edges_ind = cell(200, 3); % �洢�µĳ��ߣ�����C(32,2)= 496��
    ind = 1; % �µıߵ�����
    for i = 1:31
        rois_i = adj_mat_i(i, :);
        for j = (i + 1):32
            % adj_mat��Ҫת�ɶ�ֵ����(0-1)
            rois_j = adj_mat_i(j, :);
            roi_common = rois_i .* rois_j; % ͬʱ�����ڵ�i, j��������������i,j
            ind_common = find(roi_common);
            if length(ind_common) >= 2
                % ���������ڵ�Ĳ���һ����
                edges_ind{ind, 1} = [i, j];
                edges_ind{ind, 2} = ind_common;
                ind = ind + 1;
            end
        end

    end
    % edges_ind�հ׵�ɾ��
    edges_ind(ind:end, :) = [];

    % �����߱�������ڵ�ĳ���
    for i = 1:length(edges_ind)
        if length(edges_ind{i, 2}) == 2
            % ��һ��i�ڵ㣨����Ȩ�أ����ڵ��i,jȨ�غͣ���Ӧadj_mat��4���ߣ�
            edges_ind{i, 3} = sum(adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2}));
            edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];

        elseif length(edges_ind{i, 2}) == 3
            % ȡȨ�ؼ���������������û��i��j�ڵ㣩
            % i_com1 + i_com2Ȩ����������
            weight = adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % ������������, �����м�һ�У����ڵ��i,jȨ�غ�(��Ӧadj_mat��6����)
            edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
            
        elseif length(edges_ind{i, 2}) == 4
            % ȡȨ�ؼ���������4����û��i��j�ڵ㣩
            % i_com1 + i_com2Ȩ������4��
            weight = adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % ������������, �����м�һ�У����ڵ��i,jȨ�غ�(��Ӧadj_mat��6����)
            edges_ind{i, 2} = weight_with_ind_sort(1:4, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:4, 2));
        elseif length(edges_ind{i, 2}) >= 5
            % ȡȨ�ؼ���������4����û��i��j�ڵ㣩
            % i_com1 + i_com2Ȩ������4��
            weight = adj_mat_i(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
                + adj_mat_i(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % ������������, �����м�һ�У����ڵ��i,jȨ�غ�(��Ӧadj_mat��6����)
            edges_ind{i, 2} = weight_with_ind_sort(1:5, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:5, 2));
        end
    end
    edges_all{sub, 1} = edges_ind;

end

%% ת��H����
H_all = cell(145, 1);
w_all = cell(145, 1);

for sub = 1:145
    edges_i = edges_all{sub};
    edges_num = size(edges_i, 1);
    H = zeros(32, edges_num);
    w = zeros(edges_num, 1);
    % δȥ��
    for i = 1:edges_num
        H(edges_i{i, 2}, i) = 1;
        w(i) = edges_i{i, 3};
    end

    H_all{sub} = H;
    w_all{sub} = w;
end


%% S����t����
num_subjects = 145;
S_all = zeros(32, 32, num_subjects);
S_vec = zeros(num_subjects, 32*32);
for i = 1:num_subjects
    H = H_all{i};
    
    W = diag(w_all{i});
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

