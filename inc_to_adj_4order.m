function adj_ts = inc_to_adj_4order(inc_mat)
    % ��������תΪ�ڽ�����
    % inc_mat: ��������
    % adj_ts: �ڽ�����

    % ����order����������ÿ�����order���ڵ�
    order = 4;
    dataSize = size(inc_mat);
    node_num = dataSize(1); % �ڵ���
    edge_num = dataSize(2); % ����(���ڽڵ����)
    involves = cell(edge_num, 1); % edge_num��Ԫ�飬�洢ÿ�����漰�Ľڵ�
    edge = zeros(edge_num, 1); % ԭʼ�ĵ�j����
    edge_sort = zeros(edge_num, 1); % �����ĵ�j����

    %% ��ÿ���ߴ�����������ķ���Ԫ���±�
    % ��ȡǰorder�����ϵ��
    for i = 1:edge_num
        edge_sort = sort(inc_mat(:, i), 'descend');
        min_coef = edge_sort(order); % ������order��ϵ��
        edge = inc_mat(:, i);
        edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
        ind = find(edge); % ��������������������
        involves{i} = ind;
    end

    % �������������䵽order��
    involve_add = zeros(order, 1); % ��ӵ�11������
    edge_length = zeros(edge_num, 1); % �߰��������ĸ���

    for i = 1:edge_num
        edge_length(i) = length(involves{i});

        if edge_length(i) == order
            continue;
        end

        if edge_length(i) <= order / 2 % ��������һ��Ļ��ظ�
            pick = randperm(order - edge_length(i));
            ind = find(pick > edge_length(i));
            pick(ind) = mod(pick(ind), edge_length(i));
            ind = pick == 0;
            pick(ind) = edge_length(i);
        else
            pick = randperm(edge_length(i), order - edge_length(i)); % ���ѡȡM-c��
        end

        pick_add = involves{i}(pick); % ��ӳ�11��
        involves{i}(edge_length(i) + 1:order) = pick_add;

    end

    %% �����ڽ�������ʹ��ϡ����������Ϊ��ͨ�����洢��Ҫ����Ŀռ䣩
    inds_cell = cell(edge_num, 1); % ʹ��Ԫ�鱣������

%     % ��ʽһ����ʹ���漰�ıߵ�����
%     for i = 1:edge_num
%         inds = perms(involves{i}); % �漰���ıߵ�����
%         inds = unique(inds, 'rows'); % ȥ��
%         inds_cell{i, 1} = inds; % ����Ԫ��
% 
%         % fprintf('the %3dth edge.\n', i)
%     end

% 	% ��ʽ��������ȫ������
%     i_all = 1;
%     for i = 1:edge_num
%         ind_i = involves{i};
%         for i1 = 1:order
%             for i2 = 1:order
%                 for i3 = 1:order
%                     inds_cell{i_all, 1} = [ind_i(i1), ind_i(i2), ind_i(i3)];
%                     i_all = i_all + 1;
%                 end
%             end
%         end
%     end

    % 4������
    i_all = 1;
    for i = 1:edge_num
        ind_i = involves{i};
        for i1 = 1:order
            for i2 = 1:order
                for i3 = 1:order
                    for i4 = 1:order
                        inds_cell{i_all, 1} = [ind_i(i1), ind_i(i2), ind_i(i3), ind(i4)];
                        i_all = i_all + 1;
                    end
                end
            end
        end
    end

	% ת�ɾ���ȥ��
    inds = unique(cell2mat(inds_cell), 'rows');

    %% �����ڽ�����Ԫ�ص�ֵ
    adj_ts = sptensor(repmat(node_num, 1, order));
    ele_num = 0; % һ�������в�ͬ�����ĸ���
    factor = 6; % Ԫ��ֵ����

%     for i = 1:size(inds, 1)
%         ele_num = length(unique(inds(i, :)));
%         
%         switch ele_num
%             case 3
%                 adj_ts(inds(i, :)) = 1/2 * factor;
%             case 2
%                 adj_ts(inds(i, :)) = 1/3 * factor;
%             case 1
%                 adj_ts(inds(i, :)) = 1 * factor;
%         end
% 
%     end

    % 4������
    for i = 1:size(inds, 1)
        ele_num = length(unique(inds(i, :)));
        
        switch ele_num
            case 4
                adj_ts(inds(i, :)) = 1/6 * factor;
            case 3
                adj_ts(inds(i, :)) = 1/12 * factor;
            case 2
                adj_ts(inds(i, :)) = 1/16 * factor;
            case 1
                adj_ts(inds(i, :)) = 1 * factor;
        end

    end

end
