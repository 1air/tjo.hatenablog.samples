function [out,yvec]=tjo_predict(wvec,bias,xvec)

% �P�Ɏ��ʊ֐� y = w'x���v�Z���Ă��邾���ł��B
% out��y�̒l�𐳋K�����������ł��B

yvec=dot(wvec,xvec)+bias; % dot�֐��i���όv�Z�j���g���Ă��܂��B����wvec'*xvec�ł��B

out=sign(yvec); % sign�֐����g���Ă��܂��B������sgn(x)�ł��B

end