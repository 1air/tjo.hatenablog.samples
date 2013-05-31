function [yvec,wvec]=tjo_perceptron_3d(xvec)

% xyz���W�n�̒l��f���Ƃ����P���f�[�^
% �K���Ɍ��߂đ�1�W�c�Ȃ�1
% ��2�W�c�Ȃ�-1�𐳉����x���Ƃ���

x_list=[[1;1;1;1] [2;3;1;1] [2;1;1;1] [2;-1;1;1] [3;2;1;1] [-1;-1;-1;1] [0;-1;0;1] [0;-1;-1;1] [-1;-2;-1;1] [-1;-2;-3;1]];
t_list=[1;1;1;1;1;-1;-1;-1;-1;-1];

% �P���p�[�g
wvec=[0;0;0;1]; % �����d�݃x�N�g��
loop=1000; % �P���̌J��Ԃ���

% Learning
for j=1:loop
    for i=1:10
        wvec=tjo_train(wvec,x_list(:,i),t_list(i));
    end;
    j=j+1;
end;

% xvec��[x;y;bias]�Ƃ���

% Trial
[t_label,yvec]=tjo_predict(wvec,xvec);
if(t_label>0)
    fprintf(1,'Group 1\n\n');
else
    fprintf(1,'Group 2\n\n');
end;

a=wvec(1);
b=wvec(2);
c=wvec(3);
d=wvec(4);

[xx,yy]=meshgrid(-5:.1:5,-5:.1:5);
zz=-(a/c)*xx-(b/c)*yy-(d/c);
figure;
mesh(xx,yy,zz);hold on;
scatter3(x_list(1,1:5),x_list(2,1:5),x_list(3,1:5),500,'black');hold on;
scatter3(x_list(1,6:10),x_list(2,6:10),x_list(3,6:10),500,'black','+');hold on;
scatter3(xvec(1),xvec(2),xvec(3),500,'red');

end