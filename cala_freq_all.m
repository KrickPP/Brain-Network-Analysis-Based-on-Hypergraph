
%% �����˵�ƽ����������
inc_aver = mean(inc_mat, 3);

% �����˵�ƽ���ڽ�����
adj_all = inc_to_adj(inc_aver);


%% �ֽ� �����˵��ڽ�����
order = 32;

[T, fit] = CP_ORTHO(adj_all, order);
T_full = full(T);
% save(sprintf('T_%.2f.mat', fit), 'T') % ���ֽ���T���浽�ļ�

% ���adj_ts�ǳ��ԳƵģ�U{i} 32*order��������Ӧ�����
% �ֽ���ÿ��ȷʵ������ȣ������������ȡ��ֵ
U = T.U;
lambda_all = T.lambda;
U_aver_all = (U{1} + U{2} + U{3}) / 3;


%% ���������˵ĸ���Ҷ�任
dataSize = size(ROI_time_series);
numSubjects = dataSize(3);
num_node = dataSize(2);
s_fourier = zeros(num_node, numSubjects);

for i = 1:numSubjects
    % ÿ�������ߵ�ʱ�����У�����*�ڵ���
    timeseries = ROI_time_series(:, :, i);

    % �����źŵĹ��ʣ���Ϊһ���������ź�
    power = mean(timeseries.^2); % ÿ����һ���������ź�,power��1*N
    
    % ʹ�þ���ֵ�ľ�ֵ
%     power = mean(abs(timeseries));

    % V ��[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_all';
    s_fourier(:, i) = (V * s).^2;
end


%% ����Ҷ�任�����ͼ
figure
imagesc(s_fourier, [0,18]);
colorbar;
title('fourier transform')


%% ��������
label = [zeros(74, 1); ones(71,1)];
cobre_all = [s_fourier', label];






