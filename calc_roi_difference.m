% Ѱ���������������������

% һ�Բ�������
threshold = 0.005;
p_thre = p_s < threshold;
figure
imagesc(p_thre, [0,1])
colorbar
[roi1, roi2] = find(p_thre);

% ���ҳ��ִ�����������
roi_all = [roi1; roi2];
count = tabulate(roi_all);
% count��1����������ţ���2���ǳ��ֵĴ��������ڵڶ��У���ÿ�н�������
count_sort = sortrows(count, 2, 'descend');
roi_most = count_sort(1:8, :);

%%
figure
control_inc_aver(control_inc_aver <0) = 0;
imagesc(control_inc_aver, [0,0.5])
colorbar
title('Control Group Incidence Matrix')

figure
patient_inc_aver(patient_inc_aver <0) = 0;
imagesc(patient_inc_aver, [0,0.5])
colorbar
title('Patient Group Incidence Matrix')

