function s1 = s_shift(F, s)
    % hypergraph shifting
    % 1 step shift

    node_num = length(s);
    s1 = zeros(node_num, 1); % һ����λ�ź�
    [inds, ~] = find(F);
    
    for i = 1:node_num
        slice_i = inds(:, 1) == i; % ��һ������Ϊi
        inds_i = inds(slice_i, :); % ��һ������Ϊi��F��
        s1(i) = sum(F(inds_i) .* s(inds_i(:, 2)) .* s(inds_i(:, 3)));
    end

end
