function k=tjo_kernel(x1,x2,delta,kernel_choice)
%%
% �P��3��ނ̃J�[�l���̒�����I��ł��邾���̊֐��ł��B
% �ォ��K�E�V�A��RBF�A���^�A�������ł��B

if(kernel_choice==0)
    k=tjo_kernel_gaussian(x1,x2,delta);
elseif(kernel_choice==1)
    k=tjo_kernel_linear(x1,x2);
elseif(kernel_choice==2)
    k=tjo_kernel_polynomial(x1,x2,delta);
end;

end