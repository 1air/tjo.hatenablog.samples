function [wvec,hvec]=tjo_bp_train(wvec,hvec,x_list,y_list,clength,k,loop)
% ���͑w�ƒ��ԑw�̗������w�K����֐��ł��B
% �����͏��������ꂽ2�̏d�݃x�N�g���A���t�M���A�������x���M���A
% ���t�M���̌��A�w�K�W���A���[�v����ł��B

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �e��ꎞ�g�p�����p�����[�^�̏����� %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err=zeros(3,1); % ���ԑw�ɋt�`�d������덷
ek=zeros(3,1); % ���͑w�ɋt�`�d������덷
hvec_n=zeros(3,1); % hvec�̍X�V��̒l
wvec_n=zeros(3,1); % wvec�̍X�V��̒l

%%
for i=1:loop
    for j=1:clength
        gvec=tjo_1st_step(x_list(:,j),wvec); % ���͑w�����ԑw
        u=tjo_2nd_step(gvec,hvec); % ���ԑw�����͑w

        %%%%%%%%%%%%%%%%%
        % ��������w�K�� %
        %%%%%%%%%%%%%%%%%
        
        p=(y_list(j)-u)*u*(1-u); % ��`���ɏ]���Č덷�W�����Z�o
        
        % ���ԑw�ɋt�`�d������덷
        err(1)=p*gvec(1);
        err(2)=p*gvec(2);
        err(3)=p*gvec(3);

        % ���ԑw�̏d�݃x�N�g�����X�V
        hvec_n(1)=hvec(1)+err(1)*k;
        hvec_n(2)=hvec(2)+err(2)*k;
        hvec_n(3)=hvec(3)+err(3)*k;
        
        % ����ɓ��͑w�ɋt�`�d������덷
        ek(1)=err(1)*hvec_n(1)*gvec(1)*(1-gvec(1));
        ek(2)=err(2)*hvec_n(2)*gvec(2)*(1-gvec(2));
        ek(3)=err(3)*hvec_n(3)*gvec(3)*(1-gvec(3));
        
        % ���͑w�̏d�݃x�N�g�����X�V
        wvec_n(1,1)=wvec(1,1)+x_list(1,j)*err(1)*k;
        wvec_n(2,1)=wvec(2,1)+x_list(2,j)*err(2)*k;
        wvec_n(3,1)=wvec(3,1)+x_list(3,j)*err(3)*k;
        wvec_n(1,2)=wvec(1,2)+x_list(1,j)*err(1)*k;
        wvec_n(2,2)=wvec(2,2)+x_list(2,j)*err(2)*k;
        wvec_n(3,2)=wvec(3,2)+x_list(3,j)*err(3)*k;
        
        wvec=wvec_n;
        hvec=hvec_n;
    end;
end;

end