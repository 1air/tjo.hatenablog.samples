function [alpha1,alpha2,wvec1,wvec2,linear_id1,linear_id2]=tjo_svm_2d_main_procedure_half(xvec,delta,Cmax,loop)
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
c=5;
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

pause(5);

%%
%%%%%%%%%%%%%%%%%
% �e�ϐ��̏����� %
%%%%%%%%%%%%%%%%%
% zeros�֐��őS�v�f0�̃x�N�g�������B

% ���O�����W���搔���i�ڍׂ͐Ԗ{�Q�Ƃ̂��Ɓj
alpha1=zeros(clength,1);
alpha2=zeros(clength,1);
% �w�K�W���i����܂��ڍׂ͐Ԗ{�Q�Ƃ̂��ƁF�ʏ�0-2���炢�Ɏ��߂�j
learn_stlength=0.5;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���O�����W���搔���̐��聕SMO %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ł̓��𐄒肷�遁�w�K���[�`���B
% SMO��p���āA��alpha*y_list = 0�Ȃ���^����𖞂����Ȃ���A
% �Ȃ�����KKT�����𖞑����郿�𐄒肷��Ƃ�����2���œK�����������B
% �i�킩��Ȃ���ΐԖ{��ǂ݂܂��傤�I�j

% KKT�����Ɋ�Â��ă��O�����W������搔�@���������߂ɂ́A
% ���t�M��x_list�A����M��y_list�A���������������̃��O�����W���搔alpha�A
% �J�[�l���̌`��萔delta�i�{���̓Ђł����߂�Ȃ����j�A
% �S�v�f���̒lclength�A�w�K�W��learn_stlength�ASMO�ł��؂�����loop�A
% ���K�v�ɂȂ�B�ڍׂ�tjo_smo�̋L�q���Q�Ƃ̂��ƁB

[alpha1,bias1]=tjo_smo(x_list,y_list,alpha1,delta,Cmax,clength,learn_stlength,loop);

alpha2=tjo_svm_half_train(x_list,y_list,alpha2,delta,Cmax,loop,clength,learn_stlength);
bias2=0;

% ���O�����W���搔alpha�ƃo�C�A�Xbias�̗����������ɋ��܂�B
% ����ŕ����֐��ɕK�v�Ȓ萔���S�ē���ꂽ���ƂɂȂ�B

% max_m=0;min_m=0;
% 
% for i=1:clength
%     m=tjo_margin(x_list(:,i),x_list,alpha,y_list,delta,clength);
%     if(y_list(:,i)==-1 && m > max_m)
%         max_m=m;
%     end;
%     if(y_list(:,i)==1 && m < min_m)
%         min_m=m;
%     end;
% end;
% 
% bias = (max_m+min_m)/2;

%%
%%%%%%%%%%%%%%%%%%%%%%%
% �����֐������������� %
%%%%%%%%%%%%%%%%%%%%%%%
% �����֐��̎Z�o�ɕK�v��w�x�N�g��(wvec)�����߂�B
% wvec�͐���M��y_list�Ɛ���ς݃��O�����W���搔alpha��2���狁�܂�B

wvec1=tjo_svm_classifier(y_list,alpha1,clength);
wvec2=tjo_svm_classifier(y_list,alpha2,clength);

% wvec��bias�𕪗��֐�tjo_svm_trial�ɓ��͂���΁A�e�X�g���s���\�B


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ނ��Ă݂�(Trial / Testing) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ۂɐ���ς݂�wvec��bias��2�萔���番���֐����\�����A
% �e�X�g�M��xvec�ɑ΂��錈��֐��lnew_m�����߂�B
% new_m > 0�Ȃ�x1��(Group 1)�Anew_m < 0�Ȃ�x2��(Group 2)�Ɣ��肳���B
% �֐�tjo_svm_trial�̓R�}���h���C���ɔ��茋�ʂ̕\�����s���B

fprintf(1,'\n\nSMO result\n');
new_m1=tjo_svm_trial(xvec,wvec1,x_list,delta,bias1,clength);
fprintf(1,'Half (incomplete procedure) result\n');
new_m2=tjo_svm_trial(xvec,wvec2,x_list,delta,bias2,clength);

linear_id1=alpha1'*y_list;
linear_id2=alpha2'*y_list;

% SMO���r���ł��؂�ɂȂ����ꍇ�ɔ����āA���^����alpha*y_list = 0��
% �������Ă��邩�ǂ������v�Z����B

%%
%%%%%%%%%%%%%%%%%%%%%
% �����i�v���b�g�j %
%%%%%%%%%%%%%%%%%%%%%
% Matlab�ő�̕���ł�������p�[�g�B
% �R�����g�̂Ȃ��Ƃ���͓K�XMatlab�w���v�����Q�Ɖ������B

figure(2); % �v���b�g�E�B���h�E��1���

for i=1:c1 % ���t�M��x1�����ꂼ��v���b�g����
    if(alpha1(i)==0) % �����֐��Ɗ֌W�Ȃ���΍������Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,'black');hold on;
    elseif(alpha1(i)>0) % �T�|�[�g�x�N�^�[�Ȃ率�F�́��Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,[127/255 0 127/255]);hold on;
    end;
end;

for i=c1+1:c1+c2 % ���t�M��x2�����ꂼ��v���b�g����
    if(alpha1(i)==0) % �����֐��Ɗ֌W�Ȃ���΍����{�Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,'black','+');hold on;
    elseif(alpha1(i)>0) % �T�|�[�g�x�N�^�[�Ȃ率�F�́{�Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,[127/255 0 127/255],'+');hold on;
    end;
end;

if(new_m1 > 0) % �e�X�g�M��xvec��Group 1�Ȃ�Ԃ����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red');hold on;
elseif(new_m1 < 0) % �e�X�g�M��xvec��Group 2�Ȃ�Ԃ��{�Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red','+');hold on;
else % �e�X�g�M��xvec�����ꕪ�������ʏ�Ȃ�����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'blue');hold on;
end;

% �v���b�g�͈͂�x,y�Ƃ���[-10 10]�̐����`�̈���ɐݒ�
xlim([-10 10]);
ylim([-10 10]);

% �R���^�[�i�������j�v���b�g�B����̂ŏڍׂ�Matlab�w���v�����Q�Ɖ������B
[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        zz(p,q)=tjo_svm_trial_silent([xx(p,q);yy(p,q)],wvec1,x_list,delta,bias1,clength);
    end;
end;
contour(xx,yy,zz,[-1 0 1]);
title('SMO result');

figure(3); % �v���b�g�E�B���h�E��1���

for i=1:c1 % ���t�M��x1�����ꂼ��v���b�g����
    if(alpha2(i)==0) % �����֐��Ɗ֌W�Ȃ���΍������Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,'black');hold on;
    elseif(alpha2(i)>0) % �T�|�[�g�x�N�^�[�Ȃ率�F�́��Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,[127/255 0 127/255]);hold on;
    end;
end;

for i=c1+1:c1+c2 % ���t�M��x2�����ꂼ��v���b�g����
    if(alpha2(i)==0) % �����֐��Ɗ֌W�Ȃ���΍����{�Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,'black','+');hold on;
    elseif(alpha2(i)>0) % �T�|�[�g�x�N�^�[�Ȃ率�F�́{�Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,[127/255 0 127/255],'+');hold on;
    end;
end;

if(new_m2 > 0) % �e�X�g�M��xvec��Group 1�Ȃ�Ԃ����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red');hold on;
elseif(new_m2 < 0) % �e�X�g�M��xvec��Group 2�Ȃ�Ԃ��{�Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red','+');hold on;
else % �e�X�g�M��xvec�����ꕪ�������ʏ�Ȃ�����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'blue');hold on;
end;

% �v���b�g�͈͂�x,y�Ƃ���[-10 10]�̐����`�̈���ɐݒ�
xlim([-10 10]);
ylim([-10 10]);

% �R���^�[�i�������j�v���b�g�B����̂ŏڍׂ�Matlab�w���v�����Q�Ɖ������B
[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        zz(p,q)=tjo_svm_trial_silent([xx(p,q);yy(p,q)],wvec2,x_list,delta,bias2,clength);
    end;
end;
contour(xx,yy,zz,[-1 0 1]);
title('Half (incomplete) result');

pause off;

figure(4);hist(alpha1);
figure(5);hist(alpha2);

end