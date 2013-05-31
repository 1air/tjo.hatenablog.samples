function new_m=tjo_svm_procedure_2d_multiclass_ecoc(xvec,delta,Cmax,loop)
%%
% SMO�����ς�

% �������������̂Ńo�O��茈�s
% �_���ڂƂ��ẮA
% 1. �J�[�l���𑽍����ɕς�����悤�ɂ���
% 2. �}�[�W���v�Z�ɉ��������̕s�������邩���Ȃ̂Ń`�F�b�N����
% 3. �P�ɍŌ��contour�`��ɕs�������邩���Ȃ̂Ŋm�F����

%%
% xy���W�n�̒l��f���Ƃ����P���f�[�^
% �K���Ɍ��߂đ�1�W�c�Ȃ�1
% ��2�W�c�Ȃ�-1�𐳉����x���Ƃ���

c=4;

% XOR
x1_list=[(ones(1,15)+c*rand(1,15));(ones(1,15)+c*rand(1,15))];
x2_list=[(-1*ones(1,15)-c*rand(1,15));(ones(1,15)+c*rand(1,15))];
x3_list=[-1*ones(1,15)-c*rand(1,15);-1*ones(1,15)-c*rand(1,15)];
x4_list=[(ones(1,15)+c*rand(1,15));(-1*ones(1,15)-c*rand(1,15))];

x_list=[x1_list x2_list x3_list x4_list];

c1=size(x1_list,2);
c2=size(x2_list,2);
c3=size(x3_list,2);
c4=size(x4_list,2);
y_list_group=[...
    [ones(c1,1);-1*ones((c2+c3),1);ones(c4,1)] ...          % [1 0 0 1]
    [ones(c1,1);-1*ones(c2,1);ones(c3,1);-1*ones(c4,1)] ... % [1 0 1 0]
    [ones(c1,1);-1*ones(c2,1);ones((c3+c4),1)] ...          % [1 0 1 1]
    [ones((c1+c2+c3),1);-1*ones(c4,1)]...                   % [1 1 1 0]
    [ones((c1+c2),1);-1*ones(c3,1);ones(c4,1)]...           % [1 1 0 1]
    [ones((c1+c2),1);-1*ones((c3+c4),1)]...                 % [1 1 0 0]
    ];

clength=c1+c2+c3+c4;

pause on;

figure(1);
scatter(x1_list(1,:),x1_list(2,:),100,'ko');hold on;
scatter(x2_list(1,:),x2_list(2,:),100,'k+');hold on;
scatter(x3_list(1,:),x3_list(2,:),100,'bo');hold on;
scatter(x4_list(1,:),x4_list(2,:),100,'b+');
xlim([-10 10]);
ylim([-10 10]);

pause(3);

%%
% �P���p�[�g
alpha=zeros(clength,6);
wvec=zeros(clength,6);
bias=zeros(6,1);

% loop=1000; % �P���̌J��Ԃ���
learn_stlength=0.5;

%%
% alpha�𐄒肷��B������SVM��training�̊�
for i=1:6
    [alpha(:,i),bias(i)]=tjo_smo(x_list,y_list_group(:,i),alpha(:,i),delta,Cmax,clength,learn_stlength,loop);
    wvec(:,i)=tjo_svm_classifier(y_list_group(:,i),alpha(:,i),clength);
end;

%%
% ���ނ��Ă݂�(Trial / Testing)
new_m=zeros(1,6);
for j=1:6
    out=tjo_svm_trial_silent(xvec,wvec(:,j),x_list,delta,bias(j),clength);
    if out>0
        new_m(i)=1;
    else
        new_m(i)=0;
    end;
end;

distmat=[[1 1 1 1 1 1];[0 0 0 1 1 1];[0 1 1 1 0 0];[1 0 1 0 1 0]];
distvec=zeros(1,4);
for j=1:4
    distvec(j)=pdist([new_m;distmat(j,:)],'hamming');
end;

group_id=find(distvec==min(distvec));
if size(group_id,2)>1
    group_idx=group_id(1);
else
    group_idx=group_id;
end;

fprintf(1,'Group %d\n\n',group_idx);

%%
% ���܂��ŉ���
figure(2);

for i=1:c1
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
        out_m=zeros(1,6);
        for i=1:6
            out=tjo_svm_trial_silent([xx(p,q);yy(p,q)],wvec(:,i),x_list,delta,bias(i),clength);
            if out>0
                out_m(i)=1;
            else
                out_m(i)=0;
            end;
        end;
        out_vec=zeros(1,4);
        for j=1:4
            out_vec(j)=pdist([out_m;distmat(j,:)],'hamming');
        end;
        out_id=find(out_vec==min(out_vec));
        if size(out_id,2)>1
            out_idx=out_id(1);
        else
            out_idx=out_id;
        end;
        zz(p,q)=out_idx;
    end;
end;

contour(xx,yy,zz,50);hold on;

pause off;

end