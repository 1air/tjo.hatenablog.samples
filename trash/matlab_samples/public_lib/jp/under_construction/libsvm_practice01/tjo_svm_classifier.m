function wvec=tjo_svm_classifier(y_list,alpha,clength)
% �����֐����`����x�N�g��w(wvec)���Z�o����֐��B
% ���͂����̐���M��y_list�ƃ��O�����W���搔alpha�̓��ρB

wvec=zeros(clength,1);

for i=1:clength
    wvec(i)=y_list(i)*alpha(i);
end;

end