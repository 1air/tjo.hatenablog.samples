function new_m=tjo_svm_trial(xvec,wvec,x_list,delta,bias,clength,kernel_choice)
% ���ۂɍ쐬���ꂽSVM�����֐�����e�X�g�M��xvec�̔��ʂ��s���֐��B
% ���ǃ}�[�W���v�Z���Ă��邾���B���������̓��͒萔�͐���ς݂�wvec��bias�B

wbyx=0;

for i=1:clength
    wbyx = wbyx+wvec(i)*tjo_kernel(xvec,x_list(:,i),delta,kernel_choice);
end;

new_m=wbyx+bias;

% ���łɌ���֐��l����Group 1 or 2�̂ǂ���ł��邩���R�}���h���C����ɕ\���B
if(new_m > 0)
    fprintf(1,'Group 1\n\n');
elseif(new_m < 0)
    fprintf(1,'Group 2\n\n');
else
    fprintf(1,'On the border\n\n');
end;

end