function [new_m,alpha,bias,y_list]=tjo_svm_procedure_3d(xvec,delta,Cmax,loop)
%%
% SMO�����ς�

% �������������̂Ńo�O��茈�s
% �_���ڂƂ��ẮA
% 1. �J�[�l���𑽍����ɕς�����悤�ɂ���
% 2. �}�[�W���v�Z�ɉ��������̕s�������邩���Ȃ̂Ń`�F�b�N����
% 3. �P�ɍŌ��contour�`��ɕs�������邩���Ȃ̂Ŋm�F����

%%
% xy���W�n�̒l��f���Ƃ����P���f�[�^
% �K���Ɍ��߂đ�1�W�c�Ȃ�1
% ��2�W�c�Ȃ�-1�𐳉����x���Ƃ���

% x2_list=[[2;-1] [-1;3] [-3;2] [8;-8] [7;-7] [8;-1] [6;-1] ...
%     [-2;1] [2;-1] [3;-2] [4;-4] [1;-4] [-8;1] [1;-8] [-6;1] [1;-6] ...
%     [3;-5] [2;-2] [1;-2] [-4;4] [1;-5]];
% x1_list=[[-1;-1] [0;-1] [0;-2] [-1;-2] [-1;-3] [-3;-3] [-4;0] ...
%     [-3;-1] [-5;0] [-8;-2] [-2;-8] [0;-4] [0;-5] [0;-6] [-6;0] [-5;0] ...
%     [0;-2] [-3;-4] [-4;-3] [-2;-2] [1;1] [2;3] [2;1] [3;2] [5;5] ...
%     [7;1] [6;1] [7;7] [6;6] [1;5] [1;6] [4;1] [3;1] [5;1] [1;3] [1;4] ...
%     [3;6] [6;3]];
% x1_list=[[1;1] [2;1] [3;1] [4;1] [1;4] [2;4] [3;4] [4;4] ...
%     [-1;1] [-2;1] [-3;1] [-4;1] [-1;4] [-2;4] [-3;4] [-4;4] ...
%     [-1;-1] [-2;-1] [-3;-1] [-4;-1] [-1;-4] [-2;-4] [-3;-4] [-4;-4]];
% x2_list=[[1;-1] [2;-1] [3;-1] [4;-1] [1;-4] [2;-4] [3;-4] [4;-4]];

x1_list=[[ones(1,15)+1.5*rand(1,15);ones(1,15)+1.5*rand(1,15);2*ones(1,15)+1.5*rand(1,15)] ... % ��1�ی���
    [-1*ones(1,15)+1.5*rand(1,15);ones(1,15)+1.5*rand(1,15);-2*ones(1,15)+1.5*rand(1,15)] ... % ��2�ی���
    [-1*ones(1,15)+1.5*rand(1,15);-1*ones(1,15)+1.5*rand(1,15);2*ones(1,15)+1.5*rand(1,15)] ... % ��3�ی���
    [ones(1,15)+1.5*rand(1,15);-1*ones(1,15)+1.5*rand(1,15);-2*ones(1,15)+1.5*rand(1,15)]]; ... % ��4�ی���
    
x2_list=[[ones(1,15)+1.5*rand(1,15);ones(1,15)+1.5*rand(1,15);-2*ones(1,15)+1.5*rand(1,15)] ... % ��1�ی���
    [-1*ones(1,15)+1.5*rand(1,15);ones(1,15)+1.5*rand(1,15);2*ones(1,15)+1.5*rand(1,15)] ... % ��2�ی���
    [-1*ones(1,15)+1.5*rand(1,15);-1*ones(1,15)+1.5*rand(1,15);-2*ones(1,15)+1.5*rand(1,15)] ... % ��3�ی���
    [ones(1,15)+1.5*rand(1,15);-1*ones(1,15)+1.5*rand(1,15);2*ones(1,15)+1.5*rand(1,15)]]; ... % ��4�ی���

x_list=[x1_list x2_list];

[r1,c1]=size(x1_list);
[r2,c2]=size(x2_list);
y_list=[ones(c1,1);-1*ones(c2,1)];

clength=c1+c2;
%%
% �P���p�[�g
alpha=zeros(c1+c2,1);
% loop=1000; % �P���̌J��Ԃ���
learn_stlength=0.5;

%%
% alpha�𐄒肷��B������SVM��training�̊�
% for i=1:loop
    [alpha,bias]=tjo_smo(x_list,y_list,alpha,delta,Cmax,clength,learn_stlength,loop);
% end;

%%
% bias�𐄒肷��

% bias=tjo_svm_bias_estimate(x_list,y_list,alpha,delta,clength,Cmax);

% bias=0;

%%
% ���ފ������������

wvec=tjo_svm_classifier(y_list,alpha,clength);


%%
% ���ނ��Ă݂�(Trial / Testing)

new_m=tjo_svm_trial(xvec,wvec,x_list,delta,bias,clength);


%%
% ���܂��ŉ���

% [xx,yy]=meshgrid(-5:.1:5,-5:.1:5);
% zz=-(a/c)*xx-(b/c)*yy-(d/c);
h=figure;
% mesh(xx,yy,zz);hold on;
for i=1:c1
    if(alpha(i)==0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,'black');hold on;
    elseif(alpha(i)>0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,[127/255 0 127/255]);hold on;
    end;
end;

for i=c1+1:c1+c2
    if(alpha(i)==0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,'black','+');hold on;
    elseif(alpha(i)>0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,[127/255 0 127/255],'+');hold on;
    end;
end;

if(new_m > 0)
    scatter3(xvec(1),xvec(2),xvec(3),600,'red');hold on;
elseif(new_m < 0)
    scatter3(xvec(1),xvec(2),xvec(3),600,'red','+');hold on;
else
    scatter3(xvec(1),xvec(2),xvec(3),600,'blue');hold on;
end;

xlim([-3 3]);
ylim([-3 3]);
zlim([-4 4]);

[xx,yy,zz]=meshgrid(-3:0.1:3,-3:0.1:3,-3:0.1:3);
[cxx,cxx,cxx]=size(xx);
mm=zeros(cxx,cxx,cxx);
V=[];
for p=1:cxx
    for q=1:cxx
        for r=1:cxx
            mm(p,q,r)=tjo_svm_trial_silent([xx(p,q,r);yy(p,q,r);zz(p,q,r)],wvec,x_list,delta,bias,clength);
            if(abs(mm(p,q,r))<1)
                V=[V [xx(p,q,r);yy(p,q,r);zz(p,q,r)]];
            end;
        end;
    end;
end;

scatter3(V(1,:),V(2,:),V(3,:),5,'green','+');hold on;

end