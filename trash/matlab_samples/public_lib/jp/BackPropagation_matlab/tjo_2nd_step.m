function out=tjo_2nd_step(gvec,hvec)

% gvec��3�����x�N�g��
% hvec��3�����x�N�g��
% out�̓X�J���[

param=gvec(1)*hvec(1)+gvec(2)*hvec(2)+gvec(3)*hvec(3);

out=tjo_sigmoid(param);

end