function out=tjo_back_propagation(xvec,loop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �o�b�N�v���p�Q�[�V�����E�j���[�����l�b�g���[�N by Takashi J. OZAKI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ɒP���ȃo�b�N�v���p�Q�[�V�����E�j���[�����l�b�g���[�N(BP)�̎����ł��B
% �ȒP�̂��߂�3�w�i���͑w�E���ԑw1�E�o�͑w�j�\���ɂ��Ă���܂��B
% ���̂��ߔ���`�������̂��͉̂\�ł����AXOR�ɂ͑Ή����Ă��܂���B
% �iXOR�ɑΉ�������ɂ͒��ԑw������1�K�v�ł��j

% ��{�I�ɁABP�͂����܂ł��P�Ȃ�p�[�Z�v�g�����̉����ł��B
% �p�[�Z�v�g�����͓��͑w�E�o�͑w��2�w�����ŒP���Ȑ��`�������s���܂����A
% �Ԃɒ��ԑw������ł������Ƃŕ���𑝂₵�A����`�����ɑΉ��ł���悤��
% ���Ă��܂��B�u�o�b�N�v���p�Q�[�V�����v�i�t�`�d�j�̖��O�̒ʂ�A
% �o�͐M���Ƌ��t�M���Ƃ̍����璆�ԑw�Ȃ�тɓ��͑w�̊w�K���s���_��
% �ő�̓����ł��B

% ���w�I�ȗ��֐��̓s����A�����֐����p�[�Z�v�g������臒l�֐�(0 or 1)�ł͂Ȃ��A
% �V�O���C�h�֐��Ƃ��Ă��܂��B���̂��߁A�����������\�Ƀ�������������A
% �w�K�̎��������������肵�܂��BSVM�ɔ�ׂ���Y��ɔ���`�����ł��Ȃ����Ƃ�
% ���X����̂Œ��ӂ��K�v�ł��B

% �������ɂ͓��̓f�[�^�Ƃ���xy���W�ɉ����ăo�C�A�X���i�����ł͂�����1�j��
% �t�������K�v������A���͑w�`���ԑw�̎󂯓n���f�[�^�ɂ������o�C�A�X����
% �K�v�ɂȂ�܂��B

%%
%%%%%%%%%%%%%%%%%%%
% ���t�M���̃Z�b�g %
%%%%%%%%%%%%%%%%%%%
% ���̃X�N���v�g�ɓ������A1�����̃}�g���N�X�����o��ones�֐��ƁA
% 0-1�̗����̃}�g���N�X�����o��rand�֐��ƁArand()�ɏ悶��p�����[�^c�Ƃ�
% �g�ݍ��킹�œK���ɍ���Ă��܂��B

c=8;

% ��1�E2�E4�ی���x1�O���[�v
x1_list=[[(ones(1,10)+c*rand(1,10));(ones(1,10)+c*rand(1,10))] ...
    [(-1*ones(1,10)-c*rand(1,10));(ones(1,10)+c*rand(1,10))] ...
    [(ones(1,10)+c*rand(1,10));(-1*ones(1,10)-c*rand(1,10))]];
% ��3�ی���x2�O���[�v
x2_list=[-1*ones(1,15)-c*rand(1,15);-1*ones(1,15)-c*rand(1,15)];

c1=size(x1_list,2);
c2=size(x2_list,2);

% BP�ł͐������x���M����0 or 1�ŗ^���܂��B
y_list=[ones(c1,1);zeros(c2,1)];

clength=c1+c2;

% BP�ł̓o�C�A�X���i������1�j��t�������K�v�����邽�߁A3�s�ڂ�1���S�Ă̗��
% �΂��ĕt�������Ă���܂��B
x_list=[[x1_list x2_list];ones(1,clength)];

%%
%%%%%%%%%%%%%%%%%%%%%
% �e�평���p�����[�^ %
%%%%%%%%%%%%%%%%%%%%%
k=1.5; % �w�K�W��

% �d�݃x�N�g��
wvec=[rand(2,2);ones(1,2)]; % ��1�i�K�p
hvec=[rand(2,1);1]; % ��2�i�K�p / �����ł�2�i�K�����z�肵�ĂȂ�


%%
%%%%%%%%%%%%%
% �w�K�p�[�g %
%%%%%%%%%%%%%
% �ʂ̊֐��ɂ��Ă���܂��B
% 4�̊֐�����\������Ă���̂ŁA���ꂼ��̃R�����g���Q�Ƃ̂��ƁB
[wvec,hvec]=tjo_bp_train(wvec,hvec,x_list,y_list,clength,k,loop);

%%
%%%%%%%%%%%%%%%
% �e�X�g�p�[�g %
%%%%%%%%%%%%%%%

% ���̓x�N�g���Ƀo�C�A�X��1��3��ڂ̈ʒu�ɒǉ��B
xvec0=[xvec;1];
% ���̓x�N�g����2�̏d�݃x�N�g���Ɋ�Â��ďo�͒l���Z�o�B
out=tjo_bp_predict(xvec0,wvec,hvec);
% �V�O���C�h�֐��Ȃ̂ŁA0.5�𒴂������ۂ��Ŕ��ʂ���B
if(out>0.5)
    fprintf(1,'Group 1\n\n');
else
    fprintf(1,'Group 2\n\n');
end;
%%
%%%%%%%%%%%%%%%
% �����p�[�g %
%%%%%%%%%%%%%%%

figure;

for i=1:c1
    scatter(x_list(1,i),x_list(2,i),100,'black');hold on;
end;

for i=c1+1:c1+c2
    scatter(x_list(1,i),x_list(2,i),100,'black','+');hold on;
end;

if(out > 0.5)
    scatter(xvec(1),xvec(2),200,'red');hold on;
elseif(out < 0.5)
    scatter(xvec(1),xvec(2),200,'red','+');hold on;
else
    scatter(xvec(1),xvec(2),200,'blue');hold on;
end;

%%
[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        zz(p,q)=tjo_bp_predict([xx(p,q);yy(p,q);1],wvec,hvec);
    end;
end;

contour(xx,yy,zz,50);hold on;

xlim([-10 10]);
ylim([-10 10]);
end