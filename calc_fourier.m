%% �����źŵĸ���Ҷ�任
load('Data\\U_aver.mat');
load('COBRE_Data\\COBRE_32.mat');

%% ���ò��������㸵��Ҷ�任
% num_control �� num_patient �ڹ����ڽ�����ʱ����

num_subjects = size(ROI_time_series, 3);
num_node = size(ROI_time_series, 2);
s_fourier = zeros(num_node, num_subjects);

% ����������ĸ���Ҷ�任
for i = 1:num_control
    % ÿ�������ߵ�ʱ�����У�����*�ڵ���
%     timeseries = cell2mat(ROI_time_series(:, :, i));
    timeseries = ROI_time_series(:, :, i);
    % �����źŵĹ��ʣ���Ϊһ���������ź�
    power = mean(timeseries.^2); % ÿ����һ���������ź�,power��1*N
    
    % ʹ�þ���ֵ�ľ�ֵ
%     power = mean(abs(timeseries));

    % V ��[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_c';
    s_fourier(:, i) = (V * s).^2;
end

% ���㻼����ĸ���Ҷ�任
for i = num_control + 1:num_subjects
    % ÿ�������ߵ�ʱ�����У�����*�ڵ���
%     timeseries = cell2mat(ROI_time_series(:, :, i));
    timeseries = ROI_time_series(:, :, i);
    % �����źŵĹ��ʣ���Ϊһ���������ź�
    power = mean(timeseries.^2); % ÿ����һ���������ź�,power��1*N
    
    % ʹ�þ���ֵ�ľ�ֵ
%     power = mean(abs(timeseries));

    % V ��[f1 f2 f3 ... fN]^T
    s = power';
    V = U_aver_p';
    s_fourier(:, i) = (V * s).^2;
end

%% ���浽�ļ�
save('COBRE_fourier', 's_fourier');

%% ���浽�ļ�
save('OpenNEURO_fourier', 's_fourier');

%% ����Ҷ�任�����ͼ
figure

imagesc(s_fourier, [0, 20]);
colorbar;
% title('fourier transform')

%% ����ͼƬ
fig_name = 'fourier transform';
print(gcf, '-dpng', '-r300', fig_name);




