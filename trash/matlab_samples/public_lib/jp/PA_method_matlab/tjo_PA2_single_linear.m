function [wvec,margin]=tjo_PA2_single_linear(xvec,Cmax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Passive-Aggressive(PA)�@���ފ� by Takashi J . OZAKI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gmail�̎�M�g���C�̗D��x����ɂ��g���Ă���A
% Passive-Aggresive(PA)�@�ɂ�镪�ފ�̔��ɒP���Ȏ����R�[�h�ł��B
% ���̃T���v���ł͐��^��l�����������{���Ă��܂��񂪁A
% ���ۂɂ̓}�[�W���v�Z�̑��N���X���ɂ���đ��N���X���ނ��\�ł��B
% �܂��v�Z�������╡�G���������܂����A�J�[�l���g���b�N��p����
% ����`�������s�����Ƃ��\�ł��B

% PA�@�̍ő�̓����́A�ʏ�̐��^���ފ�Ƃ͈قȂ�A�d�݃x�N�g����
% �X�V�K���Ɋւ��ă}�[�W���̑召���l���ɓ����悤�ɂ��Ă���܂��B
% �����u�\���ɕ��������ʂ��痣��Ă��ꂻ���Ȃ�d�݃x�N�g���͍X�V���Ȃ��v
% �u������x���������ʂ���߂���΍X�V����v�̓�{���Ăœ����܂��B
% ����āA�����̕����ɉ�������̃O���f�[�V���������Ă�邱�ƂŁA
% �e�Ղɑ��N���X���ł���킯�ł��B

% PA�@�ɂ͂��������V������܂����A���̃T���v���ł͍ł����������
% ����PA2�@��p���Ă��܂��BPA2�@�ł�SVM���l�Ƀ}�[�W���X���b�N�ϐ���
% �������Ă���̂ŁA�n�C�p�[�p�����[�^�Ƃ���Cmax���w�肷��K�v������܂��B

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% ���t�M���̃Z�b�e�B���O %
%%%%%%%%%%%%%%%%%%%%%%%%%
% ���^��l�����̃T���v���Ȃ̂ŁA�P���p�[�Z�v�g�����Ɠ����ݒ�ɂ��Ă���܂��B

% �T���v���̂΂�������w��
c=4;

% ones�֐��őS�v�f1�̃x�N�g�������Arand�֐���[0-1]�����_���ȃx�N�g�������A
% 2�����킹�đ�1�E3�ی��Ƀ����_���ɕ��z����2�̋��t�M���O���[�v�����܂��B
x1_list=[(ones(1,15)+c*rand(1,15));(ones(1,15)+c*rand(1,15))]; % ��1�ی�
x2_list=[-1*ones(1,15)-c*rand(1,15);-1*ones(1,15)-c*rand(1,15)]; % ��3�ی�

c1=size(x1_list,2); % x1_list�̗v�f��
c2=size(x2_list,2); % x2_list�̗v�f��
clength=c1+c2; % �S�v�f���F���̌㖈��Q�Ƃ��邱�ƂɂȂ�܂��B

% �������x���M���Fx1��x2�Ƃŕ����������̂ŁA�Ή�����C���f�b�N�X��1��-1������U��܂��B
x_list=[x1_list x2_list]; % x1_list��x2_list���s�����ɕ��ׂĂ܂Ƃ߂܂��B
y_list=[ones(c1,1);-1*ones(c2,1)]; % ����M����x1:1, x2:-1�Ƃ��ė�x�N�g���ɂ܂Ƃ߂܂��B

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% �e��p�����[�^�̏����� %
%%%%%%%%%%%%%%%%%%%%%%%%%
% �d�݃x�N�g���̓[���Ő��K�����Ă����܂��B2�����Ȃ̂�2x1�x�N�g���ł��B
wvec=zeros(2,1);
% �J��Ԃ��v�Z�񐔂̏���B
loop=1000;

%%
%%%%%%%%%%%%%%%%%%%%%
% �d�݃x�N�g���̊w�K %
%%%%%%%%%%%%%%%%%%%%%
% �ڍׂ�tjo_PA2_train�֐��̃R�����g�����Q�Ƃ̂��ƁB

wvec = tjo_PA2_train(wvec,x_list,y_list,Cmax,loop);

%%
%%%%%%%%%%%%%%%%%%%
% �e�X�g�M���̔��� %
%%%%%%%%%%%%%%%%%%%
% �}�[�W�����v�Z���A���̕����œ�l�N���X���ނ��s���܂��B
margin = tjo_PA2_predict(wvec,xvec);

if(sign(margin)==1)
    fprintf(1,'Group 1\n\n');
elseif(sign(margin)==-1)
    fprintf(1,'Group 2\n\n');
else
    fprintf(1,'On the border\n\n');
end;

%%
%%%%%%%%%%%%%%%
% �����p�[�g %
%%%%%%%%%%%%%%%
% Matlab���C�u�������炯�Ȃ̂ŁA�����܂ł��Q�l�܂łɁB�B�B

figure(1);

for i=1:c1
    scatter(x1_list(1,i),x1_list(2,i),100,'ko');hold on;
end;
for i=1:c2
    scatter(x2_list(1,i),x2_list(2,i),100,'k+');hold on;
end;

scatter(xvec(1),xvec(2),300,'rs');hold on;

xlim([-10 10]);
ylim([-10 10]);

[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        for i=1:4
            zz(p,q)=tjo_PA2_predict(wvec,[xx(p,q);yy(p,q)]);
        end;
    end;
end;

contour(xx,yy,zz,[-1 0 1]);hold on;

end