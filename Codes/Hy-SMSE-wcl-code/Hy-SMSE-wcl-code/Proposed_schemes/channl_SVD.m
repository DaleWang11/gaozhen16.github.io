function V_BD = channl_SVD(H_eq, K, Ns)
% �����ŵ�SVD�ֽ� ,����V�ĳ�ʼ�������V_BD
%%
Mt = K * Ns; Mr = Ns;
% % K * Mr, Mt
% H_eq2 = zeros(K * Mr, Mt);
% for m = 1 : K
%     H_eq2(((m - 1) * Mr + 1) : (m * Mr), :) = H_eq(:, :, m);
% end
% 
% V_BD = [];%����V
% for m = 1 : K
%     % define H_
%     if m == 1
%         H_ = H_eq2(Mr * m + 1 : end,:);
%     else
%         H_1 = H_eq2(1 : Mr * (m - 1),:);
%         H_2 = H_eq2(Mr * m + 1 : end,:);
%         H_ = [H_1 ; H_2];
%     end
%    
%     % ����SVD�ֽ�
%     [~,~,V1] = svd(H_);
%     V1_ = V1(:,K * Mr - Mr + 1 : end);
%     H_k = H_eq2(m * Mr - Mr + 1 : m * Mr,:);  %��k�û��ĵ�Ч�ŵ�
%     [U1,~,~] = svd(H_k * V1_); 
%     V1 = U1(:,1 : Ns).';  % �Ѿ�ȡ�˹���ת�ã����Ժ��治����
% %     if iseye == 1
% %         V1 = eye(Ns, Ns);
% % %         disp('iseye = 1\n');
% %     else
% % %         disp('iseye = 0\n');
% %     end
%     % V_BD = diag(V_1,V_2,...,V_K)
%     if m == 1
%         B = zeros(Ns,(K - 1) * Mr);
%         V_k = [V1 B]; 
%     elseif m == K
%         A = zeros(Ns,(K - 1) * Mr);
%         V_k = [A V1]; 
%     else
%         A = zeros(Ns,(m - 1) * Mr);
%         B = zeros(Ns,(K - m) * Mr);
%         V_k = [A V1 B]; 
%     end
%     V_BD = [V_BD ; V_k];
% end
V_BD = eye(Mt, Mt);