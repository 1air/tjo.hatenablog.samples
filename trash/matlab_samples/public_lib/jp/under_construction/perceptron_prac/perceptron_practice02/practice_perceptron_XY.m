function [yvec,wvec]=practice_perceptron_XY(xvec)

% xy���W�n�̒l��f���Ƃ����P���f�[�^
% �K���Ɍ��߂đ�1�W�c�Ȃ�1
% ��2�W�c�Ȃ�-1�𐳉����x���Ƃ���

x_list=[[1;1;1] [2;3;1] [2;1;1] [2;-1;1] [3;2;1] [1;-1;1] [0;1;1] [0;-1;1] [-1;2;1] [-1;-2;1]];
t_list=[1;1;1;-1;1;-1;-1;-1;-1;-1];

% �P���p�[�g
wvec=[0;0;1]; % �����d�݃x�N�g��
loop=1000; % �P���̌J��Ԃ���

% Learning
for j=1:loop
    for i=1:10
        wvec=practice_train(wvec,x_list(:,i),t_list(i));
    end;
    j=j+1;
end;

% xvec��[x;y;bias]�Ƃ���

% Trial
[t_label,yvec]=practice_predict(wvec,xvec);
if(t_label>0)
    fprintf(1,'Group 1\n\n');
else
    fprintf(1,'Group 2\n\n');
end;

figure;
x_fig=-6:0.1:6;
y_fig=-(wvec(2)/wvec(1))*x_fig-(wvec(3)/wvec(2));

plot(x_fig,y_fig);hold on;
scatter(x_list(1,:),x_list(2,:),50,'black');hold on;
scatter(xvec(1),xvec(2),50,'red');

end