function [wvec,bias]=tjo_train(wvec,bias,R,xvec,t_label)

% tjo_predict�֐���p���Ċw�K���s���Ă��܂��B
% y*t�̒l(= tw'x)�����̎��ɏd�݃x�N�g��w(wvec)���X�V���܂��B

L=0.3; % Learn_stlength: �w�K�W����

[out,yvec]=tjo_predict(wvec,bias,xvec);

if (yvec*t_label<=0)
    wvec=wvec+L*t_label*xvec;
    bias=bias+L*t_label*(R*norm(xvec));
end;

end