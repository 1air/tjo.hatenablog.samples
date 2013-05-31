function [yvec,nE,H]=tjo_LR_main(xvec)
%%

c=4;

q1=[(1*ones(1,10)+c*rand(1,10));(1*ones(1,10)+c*rand(1,10));ones(1,10)];
q2=[(-1*ones(1,10)-c*rand(1,10));(1*ones(1,10)+c*rand(1,10));ones(1,10)];
q3=[(-1*ones(1,10)-c*rand(1,10));(-1*ones(1,10)-c*rand(1,10));ones(1,10)];
q4=[(1*ones(1,10)+c*rand(1,10));(-1*ones(1,10)-c*rand(1,10));ones(1,10)];

x1_list=[q1 q2 q4];
x2_list=[q3];

c1=size(x1_list,2); % x1_list�̗v�f��
c2=size(x2_list,2); % x2_list�̗v�f��
clength=c1+c2; % �S�v�f���F���̌㖈��Q�Ƃ��邱�ƂɂȂ�܂��B

% ����M���Fx1��x2�Ƃŕ����������̂ŁA�Ή�����C���f�b�N�X��1��-1������U��܂��B
x_list=[x1_list x2_list]; % x1_list��x2_list���s�����ɕ��ׂĂ܂Ƃ߂܂��B
y_list=[ones(c1,1);zeros(c2,1)]; % ����M����x1:1, x2:0�Ƃ��ė�x�N�g���ɂ܂Ƃ߂܂��B

pause on;

figure(1); % �v���b�g�E�B���h�E��1���
scatter(x1_list(1,:),x1_list(2,:),100,'ko');hold on;
scatter(x2_list(1,:),x2_list(2,:),100,'k+');
xlim([-10 10]);
ylim([-10 10]);

pause(3);

%%
wvec=[0;0;1];

%%
[wvec,nE,H]=tjo_LR_train(wvec,x_list,y_list,clength);

yvec=tjo_LR_predict(wvec,[xvec;1]);

figure(2); % �v���b�g�E�B���h�E��1���
scatter(x1_list(1,:),x1_list(2,:),100,'ko');hold on;
scatter(x2_list(1,:),x2_list(2,:),100,'k+');hold on;
xlim([-10 10]);
ylim([-10 10]);

if(yvec > 0.5) % �e�X�g�M��xvec��Group 1�Ȃ�Ԃ����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red');hold on;
elseif(yvec < 0.5) % �e�X�g�M��xvec��Group 2�Ȃ�Ԃ��{�Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red','+');hold on;
else % �e�X�g�M��xvec�����ꕪ�������ʏ�Ȃ�����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'blue');hold on;
end;

% �R���^�[�i�������j�v���b�g�B����̂ŏڍׂ�Matlab�w���v�����Q�Ɖ������B
[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        zz(p,q)=tjo_LR_predict(wvec,[xx(p,q);yy(p,q);1]);
    end;
end;
contour(xx,yy,zz,50);hold on;

pause off;

end