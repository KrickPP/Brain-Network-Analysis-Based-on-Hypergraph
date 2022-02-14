for i = 10:15
    sub_i = inc_mat(:,:,i);
    matrixplot(sub_i)
end


for i = 80:85
    sub_i = inc_mat(:,:,i);
    matrixplot(sub_i)
end

%% ��ʾ
figure
image(sub_i,'CDataMapping','scaled')
colorbar
axis tight

%% �ۼ��ٻ�ͼ
sub_i = zeros(32,32);
for i = 1:74
    sub_i = sub_i + inc_mat(:,:,i);
end

c_sum = sub_i;

sub_i = zeros(32,32);
for i = 75:145
    sub_i = sub_i + inc_mat(:,:,i);
end

p_sum = sub_i;


%% ��ֵ��
c_sum(abs(c_sum)<=1)=0;
p_sum(abs(p_sum)<=1)=0;
matrixplot(c_sum);
matrixplot(p_sum);

%% imagesc
figure
imagesc(c_sum, [-5,25])
colorbar()
title('control inc mat')

figure
imagesc(p_sum,  [-5,25])
colorbar()
title('patient inc mat')
%% ��ȡǰorder�����ϵ��
order = 4;
involves_c = cell(32,1);
for i = 1:32
    edge_sort = sort(c_sum(:, i), 'descend');
    min_coef = edge_sort(order); % ������order��ϵ��
    edge = c_sum(:, i);
    edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
    ind = find(edge); % ��������������������
    involves_c{i} = ind;
end


involves_p = cell(32,1);
for i = 1:32
    edge_sort = sort(p_sum(:, i), 'descend');
    min_coef = edge_sort(order); % ������order��ϵ��
    edge = p_sum(:, i);
    edge(edge < min_coef) = 0; % ��������ǰorder��ϵ��
    ind = find(edge); % ��������������������
    involves_p{i} = ind;
end


