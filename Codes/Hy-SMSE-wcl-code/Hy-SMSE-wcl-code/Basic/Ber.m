function R = Ber(Ns, K, W_bb, W_rf, F_bb, F_rf, H, S, msg, N_frame, noise, mod_obj, demod_obj)
% �����������
Mt = K * Ns; % Mr = Ns; Pt = Mt;
Nt_total = length(F_rf(:, 1, 1));

F_bb2 = reshape(F_bb, Mt, K * Ns);%��ά����תΪ��ά����
F_rf2 = reshape(F_rf, Nt_total, Mt);
symbol = modulate(mod_obj, msg);
Scale = modnorm(symbol,'avpow',1);
Symbol_nomalized = reshape(Scale * symbol, K * Ns, N_frame); % ��һ��
y = [];
for m = 1 : K
    W_bb_k = W_bb(:, :, m);
    W_rf_k = W_rf(:, :, m);
    H_k = H(:, :, m);
    S_k = (diag(S(((m - 1) * Ns + 1) : (m * Ns)))) ^ (- 1);
    y = [y; S_k * W_bb_k' * W_rf_k' * (H_k * F_rf2 * F_bb2 * ...
        Symbol_nomalized + noise)];
end

Symbol_hat = reshape(y / Scale, K * Ns * N_frame, 1);  %�����ڷ����ϵĵ���ʱ����Ҫ���Ƿ���
msg_hat = demodulate(demod_obj, Symbol_hat);
R = sum(msg_hat ~= msg);