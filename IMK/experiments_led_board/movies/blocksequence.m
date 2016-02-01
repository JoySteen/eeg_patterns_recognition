% ���������� ������������������ ��������. ������� ���� �������. � ������
% ����� ������������ ��� ������� � ��������� �������. ���� � ��� �� ������
% �� ����� ���� ������ ��� ����� ����. ������ ��������� ���� ���������� ��
% �����������. ������ ��� � ������ � ���� �� ����������� ������������ ����
% � �� �� ��������������� ������������������.
%
% nStimuli - ���������� �������� 
% nCycles - ���������� ������
%
function sequence = blocksequence(nStimuli,nCycles)
rng default
sequence = zeros(1,nStimuli*nCycles);
for c = 1:nCycles
    while 1
        [~,inds] = sort(rand(1,nStimuli));
        if c == 1
            break
        end
        if all(inds==sequence((c-2)*nStimuli+(1:nStimuli)))
            continue
        end
        if sequence((c-1)*nStimuli) == inds(2)
            continue
        end
        if sequence((c-1)*nStimuli) == inds(1)
            continue
        end
        if sequence((c-1)*nStimuli-1) == inds(1)
            continue
        end
        break
    end
    sequence((c-1)*nStimuli+(1:nStimuli)) = inds;
end
return
