function [W_rf, F_rf, H_eq] = Analog_SMSE2(H, Nt, Nr, Ns, K, Q, beta, rho)
% H_eq_k = W_rf_k' * H_k * F_rf;
%  DFT�뱾��Ϊ�ɹ������ģ������Q_codebook
%  ʵ�ֶ������������;
%%
Mt = K * Ns; Mr = Ns; 

if length(Nr) == 2
    Nr_total = Nr(1) * Nr(2);
    Nt_total = Nt(1) * Nt(2);
else
    Nr_total = Nr;
    Nt_total = Nt;
end

DFT_set_r = Q_codebook(Nr, Q(1), rho); DFT_set_t = Q_codebook(Nt, Q(2), rho); % transmit and recieve codebook

len_r = size(DFT_set_r, 2); len_t = size(DFT_set_t, 2);
temp = zeros(len_r * K, len_t);
for i = 1 : K
    temp(((i - 1) * len_r + 1) : (i * len_r), :) ...
        = abs(DFT_set_r' * H(:, :, i) * DFT_set_t); % enery matrix
end

W_rf = zeros(Nr_total, Mr, K); F_rf = zeros(Nt_total, Mr, K); 
count_k = zeros(1, K); %��Ӧ�û��ۼƼ�¼�����ﵽ�û����������ޣ����û�����
for i = 1 : Mt
    pos = find(temp == max(max(temp)));
    if length(pos) >= 2 % ���ֶ�����ֵ��ͬ�����
        pos = pos(1);
    end
    pos_r = mod(pos, K * len_r);% ȷ���û����뱾λ��
    if pos_r == 0 % ��pos = K * len_rʱ
        pos_r = K * len_r;
    end
    k = ceil(pos_r / len_r); pos_rk = mod(pos_r, len_r);
    if pos_rk == 0 % ��pos_r = len_rʱ
        pos_rk = len_r;
    end
    pos_t = ceil(pos / (K * len_r));% ȷ����վ�뱾λ��pos_t���û�k�뱾λ��pos_rk

    temp(pos_r, :) = 0; % ��Ӧλ�����㣬�С��С��û�
    temp(:, pos_t) = 0;
    count_k(k) = count_k(k) + 1;  
    [val_k, pos_k] = max(count_k);
    
    dft_t_temp = abs(DFT_set_t(:, pos_t)' * DFT_set_t); % ��վȥ������Խ�ǿ���뱾
    dft_t_pos = dft_t_temp > beta;
    temp(:, dft_t_pos) = 0;
    
    dft_r_temp = abs(DFT_set_r(:, pos_rk)' * DFT_set_r); % �û���ȥ������Խ�ǿ���뱾
    dft_r_pos = find(dft_r_temp > beta);
    temp((k - 1) * len_r + dft_r_pos, :) = 0;
    
    if count_k(k) == 0
        error('������������(Nr, Nt)�������뱾����Խ�ǿ��a��');
    end
        
    W_rf(:, count_k(k), k) = DFT_set_r(:, pos_rk);
    F_rf(:, count_k(k), k) = DFT_set_t(:, pos_t); 
    if val_k >= Ns
        count_k(pos_k) = -1;
        temp(((pos_k - 1) * len_r + 1) : (pos_k * len_r), :) = 0;
    end
end

H_eq = zeros(Mr, Mt, K);
F_rf2 = reshape(F_rf, Nt_total, Mt);
for m = 1 : K
    H_eq(:, :, m) = W_rf(:, :, m)' * H(:, :, m) * F_rf2;
end