function m=tjo_margin_linear(x_fix,x_var,alpha_var,y_var,delta)

% xvec�������ϐ�

[rlength,clength]=size(x_var);
m=0;

for i=1:clength
    m = m + (alpha_var(i)*y_var(i)*tjo_kernel_linear(x_fix,x_var(i),delta));
end;

end