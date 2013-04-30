function wvec = tjo_PA2_train(wvec,x_list,y_list,Cmax,loop)
% �q���W�����֐��Ɋ�Â��āA�d�݃x�N�g��wvec�̍X�V���𕪊򂳂��Ă��܂��B
% PA�@�ɂ����āA�q���W�����֐�lt��
%
% lt = 0 (y*w'*x >= 1) or 1-(y*w'*x) (else)
%
% �ƒ�`����܂��B����lt�ɑ΂��A�d�݃x�N�g��w(t)�̍X�V����PA2�@�ł�
%
% w(t+1) = w(t) + tau * y(t) * x(t)
% �i������x(t)�͋��t�M���Ay(t)�͐������x���M���A
%  tau = lt / (||x(t)||^2 + 1/2C)�Ƃ���j
%
% �ƕ\����܂��B��������������̂����L�̃R�[�h�ł��B

cl=size(x_list,2);

for i=1:loop
    for j=1:cl
        if(y_list(j)*(dot(wvec,x_list(:,j)))>=1)
            lt=0;
        else
            lt=1-(y_list(j)*(dot(wvec,x_list(:,j))));
        end;
        tau=lt/((norm(x_list(:,j)))^2+(0.5/Cmax));
        wvec = wvec + tau*y_list(j)*x_list(:,j);
    end;
end;

end