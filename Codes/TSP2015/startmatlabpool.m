function [] = startmatlabpool(size)
 
p = gcp('nocreate');    % p��ȡ������û�в��г�������
if isempty(p)
    poolsize = 0;
else
    poolsize = p.NumWorkers     % poolsize �ǹ����ҵ���Ŀ
end

if poolsize == 0    % ���poolsize==0����Ҫ������ʹ��parpool('local',size)������
    if nargin == 0
        parpool('local');
    else
        try
            parpool('local',size);
        catch ce
            parpool;
            fail_p = gcp('nocreate');
            fail_size = fail_p.NumWorkers;
            display(ce.message);
            display(strcat('�����size����ȷ�����õ�Ĭ������size=',num2str(fail_size)));
        end
    end
else
    display('parpool start');   % ��Ȼ����������˫�˵����size����Ϊ3���Ǿͳ��쳣�ˣ�Ϊ�˴�������쳣�������ʱӦ�ú��������size��ֱ��ʹ�ñ���Ĭ�ϵ�����
    if poolsize ~= size
        closematlabpool();
        startmatlabpool(size);
    end
end

% ����һ����������㵱ǰ�Ѿ��й����������е����㻹��Ҫ�������Ǿ�ֻ�ܰѵ�ǰ�Ĺر���Ȼ���ٴ���
