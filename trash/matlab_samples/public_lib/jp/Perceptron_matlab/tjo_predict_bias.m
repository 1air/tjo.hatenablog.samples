function [out,yvec]=tjo_predict_bias(wvec,xvec)

% �P�Ɏ��ʊ֐� y = w'x���v�Z���Ă��邾���ł��B
% out��y�̒l�𐳋K�����������ł��B

yvec=dot(wvec,xvec); % dot�֐��i���όv�Z�j���g���Ă��܂��B����wvec'*xvec�ł��B

out=sign(yvec); % sign�֐����g���Ă��܂��B������sgn(x)�ł��B

end