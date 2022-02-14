%% ����µĳ���
% ����1 ���ڽӾ������ҳ�ͬʱ�������������Ĺ�������
edges_ind = cell(200, 3); % �洢�µĳ��ߣ�����C(32,2)= 496��
adj_all = cell(145, 1); % �洢�����˵��³���
ind = 1; % �µıߵ�����

% ���ڽӾ����ֵ��
thre = 0.5;

for sub = 1:145
    adj_mat = adj_mat_all(:, :, sub);
    adj_mat(adj_mat < thre) = 0;
    adj_mat(logical(eye(32))) = 0; % �Խ���Ԫ������

    for i = 1:31
        rois_i = adj_mat(i, :);

        for j = (i + 1):32
            % adj_mat��Ҫת�ɶ�ֵ����(0-1)
            rois_j = adj_mat(j, :);
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
            edges_ind{i, 3} = sum(adj_mat(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat(edges_ind{i, 1}(2), edges_ind{i, 2}));
            edges_ind{i, 2} = [edges_ind{i, 1}(1), edges_ind{i, 2}];

        else
            % ȡȨ�ؼ���������������û��i��j�ڵ㣩
            % i_com1 + i_com2Ȩ����������
            weight = adj_mat(edges_ind{i, 1}(1), edges_ind{i, 2}) ...
            + adj_mat(edges_ind{i, 1}(2), edges_ind{i, 2});
            weight_with_ind = [edges_ind{i, 2}', weight'];
            weight_with_ind_sort = sortrows(weight_with_ind, 2, 'descend');

            % ������������, �����м�һ�У����ڵ��i,jȨ�غ�(��Ӧadj_mat��6����)
            edges_ind{i, 2} = weight_with_ind_sort(1:3, 1)';
            edges_ind{i, 3} = sum(weight_with_ind_sort(1:3, 2));
        end

    end

    %% ���³���תΪ����
    % ����32*32*32������
    adj_ts = sptensor(repmat(32, 1, 3));
    % ��ȥ�أ��ظ��ĸ���
    % involves = edges_ind(:, 2);
    % involves = unique(cell2mat(involves), 'rows');
    for i = 1:length(edges_ind)
        % 3���ڵ㣬��6�����У�д��3*6������ѭ��
        inds = perms(edges_ind{i, 2})';

        for ind = inds
            % ����Ԫ�ض�ȡΪȨ��
            adj_ts(ind') = edges_ind{i, 3};
        end

    end

    adj_all{sub} = adj_ts;

end


%% ÿ�����±� ����Ҷ�任
rank = 32; % 32��
num_subjects = 145;
num_node = 32;
T_all = cell(num_subjects, 1);
lambda_all = zeros(num_node, num_subjects);
U_aver_all = zeros(num_node, num_node, num_subjects);

parfor i = 1:num_subjects
    [T_all{i}, fit] = CP_ORTHO(adj_all{i}, rank);

    % ����������ȡƽ��
    U = T_all{i}.U;
    lambda_all(:, i) = T_all{i}.lambda;
    U_aver_all(:, :, i) = (U{1} + U{2} + U{3}) / 3;
    
    fprintf('The %3dth subject CP_ORTHO Done.\n', i);
    
end

save('New_edges\T_all', 'T_all');
save('New_edges\lambda_all', 'lambda_all');
save('New_edges\U_aver_all', 'U_aver_all');
fprintf('All Subjects CP_ORTHO Done and Saved.\n');

%% ÿ���˶����㸵��Ҷ�任
s_fourier = zeros(num_node, num_subjects);

parfor i = 1:num_subjects
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
imagesc(lambda_all, [0, 20]);
colorbar;
title('fourier transform')

%% ��������
label = [zeros(74, 1); ones(71, 1)];
cobre_train = [s_fourier', label];