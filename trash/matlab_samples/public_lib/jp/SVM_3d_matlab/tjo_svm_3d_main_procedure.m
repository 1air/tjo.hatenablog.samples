function [new_m,alpha,bias,linear_index]=tjo_svm_3d_main_procedure(xvec,delta,Cmax,loop)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �T�|�[�g�x�N�^�[�}�V��3�����o�[�W���� by Takashi J. OZAKI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �������V���v���Ȏ����ł��B�Œ���̋@�\�Ƃ��āA
% 1) 3��ށi���^�E�������E�K�E�V�A��RBF�j�̃J�[�l���ɂ�����^����
% 2) SMO�iSequential Minimal Optimization: �����ŏ��œK���j
% 3) ���t�M��x_list�������_���Ɏ擾�i2��������������XOR�p�^�[���j
% 4) ���t�M��x_list�ƃe�X�g�M��xvec�̃v���b�g�A�T�|�[�g�x�N�^�[�̋����\��
% 5) ���������ʂ̃R���^�[�i�������j�\��
% ���������Ă���܂��B
% 
% ������[new_m,alpha,bias,linear_index]=tjo_svm_3d_main_procedure([4;4;4],4,2,100)��
% �R�}���h���C����Ŏ��s���Ă݂ĉ������B�Y���XOR�����p�^�[�����\������܂��B
% xvec�F�e�X�g�M����xyz���W�i��x�N�g��[x;y;z]�Ŏw��j
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
% �Ȃ��A�u3�����o�[�W�����v�ƃ^�C�g�������Ă���܂����A
% �s��v�Z���̂ɕ��Ր����������Ă���܂��̂�2�����ł�4�����ł�n�����ł�
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
% �e�M����xyz���W���x�N�g���ŕ\���Ă��܂��B
% �s�����ɂ��ꂼ���xyz���W����ׂĂ����C���[�W�ł��B

c=1.5;

% XOR����^�p�^�[���F3�����Ȃ̂Ŕ��ɕ��G�ɍ���Ă���܂�
x1_list=[[ones(1,15)+c*rand(1,15);ones(1,15)+c*rand(1,15);2*ones(1,15)+c*rand(1,15)] ... % ��1�ی���
    [-1*ones(1,15)+c*rand(1,15);ones(1,15)+c*rand(1,15);-2*ones(1,15)+c*rand(1,15)] ... % ��2�ی���
    [-1*ones(1,15)+c*rand(1,15);-1*ones(1,15)+c*rand(1,15);2*ones(1,15)+c*rand(1,15)] ... % ��3�ی���
    [ones(1,15)+c*rand(1,15);-1*ones(1,15)+c*rand(1,15);-2*ones(1,15)+c*rand(1,15)]]; ... % ��4�ی���
    
x2_list=[[ones(1,15)+c*rand(1,15);ones(1,15)+c*rand(1,15);-2*ones(1,15)+c*rand(1,15)] ... % ��1�ی���
    [-1*ones(1,15)+c*rand(1,15);ones(1,15)+c*rand(1,15);2*ones(1,15)+c*rand(1,15)] ... % ��2�ی���
    [-1*ones(1,15)+c*rand(1,15);-1*ones(1,15)+c*rand(1,15);-2*ones(1,15)+c*rand(1,15)] ... % ��3�ی���
    [ones(1,15)+c*rand(1,15);-1*ones(1,15)+c*rand(1,15);2*ones(1,15)+c*rand(1,15)]]; ... % ��4�ی���

c1=size(x1_list,2); % x1_list�̗v�f��
c2=size(x2_list,2); % x2_list�̗v�f��
clength=c1+c2; % �S�v�f���F���̌㖈��Q�Ƃ��邱�ƂɂȂ�܂��B

% ����M���Fx1��x2�Ƃŕ����������̂ŁA�Ή�����C���f�b�N�X��1��-1������U��܂��B
x_list=[x1_list x2_list]; % x1_list��x2_list���s�����ɕ��ׂĂ܂Ƃ߂܂��B
y_list=[ones(c1,1);-1*ones(c2,1)]; % ����M����x1:1, x2:-1�Ƃ��ė�x�N�g���ɂ܂Ƃ߂܂��B

pause on;

figure(1);
scatter3(x1_list(1,:),x1_list(2,:),x1_list(3,:),200,'ko');hold on;
scatter3(x2_list(1,:),x2_list(2,:),x2_list(3,:),200,'k+');
xlim([-3 3]);
ylim([-3 3]);
zlim([-4 4]);

pause(5);

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

[alpha,bias]=tjo_smo(x_list,y_list,alpha,delta,Cmax,clength,learn_stlength,loop);

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

new_m=tjo_svm_trial(xvec,wvec,x_list,delta,bias,clength);

% SMO���r���ł��؂�ɂȂ����ꍇ�ɔ����āA���^����alpha*y_list = 0��
% �������Ă��邩�ǂ������v�Z����B
linear_index=y_list'*alpha;

%%
%%%%%%%%%%%%%%%%%%%%%
% �����i�v���b�g�j %
%%%%%%%%%%%%%%%%%%%%%
% Matlab�ő�̕���ł�������p�[�g�B
% �R�����g�̂Ȃ��Ƃ���͓K�XMatlab�w���v�����Q�Ɖ������B
% 3�����Ȃ̂ł��Ȃ̂���R�[�h�ɂȂ��Ă��܂��B

figure(2);

for i=1:c1
    if(alpha(i)==0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,'ko');hold on;
    elseif(alpha(i)>0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,[127/255 0 127/255]);hold on;
    end;
end;

for i=c1+1:c1+c2
    if(alpha(i)==0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,'k+');hold on;
    elseif(alpha(i)>0)
        scatter3(x_list(1,i),x_list(2,i),x_list(3,i),200,[127/255 0 127/255],'+');hold on;
    end;
end;

if(new_m > 0)
    scatter3(xvec(1),xvec(2),xvec(3),600,'ro');hold on;
elseif(new_m < 0)
    scatter3(xvec(1),xvec(2),xvec(3),600,'r+');hold on;
else
    scatter3(xvec(1),xvec(2),xvec(3),600,'bo');hold on;
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
            if(abs(mm(p,q,r))<0.2)
                V=[V [xx(p,q,r);yy(p,q,r);zz(p,q,r)]];
            end;
        end;
    end;
end;

scatter3(V(1,:),V(2,:),V(3,:),5,'green','+');hold on;

pause off;

end