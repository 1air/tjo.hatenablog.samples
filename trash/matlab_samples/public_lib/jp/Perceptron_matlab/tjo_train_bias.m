function wvec=tjo_train_bias(wvec,xvec,t_label)

% tjo_predict�֐���p���Ċw�K���s���Ă��܂��B
% y*t�̒l(= tw'x)�����̎��ɏd�݃x�N�g��w(wvec)���X�V���܂��B

[out,yvec]=tjo_predict_bias(wvec,xvec);

if (yvec*t_label<=0)
    wvec=wvec+t_label*xvec;
end;

end