function [wvec_new,nE,H]=tjo_LR_train(wvec,x_list,y_list,clength)
% �w�K���ł��B
% ��E(w)��H = �ށ�E(w)�����߂āA��������w���X�V���܂��B
% ���ꂼ��A
% 
% ��E(w) = ��(y_n-t_n)*x_n
% H = ��y_n*(1-y_n)*x_n*x_n'
% 
% �Ƌ��܂�܂��B����d�݃x�N�g��w�̍X�V����
% 
% w_new = w_old - inverse(H)*��E(w)
% �iinverse()�͋t�s�񉉎Z�j
% 
% �Ȃ�IRLS�@�ɏ]���ŋ}�~���@�`�b�N�Ȍ`�ŕ\����܂��B
% �Ȃ��A�㎮�̒ʂ�t�s��̉��Z���K�v�ƂȂ邽�߁A
% Java�Ȃǂł͐��`�㐔���Z�̃��C�u������p�ӂ���K�v������܂��B
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

nE=[0;0;0]; % ��E(w)�̏�����
H=[0 0 0;0 0 0;0 0 0]; % H = �ށ�E(w)�̏�����
wvec_new=[1;1;1]; % w�̏������i�o�C�A�X�v�Z������������̂Ŏ�����1�����j
wvec_old=wvec; % w_old�̏�����

while (norm(wvec_new-wvec_old)/norm(wvec_old) > 0.01)   % �ł��؂��͏d�݃x�N�g��w�̕ω��ʂ�10%�ȉ��ɂȂ������ł��B
    for j=1:clength
        nE=nE+(tjo_sigmoid(wvec_old'*x_list(:,j))-y_list(j))*x_list(:,j);
        H=H+y_func(wvec_old,x_list(:,j))*(1-y_func(wvec_old,x_list(:,j)))*x_list(:,j)*(x_list(:,j))';
    end;
    wvec_new=wvec_old-(inv(H))*nE;  % �����ɋt�s�񉉎Z�̂��߂̐��`�㐔���C�u�������K�v�ƂȂ�܂��B
    wvec_old=wvec_new; % �ł��؂��v�Z�̂��߂�w�̒l�����Z�̑O��ŕێ����Ă����܂��B
end

end