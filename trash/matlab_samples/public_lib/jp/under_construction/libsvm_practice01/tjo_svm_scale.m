function out=tjo_svm_scale(data)

% �g���ꍇ��[training_vector input_signal]�Ƃ��đS�̂��܂Ƃ߂Đ��K�����Ă���
% ���input_signal�����o���Ă��Ȃ��ƁA���K���덷��������̂ŗv����

out = data - repmat(min(data,[],1),size(data,1),1)*spdiags(1./(max(data,[],1)-min(data,[],1))',0,size(data,2),size(data,2));

end