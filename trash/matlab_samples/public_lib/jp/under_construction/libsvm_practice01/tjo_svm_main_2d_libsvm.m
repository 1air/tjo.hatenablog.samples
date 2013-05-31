function model=tjo_svm_main_2d_libsvm(xvec,sigma,Cmax)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �T�|�[�g�x�N�^�[�}�V��2�����o�[�W���� by Takashi J. OZAKI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �������V���v���Ȏ����ł��B�Œ���̋@�\�Ƃ��āA
% 1) 3��ށi���^�E�������E�K�E�V�A��RBF�j�̃J�[�l���ɂ�����^����
% 2) SMO�iSequential Minimal Optimization: �����ŏ��œK���j
% 3) ���t�M��x_list�������_���Ɏ擾�i2��������������XOR�p�^�[���j
% 4) ���t�M��x_list�ƃe�X�g�M��xvec�̃v���b�g�A�T�|�[�g�x�N�^�[�̋����\��
% 5) ���������ʂ̃R���^�[�i�������j�\��
% ���������Ă���܂��B
% 
% ������[new_m,alpha,bias,linear_index]=tjo_svm_2d_main_procedure([4;4],4,2,100)��
% �R�}���h���C����Ŏ��s���Ă݂ĉ������B�Y���XOR�����p�^�[�����\������܂��B
% xvec�F�e�X�g�M����xy���W�i��x�N�g��[x;y]�Ŏw��j
% delta�F�J�[�l���̕ϐ��i�{���̓�:sigma�ł����߂�Ȃ����j
% Cmax�F�\�t�g�}�[�W��SVM�ɂ�����KKT�����p�����[�^C
% loop�FSMO���������Ȃ��ꍇ�̎��s�񐔂̑ł��؂����i���ꂪ�Ȃ��Ɩ������[�v����j
% 
% Matlab�͔��Ƀ��[�Y�Ȍ���ł��B�x�[�X�Ƃ��Ă͂ق�C���ꂻ�̂��̂ł��B
% C�������[�Y�ŁA�Ⴆ�Εϐ��錾�͈�ؗv��܂���i����������������
% zeros�֐��őS�v�f�[���̃x�N�g��or�s������j�B
% Java�⑼����ɈڐA����ۂ͂��̕ӂ����Ă�����ŁA�����܂ł��A���S���Y����
% ���`�Ƃ��Ă����p�������B
% 
% �Ȃ��A�u2�����o�[�W�����v�ƃ^�C�g�������Ă���܂����A
% �s��v�Z���̂ɕ��Ր����������Ă���܂��̂�3�����ł�4�����ł�n�����ł�
% �v�Z���ׂ�����������΂�����ł��g���ł��܂��i�������v���b�g�͖����ł����j�B
% 
% �ڂ��������ɂ��Ắw�T�|�[�g�x�N�^�[�}�V������x�i�ʏ̐Ԗ{�j�����Q�Ɖ������B
% ���肪�����Ŏ����Ă���܂��̂ŁA���݂��������܂��B

%%
%%%%%%%%%%%%%%%%%
% ���t�M���̐ݒ� %
%%%%%%%%%%%%%%%%%

% ones�֐��őS�v�f1�̍s���K���ɍ��A������rand�֐��ł΂����^���Ă��܂��B
% c��rand�֐��ɏ悶�邱�ƂŁA�΂���̑傫����ς��邱�Ƃ��ł��܂��B
% �e�M����xy���W���x�N�g���ŕ\���Ă��܂��B
% �s�����ɂ��ꂼ���xy���W����ׂĂ����C���[�W�ł��B
% �ǂ���̋��t�M����I�Ԃ����A�K�X�R�����g�A�E�gor�����Ō��߂ĉ������B
% �E�N���b�N���j���[�̒��Ɉꊇ�R�����g�A�E�gor�����̋@�\������܂��B

t=6;
c=7;
d=50;

% 2����������^�p�^�[���F��1�E2�E4�ی���x1�A��3�ی��̂�x2
% x1_list=[[(ones(1,d)+c*rand(1,d));(ones(1,d)+c*rand(1,d))] ...
%     [(-1*ones(1,d)-c*rand(1,d));(ones(1,d)+c*rand(1,d))] ...
%     [(ones(1,d)+c*rand(1,d));(-1*ones(1,d)-c*rand(1,d))]];
% x2_list=[-1*ones(1,d)-c*rand(1,d);-1*ones(1,d)-c*rand(1,d)];

% XOR����^�p�^�[���F��2�E4�ی���x1�A��1�E3�ی���x2
% x1_list=[[(-1*ones(1,d)-c*rand(1,d));(ones(1,d)+c*rand(1,d))] ...
%     [(ones(1,d)+c*rand(1,d));(-1*ones(1,d)-c*rand(1,d))]];
% x2_list=[[(ones(1,d)+c*rand(1,d));(ones(1,d)+c*rand(1,d))] ...
%     [-1*ones(1,d)-c*rand(1,d);-1*ones(1,d)-c*rand(1,d)]];

% XOR����^�p�^�[���F������Ɩ��W�����Ă݂�
x1_list=[[(-t*ones(1,d)+c*rand(1,d));(t*ones(1,d)-c*rand(1,d))] ...
    [(t*ones(1,d)-c*rand(1,d));(-t*ones(1,d)+c*rand(1,d))]];
x2_list=[[(t*ones(1,d)-c*rand(1,d));(t*ones(1,d)-c*rand(1,d))] ...
    [-t*ones(1,d)+c*rand(1,d);-t*ones(1,d)+c*rand(1,d)]];

c1=size(x1_list,2); % x1_list�̗v�f��
c2=size(x2_list,2); % x2_list�̗v�f��
clength=c1+c2; % �S�v�f���F���̌㖈��Q�Ƃ��邱�ƂɂȂ�܂��B

% ����M���Fx1��x2�Ƃŕ����������̂ŁA�Ή�����C���f�b�N�X��1��-1������U��܂��B
x_list=[x1_list x2_list]; % x1_list��x2_list���s�����ɕ��ׂĂ܂Ƃ߂܂��B
y_list=[ones(c1,1);-1*ones(c2,1)]; % ����M����x1:1, x2:-1�Ƃ��ė�x�N�g���ɂ܂Ƃ߂܂��B

pause on;

figure(1); % �v���b�g�E�B���h�E��1���
scatter(x1_list(1,:),x1_list(2,:),100,'ko');hold on;
scatter(x2_list(1,:),x2_list(2,:),100,'k+');
xlim([-10 10]);
ylim([-10 10]);

pause(2);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIBSVM�Ŋw�K�ƕ��ނ������؂�ɂ���Ă��܂� %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param_str = sprintf('-s %d -t %d -g %d -c %d',0,2,sigma,Cmax);

% model = svmtrain(y_list, x_list', '-s 0 -t 2 -g 0.5 -c 10');
model = svmtrain(y_list, x_list', param_str);
[predicted_label,accuracy,prob_estimates] = svmpredict(1, xvec',model, '');

new_m=predicted_label;

%%
%%%%%%%%%%%%%%%%%%%%%
% �����i�v���b�g�j %
%%%%%%%%%%%%%%%%%%%%%
% Matlab�ő�̕���ł�������p�[�g�B
% �R�����g�̂Ȃ��Ƃ���͓K�XMatlab�w���v�����Q�Ɖ������B

figure(2); % �v���b�g�E�B���h�E��1���

for i=1:c1 % ���t�M��x1�����ꂼ��v���b�g����
    scatter(x_list(1,i),x_list(2,i),100,'black');hold on;
end;

for i=c1+1:c1+c2 % ���t�M��x2�����ꂼ��v���b�g����
    scatter(x_list(1,i),x_list(2,i),100,'black','+');hold on;
end;

if(new_m > 0) % �e�X�g�M��xvec��Group 1�Ȃ�Ԃ����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red');hold on;
elseif(new_m < 0) % �e�X�g�M��xvec��Group 2�Ȃ�Ԃ��{�Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red','+');hold on;
else % �e�X�g�M��xvec�����ꕪ�������ʏ�Ȃ�����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'blue');hold on;
end;

% �v���b�g�͈͂�x,y�Ƃ���[-10 10]�̐����`�̈���ɐݒ�
xlim([-10 10]);
ylim([-10 10]);

echo off;

% �R���^�[�i�������j�v���b�g�B����̂ŏڍׂ�Matlab�w���v�����Q�Ɖ������B
[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        [zz(p,q),ac,prob]=svmpredict(1,[xx(p,q);yy(p,q)]',model,'');
    end;
end;
contour(xx,yy,zz,[-1 0 1]);
title('LIBSVM result');

pause off;

%%
%%%%%%%%%%%%%%%%%%%%%
% ���ތ��ʂ�\������ %
%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'\n\nClassification result\n');

if(new_m>0)
    fprintf(1,'\n\nGroup 1\n\n');
elseif(new_m<0)
    fprintf(1,'\n\nGroup 2\n\n');
end;

end