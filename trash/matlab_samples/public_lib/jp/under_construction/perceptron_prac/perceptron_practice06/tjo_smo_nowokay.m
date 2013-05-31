function alpha_smo=tjo_smo_nowokay(x_list,y_list,e_list,alpha,delta,Cmax,loop,clength,learn_stlength)

% global x_list y_list e_list alpha delta Cmax loop clength learn_stlength;

wvec=zeros(clength,1);
bias=0;
% alpha�͍ŏ��Ȃ̂ŃI�[��0�̔z�񂪓ǂݍ��܂�Ă���

alldata=true; % �S�Ẵf�[�^����������ꍇ
changed=false; % �ύX�����������Ƃ�����
E_cache=zeros(clength,1);

while(alldata||changed)
    for lp=1:50000
        changed=false;
        z=0;
        lastchange=true;
        
        for j=1:clength
            % ��_2��I��
            alph2=alpha(j);
            if(~alldata && (alph2 <= 0 || alph2 >= Cmax)) % 0 < alpha < Cmax�̓_������������
                continue;
            end;
            if(lastchange) % �����f�[�^���ς�������ɃL���b�V�����N���A
                E_cache=zeros(clength,1);
            end;
            lastchange=false;
            
            t2; % �ۗ�
            fx2=calcE(j); % ���calcE���L�q
            
            % KKT�����̔���
            r2 = fx2 * t2;
            if(~((alph2 < Cmax && r2 < -tol) || (alph2 > 0 && r2 > tol))) % KKT�����𖞂����Ȃ珈�����Ȃ�
                continue;
            end;
            
            % ��_1��I��
            % �I��@1
            i=0;
            offset_tmp=randperm(clength);
            offset=offset_tmp(1);
            
            max_val=-1;
            for ll=1:clength
                l = mod((ll + offset),clength); % ��]�̌v�Z��mod�Ȃ̂ł���
                % 0 < alpha < Cmax
                if(0>=alpha(l) || c<=alpha(l))
                    continue;
                end;
                dif=abs(calcE(l)-fx2);
                if(dif > max_val)
                    max_val=dif;
                    i=l;
                end;
            end;
            if(max_val>=0)
                if(step(i,j))
                    % �����������玟��
                    changed=true;
                    lastchange=true;
                    continue;
                end;
            end;
            % �I��@2
            offset_tmp=randperm(clength);
            offset=offset_tmp(1); % �����_���Ȉʒu����
            for l=1:clength
                % 0 < alpha < Cmax
                i=mod((l+offset),clength);
                if(0>=alpha(i) || Cmax<=alpha(i))
                    continue;
                end;
                if(step(i,j))
                    % �����������玟��
                    changed=true;
                    lastchange=true;
                    continue;
                end;
            end;
            % �I��@3
            offset_tmp=randperm(clength);
            offset=offset_tmp(1); % �����_���Ȉʒu����
            for l=1:clength
                i=mod((l+offset),clength);
                if(step(i,j))
                    % �����������玟��
                    changed=true;
                    lastchange=true;
                    continue;
                end;
            end;
        end;
        
    end;
end;

end