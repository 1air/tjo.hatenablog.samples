function [new_m1,new_m2,alpha,bias,linear_index]=tjo_svm_main_compare(xvec,delta,Cmax,loop,kernel_choice)
%%
%%%%%%%%%%%%%%%%%
% ���t�M���̐ݒ� %
%%%%%%%%%%%%%%%%%

t=6;
c=7;
d=50;

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
% �v���b�g�͈͂�x,y�Ƃ���[-10 10]�̐����`�̈���ɐݒ�
xlim([-10 10]);
ylim([-10 10]);

pause(2);

%%
%%%%%%%%%%%%%%%%%
% �e�ϐ��̏����� %
%%%%%%%%%%%%%%%%%
% zeros�֐��őS�v�f0�̃x�N�g�������B

% ���O�����W���搔���i�ڍׂ͐Ԗ{�Q�Ƃ̂��Ɓj
alpha=zeros(clength,1);
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

[alpha,bias]=tjo_smo(x_list,y_list,alpha,delta,Cmax,clength,learn_stlength,loop,kernel_choice);

% ���O�����W���搔alpha�ƃo�C�A�Xbias�̗����������ɋ��܂�B
% ����ŕ����֐��ɕK�v�Ȓ萔���S�ē���ꂽ���ƂɂȂ�B

%%
%%%%%%%%%%%%%%%%%%%%%%%
% �����֐������������� %
%%%%%%%%%%%%%%%%%%%%%%%
% �����֐��̎Z�o�ɕK�v��w�x�N�g��(wvec)�����߂�B
% wvec�͐���M��y_list�Ɛ���ς݃��O�����W���搔alpha��2���狁�܂�B

wvec=tjo_svm_classifier(y_list,alpha,clength);

% wvec��bias�𕪗��֐�tjo_svm_trial�ɓ��͂���΁A�e�X�g���s���\�B


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ނ��Ă݂�(Trial / Testing) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ۂɐ���ς݂�wvec��bias��2�萔���番���֐����\�����A
% �e�X�g�M��xvec�ɑ΂��錈��֐��lnew_m�����߂�B
% new_m > 0�Ȃ�x1��(Group 1)�Anew_m < 0�Ȃ�x2��(Group 2)�Ɣ��肳���B
% �֐�tjo_svm_trial�̓R�}���h���C���ɔ��茋�ʂ̕\�����s���B

new_m1=tjo_svm_trial(xvec,wvec,x_list,delta,bias,clength,kernel_choice);

% SMO���r���ł��؂�ɂȂ����ꍇ�ɔ����āA���^����alpha*y_list = 0��
% �������Ă��邩�ǂ������v�Z����B
linear_index=y_list'*alpha;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LIBSVM�Ŋw�K�ƕ��ނ������؂�ɂ���Ă��܂� %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% param_str = sprintf('-s %d -t %d -g %d -c %d',0,2,1/delta,Cmax);
param_str = sprintf('-s %d -t %d',0,2);

% model = svmtrain(y_list, x_list', '-s 0 -t 2 -g 0.5 -c 10');
model = svmtrain(y_list, x_list', param_str);
[predicted_label,accuracy,prob_estimates] = svmpredict(1, xvec',model, '');

new_m2=predicted_label;
%%
%%%%%%%%%%%%%%%%%%%%%
% �����i�v���b�g�j %
%%%%%%%%%%%%%%%%%%%%%
% Matlab�ő�̕���ł�������p�[�g�B
% �R�����g�̂Ȃ��Ƃ���͓K�XMatlab�w���v�����Q�Ɖ������B

figure(2); % �v���b�g�E�B���h�E��1���

for i=1:c1 % ���t�M��x1�����ꂼ��v���b�g����
    if(alpha(i)==0) % �����֐��Ɗ֌W�Ȃ���΍������Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,'black');hold on;
    elseif(alpha(i)>0) % �T�|�[�g�x�N�^�[�Ȃ率�F�́��Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,[127/255 0 127/255]);hold on;
    end;
end;

for i=c1+1:c1+c2 % ���t�M��x2�����ꂼ��v���b�g����
    if(alpha(i)==0) % �����֐��Ɗ֌W�Ȃ���΍����{�Ńv���b�g
        scatter(x_list(1,i),x_list(2,i),100,'black','+');hold on;
    elseif(alpha(i)>0) % �T�|�[�g�x�N�^�[�Ȃ率�F�́{�Ńv���b�g
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
cxx=size(xx,1);
cyy=size(yy,2);
zz=zeros(cxx,cyy);
for p=1:cxx
    for q=1:cyy
        out=tjo_svm_trial_silent([xx(p,q);yy(p,q)],wvec,x_list,delta,bias,clength,kernel_choice);
        zz(p,q)=sign(out);
    end;
end;
contour(xx,yy,zz,[-1 0 1]);
title('My own code result');

%%
figure(3); % �v���b�g�E�B���h�E��1���

for i=1:c1 % ���t�M��x1�����ꂼ��v���b�g����
    scatter(x_list(1,i),x_list(2,i),100,'black');hold on;
end;

for i=c1+1:c1+c2 % ���t�M��x2�����ꂼ��v���b�g����
    scatter(x_list(1,i),x_list(2,i),100,'black','+');hold on;
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

fprintf(1,'\n\nMy own code result\n');
if(new_m1>0)
    fprintf(1,'\n\nGroup 1\n\n');
elseif(new_m1<0)
    fprintf(1,'\n\nGroup 2\n\n');
end;

fprintf(1,'\n\nLIBSVM result\n');
if(new_m2>0)
    fprintf(1,'\n\nGroup 1\n\n');
elseif(new_m2<0)
    fprintf(1,'\n\nGroup 2\n\n');
end;


end