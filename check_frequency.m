%% ��֤Ƶ�ʷ�����������һ����λǰ��ı仯
% load('U_aver.mat') % ����U_aver��lambda
% load('adj_ts.mat')
dataSize = size(U_aver);
node_num = dataSize(1);


F = control_adj;
freq = U_aver; % Ƶ�ʷ�������
s1_all = zeros(size(freq)); % һ����λ�ź�

%% ��������Ƶ�ʷ�����һ����λ�źţ�s1_allÿ��Ϊһ��Ƶ�ʷ���
for i = 1:node_num
    f_i = freq(:, i);
    signal_shift = s_shift(F, f_i);
    s1_all(: ,i) = signal_shift;
end

% save('s1_all.mat', 's1_all');

%% �����ź�
col = 8;
s0 = s(:, col);
% s0 = [s0; zeros(36-node_num, 1)];
s0 = reshape(s0, 3,3);
matrixplot(s0, 'DisplayOpt','on', 'ColorBar','on');

s1 = s1_all(:, col);
% s1 = [s1; zeros(36-node_num, 1)];
s1 = reshape(s1, 3,3);
matrixplot(s1, 'ColorBar','on');
