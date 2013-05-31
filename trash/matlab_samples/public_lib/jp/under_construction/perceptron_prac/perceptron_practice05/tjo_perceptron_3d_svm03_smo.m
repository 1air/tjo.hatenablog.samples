function [new_m,alpha,bias]=tjo_perceptron_3d_svm03_smo(xvec)
%%
% SMO����

%%
% xy���W�n�̒l��f���Ƃ����P���f�[�^
% �K���Ɍ��߂đ�1�W�c�Ȃ�1
% ��2�W�c�Ȃ�-1�𐳉����x���Ƃ���

x1_list=[[1;1] [2;3] [2;1] [2;-1] [3;2] [5;5] [-1;3] [-3;2] ...
    [-2;1] [2;-1] [3;-2] [4;-4] [1;-4] [-8;1] [1;-8] [-6;1] [1;-6] ...
    [3;-5] [2;-2] [1;-2] [-4;4] [1;-5]];
x2_list=[[-1;-1] [0;-1] [0;-2] [-1;-2] [-1;-3] [-3;-3] [-4;0] ...
    [-3;-1] [-5;0] [-8;-2] [-2;-8] [0;-4] [0;-5] [0;-6] [-6;0] [-5;0] ...
    [0;-2] [-3;-4] [-4;-3] [-2;-2]];
x_list=[x1_list x2_list];

[r1,c1]=size(x1_list);
[r2,c2]=size(x2_list);
y_list=[ones(c1,1);-1*ones(c2,1)];

clength=c1+c2;
%%
% �ϐ��ݒ�p�[�g
alpha=zeros(c1+c2,1);
e_list=zeros(c1+c2,1);
% loop=1000; % �P���̌J��Ԃ���
learn_stlength=1.5;

%%
% alpha�𐄒肷��B������SVM��training�̊�

% ������SMO�Ɋ�������I�I

alpha=tjo_smo(x_list,y_list,e_list,alpha,delta,Cmax,loop,clength,learn_stlength);

%%
% bias�𐄒肷��

bias=tjo_svm_bias_estimate_smo(x_list,y_list,alpha,delta,clength);

% bias=0;

%%
% ���ނ��Ă݂�(Trial / Testing)

new_m=tjo_svm_trial_smo(xvec,x_list,y_list,alpha,delta,bias);


%%
% ���܂��ŉ���

% [xx,yy]=meshgrid(-5:.1:5,-5:.1:5);
% zz=-(a/c)*xx-(b/c)*yy-(d/c);
h=figure;
% mesh(xx,yy,zz);hold on;
scatter(x_list(1,1:c1),x_list(2,1:c1),100,'black');hold on;
scatter(x_list(1,c1+1:c1+c2),x_list(2,c1+1:c1+c2),100,'black','+');hold on;
if(new_m > 0)
    scatter(xvec(1),xvec(2),100,'red');
elseif(new_m < 0)
    scatter(xvec(1),xvec(2),100,'red','+');
else
    scatter(xvec(1),xvec(2),100,'blue');
end;
xlim([-10 10]);
ylim([-10 10]);

end