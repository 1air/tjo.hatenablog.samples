function [wvec,margin]=tjo_PA2_practice01(xvec,Cmax)
%%
% xvec: �e�X�g�M��
% Cmax: 

%%
c=4;

x11_list=[(ones(1,15)+c*rand(1,15));(ones(1,15)+c*rand(1,15))]; % ��1�ی�
x22_list=[(-1*ones(1,15)-c*rand(1,15));(ones(1,15)+c*rand(1,15))]; % ��2�ی�
x33_list=[-1*ones(1,15)-c*rand(1,15);-1*ones(1,15)-c*rand(1,15)]; % ��3�ی�
x44_list=[(ones(1,15)+c*rand(1,15));(-1*ones(1,15)-c*rand(1,15))]; % ��4�ی�

x1_list=[x11_list x22_list x44_list];
x2_list=x33_list;

c1=size(x1_list,2); % x1_list�̗v�f��
c2=size(x2_list,2); % x2_list�̗v�f��
clength=c1+c2; % �S�v�f���F���̌㖈��Q�Ƃ��邱�ƂɂȂ�܂��B

% ����M���Fx1��x2�Ƃŕ����������̂ŁA�Ή�����C���f�b�N�X��1��-1������U��܂��B
x_list=[x1_list x2_list]; % x1_list��x2_list���s�����ɕ��ׂĂ܂Ƃ߂܂��B
y_list=[ones(c1,1);-1*ones(c2,1)]; % ����M����x1:1, x2:-1�Ƃ��ė�x�N�g���ɂ܂Ƃ߂܂��B

wvec=zeros(2,1);
loop=1000;

%%

wvec = tjo_PA2_train(wvec,x_list,y_list,Cmax,loop);

%%

margin = tjo_PA2_predict(wvec,xvec);

if(sign(margin)==1)
    fprintf(1,'Group 1\n\n');
elseif(sign(margin)==-1)
    fprintf(1,'Group 2\n\n');
else
    fprintf(1,'On the border\n\n');
end;

%%
% ����
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