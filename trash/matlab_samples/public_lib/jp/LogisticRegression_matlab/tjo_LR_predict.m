function yvec=tjo_LR_predict(xvec,wvec)
% ���ʊ֐��ł��B
% �ł��P�Ȃ�V�O���C�h�֐����Z�����Ă��邾���ł��B
% �ڍׂ�tjo_sigmoid�֐����Q�Ƃ̂��ƁB

yvec=tjo_sigmoid(dot(wvec,xvec));

end