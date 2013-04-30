function tjo_NN_procedure(xvec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nearest Neighbor�@���ފ� by Takashi J. OZAKI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ɒP����NN�@�̎����R�[�h�ł��B
% �S�Ă̋��t�M���ƃe�X�g�M���Ƃ̊Ԃ̃m�������v�Z���A
% �ł��Z���m������Ԃ������t�M����������O���[�v��
% �e�X�g�M����������A�ƕ��ނ��Ă��邾���ł��B

%%
%%%%%%%%%%%%%%%%%%%%%%%%%
% ���t�M���̃Z�b�e�B���O %
%%%%%%%%%%%%%%%%%%%%%%%%%
% xy���W�n��4�̏ی��Ɋe�X���t�M�����΂�T���Ă��܂��B
% ones�֐���xy���W�̒��S�l���Arand�֐��ł΂����^���āA
% 3�s�ڂ�4�ی��̂�����ɑ����邩�̃N���X�l��^���Ă��܂��B
% ����3 x n�̃}�g���N�X�����t�M���̃f�[�^�ł��B

% �΂���̑傫��
c=4;

% 4�ی��ɕ����Ă��܂�
x1_list=[(ones(1,15)+c*rand(1,15));(ones(1,15)+c*rand(1,15));1*ones(1,15)];
x2_list=[(-1*ones(1,15)-c*rand(1,15));(ones(1,15)+c*rand(1,15));2*ones(1,15)];
x3_list=[-1*ones(1,15)-c*rand(1,15);-1*ones(1,15)-c*rand(1,15);3*ones(1,15)];
x4_list=[(ones(1,15)+c*rand(1,15));(-1*ones(1,15)-c*rand(1,15));4*ones(1,15)];

% 1�ɋ��t�M�����܂Ƃ߂�
x_list=[x1_list x2_list x3_list x4_list];
% ���t�M���̐��i�񐔁j
cl=size(x_list,2);

%%
%%%%%%%%%%
% ���蕔 %
%%%%%%%%%%
% ���ۂɋ��t�M��x_list�ƃe�X�g�M��xvec�Ƃ̊Ԃ̃m�����𒀎��S�Čv�Z���A
% �ŏ��m������Ԃ������t�M����x�N�g����3��ځi�N���X�l�j��Ԃ��B
gid=tjo_NN_classify(xvec,x_list,cl);
fprintf(1,'\n\nGroup %d\n\n',gid);

%%
%%%%%%%%%%%%%%%
% �����p�[�g %
%%%%%%%%%%%%%%%
% Matlab�֐��Ɉˑ�����̂ŁA�����̐����͊����B
figure(1);

for i=1:cl/4
    scatter(x1_list(1,i),x1_list(2,i),100,'ko');hold on;
    scatter(x2_list(1,i),x2_list(2,i),100,'k+');hold on;
    scatter(x3_list(1,i),x3_list(2,i),100,'bo');hold on;
    scatter(x4_list(1,i),x4_list(2,i),100,'b+');hold on;
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
            zz(p,q)=tjo_NN_classify([xx(p,q);yy(p,q)],x_list,cl);
        end;
    end;
end;

contour(xx,yy,zz,[1 2 3 4]);hold on;

end