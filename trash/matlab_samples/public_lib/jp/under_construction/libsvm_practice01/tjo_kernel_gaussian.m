function k=tjo_kernel_gaussian(x1,x2,delta)
%%
% �K�E�V�A��RBF�J�[�l���֐��ł��B

norm_dat=norm(x1-x2); % 2�_�Ԃ̃m�������v�Z
abs_dat=(norm_dat)^2; % �m�����l�̓����v�Z
p=(abs_dat)/(2*(delta)^2); % �K�E�V�A���J�[�l����e^x��x�̕������Ɍv�Z

k=exp(-p); % �K�E�V�A���i�w���֐�e^x�j���Z�o�BJava�Ȃ�Math.exp�Ƃ��ɂȂ�͂��ł��B

end