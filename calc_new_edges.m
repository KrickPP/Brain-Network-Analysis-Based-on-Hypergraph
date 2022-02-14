%% ����µĳ���-�����ھ�
% ����1 ���ڽӾ������ҳ�ͬʱ�������������Ĺ�������
edges_ind = cell(200, 3); % �洢�µĳ��ߣ�����C(32,2)= 496��
ind = 1; % �µıߵ�����

% ���ڽӾ����ֵ��
% ����ƽ��
thre = 0.55;
adj_mat_c = mean(adj_mat_all(:, :, 1:74), 3);
adj_mat_p = mean(adj_mat_all(:, :, 75:end), 3);
adj_mat_c(adj_mat_c < thre) = 0;
adj_mat_p(adj_mat_p < thre) = 0;
adj_mat_c(logical(eye(32))) = 0;    % �Խ���Ԫ������
adj_mat_p(logical(eye(32))) = 0;

for i = 1:31
    rois_i = adj_mat_c(i, :);
    for j = (i + 1):32
        % adj_mat��Ҫת�ɶ�ֵ����(0-1)
        rois_j = adj_mat_c(j, :);
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

%% �����߱�������ڵ�ĳ���
for i = 1:length(edges_ind)
    if length(edges_ind{i, 2}) == 2
        % ��һ��i�ڵ㣨����Ȩ�أ����ڵ��i,jȨ�غͣ���Ӧadj_mat��4���ߣ�
        edges_ind{i, 3} = sum(adj_mat_c(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_c(edges_ind{i, 1}(2), edges_ind{i, 2}));
        edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];
        
    else
        % ȡȨ�ؼ���������������û��i��j�ڵ㣩
        % i_com1 + i_com2Ȩ����������
        weight = adj_mat_c(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_c(edges_ind{i, 1}(2), edges_ind{i, 2});
        weight_with_ind = [edges_ind{i, 2}', weight'];
        weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');
        
        % ������������, �����м�һ�У����ڵ��i,jȨ�غ�(��Ӧadj_mat��6����)
        edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
        edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
    end
end

%% ���³���תΪ����
% ����32*32*32������
adj_ts_c = sptensor(repmat(32, 1, 3));
% ��ȥ�أ��ظ��ĸ���
% involves = edges_ind(:, 2);
% involves = unique(cell2mat(involves), 'rows');
for i = 1:length(edges_ind)
    % 3���ڵ㣬��6�����У�д��3*6������ѭ��
    inds = perms(edges_ind{i, 2})';
    for ind = inds
        % ����Ԫ�ض�ȡΪȨ��
        adj_ts_c(ind') = edges_ind{i, 3};
    end
end


%% ��P��ͬ���Ĳ���
edges_ind = cell(200, 3); % �洢�µĳ��ߣ�����C(32,2)= 496��
ind = 1; % �µıߵ�����

for i = 1:31
    rois_i = adj_mat_p(i, :);
    for j = (i + 1):32
        % adj_mat��Ҫת�ɶ�ֵ����(0-1)
        rois_j = adj_mat_p(j, :);
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

%% �����߱�������ڵ�ĳ���
for i = 1:length(edges_ind)
    if length(edges_ind{i, 2}) == 2
        % ��һ��i�ڵ㣨����Ȩ�أ����ڵ��i,jȨ�غͣ���Ӧadj_mat��4���ߣ�
        edges_ind{i, 3} = sum(adj_mat_p(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_p(edges_ind{i, 1}(2), edges_ind{i, 2}));
        edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];
        
    else
        % ȡȨ�ؼ���������������û��i��j�ڵ㣩
        % i_com1 + i_com2Ȩ����������
        weight = adj_mat_p(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat_p(edges_ind{i, 1}(2), edges_ind{i, 2});
        weight_with_ind = [edges_ind{i, 2}', weight'];
        weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');
        
        % ������������, �����м�һ�У����ڵ��i,jȨ�غ�(��Ӧadj_mat��6����)
        edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
        edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
    end
end

%% ���³���תΪ����
% ����32*32*32������
adj_ts_p = sptensor(repmat(32, 1, 3));
% ��ȥ�أ��ظ��ĸ���
% involves = edges_ind(:, 2);
% involves = unique(cell2mat(involves), 'rows');
for i = 1:length(edges_ind)
    % 3���ڵ㣬��6�����У�д��3*6������ѭ��
    inds = perms(edges_ind{i, 2})';
    for ind = inds
        % ����Ԫ�ض�ȡΪȨ��
        adj_ts_p(ind') = edges_ind{i, 3};
    end
end

% �������ڻ����������д�����
% Structure  'Tree_74' exported from Classification Learner. 
% To make predictions on a new predictor column matrix, X: 
%   yfit = Tree_74.predictFcn(X) 
% For more information, see How to predict using an exported model.



