sub1 = ROI_time_series(:,:,1);
roi1 = sub1(: ,1);

% ����
sub1(:,1)=0;
A = sub1;
[alpha, info] = lasso(A, roi1, 'Lambda', 0.05);

sparse_rep = A*alpha;
std_ori = std(roi1);
std_rep = std(sparse_rep);

%% ��ͼ
figure
plot(roi1)
hold on
plot(std_ori/std_rep*sparse_rep)
legend('ori', 'rep')

