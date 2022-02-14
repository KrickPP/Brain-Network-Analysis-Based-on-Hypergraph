dataSize = size(ROI_time_series);
num_subjects = dataSize(3);

power=zeros(num_subjects, 32);

for i = 1:num_subjects
    % ÿ�������ߵ�ʱ�����У�����*�ڵ���
    timeseries = ROI_time_series(:, :, i);

    % �����źŵĹ��ʣ���Ϊһ���������ź�
%     power(i, :) = mean(timeseries.^2); % ÿ����һ���������ź�,power��1*N
    
    % ʹ�þ���ֵ�ľ�ֵ
     power(i,:) = mean(abs(timeseries));

%     % V ��[f1 f2 f3 ... fN]^T
%     s = power';
%     V = U_aver_c';
%     s_fourier(:, i) = (V * s).^2;
end

%% ��������
label = [zeros(74, 1); ones(71,1)];
cobre_power = [power, label];
