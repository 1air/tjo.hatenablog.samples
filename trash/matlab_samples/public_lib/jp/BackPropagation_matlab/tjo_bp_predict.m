function out=tjo_bp_predict(xvec,wvec,hvec)
% �P�Ȃ�e�X�g�p�֐��ł��B
% tjo_1st_step�œ��͑w�`���ԑw�Ԃ̒l���o���A
% tjo_2nd_step�ŏo�͑w�̍ŏI�I�ȏo�͂��o���Ă��܂��B

gvec=tjo_1st_step(xvec,wvec);
out=tjo_2nd_step(gvec,hvec);

end