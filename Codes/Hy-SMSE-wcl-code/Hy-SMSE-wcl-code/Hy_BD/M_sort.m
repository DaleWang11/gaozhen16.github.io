function [M_k, norm1] = M_sort(H_k, D, D_len, Mr)
% �������ÿ���û���W����
% D �뱾
% D_len �뱾��С
% norm1 �洢ÿ��d * H�ķ��������(��phase�����)
%%
dH_norm = zeros(2,D_len); % �洢ÿ��d * H�ķ��������
for i = 1 : D_len
    A = D(:, i)' * H_k;   
    dH_norm(1, i) = norm(A,'fro');
end
dH_norm(2, :) = (1 : D_len);
norm1 = dH_norm(1, :);

% ����(ð������, ����)
for i = 1 : D_len
    for j = 1 : (D_len - i)
        if dH_norm(1,j) < dH_norm(1,j + 1)
            a = dH_norm(:,j);
            dH_norm(:,j) = dH_norm(:,j + 1);
            dH_norm(:,j + 1) = a;
        end
    end
end
M_k = zeros(length(D(:, 1)), Mr);
for i = 1 : Mr
    M_k(:, i) = D(:,dH_norm(2, i));
end
