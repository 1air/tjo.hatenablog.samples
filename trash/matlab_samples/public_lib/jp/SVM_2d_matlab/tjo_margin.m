function m=tjo_margin(fix_v,x_var,alpha_var,y_var,delta,clength)
%%
% �}�[�W���Z�o�֐��ł��B
% fix_v�������O�����͕ϐ��ł���_�ɒ��ӁB
% �c��͋��t�M��x_list�S�̂Ɛ���M��y_list�S�̂ƁA���O�����W���搔�ȂǂȂǁB

m=0;

for i=1:clength
    m = m + (alpha_var(i)*y_var(i)*tjo_kernel(fix_v,x_var(:,i),delta));
end;

end