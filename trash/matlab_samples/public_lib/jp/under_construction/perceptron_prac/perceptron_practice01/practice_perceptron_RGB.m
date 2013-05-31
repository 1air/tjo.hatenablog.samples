function [yvec,wvec]=practice_perceptron_RGB(xvec)

% RGB�l��f���Ƃ����P���f�[�^
% �g�F�n�J���[�Ȃ�1
% ���F�n�J���[�Ȃ�-1�𐳉����x���Ƃ���

x_list=[[255;0;0;1] [0;255;255;1] [0;255;0;1] [255;0;255;1] [0;0;255;1] [255;255;0;1]];
t_list=[1;-1;-1;1;-1;1];

% �P���p�[�g
wvec=[0;0;0;1]; % �����d�݃x�N�g��
loop=1000; % �P���̌J��Ԃ���

% Learning
for j=1:loop
    for i=1:6
        wvec=practice_train2(wvec,x_list(:,i),t_list(i));
    end;
    j=j+1;
end;

% xvec��[R;G;B;bias]�Ƃ���

% Trial
[t_label,yvec]=practice_predict2(wvec,xvec);
if(t_label>0)
    fprintf(1,'Warm color\n\n');
else
    fprintf(1,'Cool color\n\n');
end;


end