function out=tjo_part_prob(xvec_id,data_row)
% ���������P����p(xi|E)���v�Z����֐��B
% Matlab��find�֐��𗘗p���Ă���̂ŗv���ӁB

% ���t�M���̍s�̒��������߂܂��B
cl=size(data_row,2);

% find(statement)�֐���statement�𖞂����x�N�g���̃C���f�b�N�X��
% �S�ė񋓂��āA���߂ăx�N�g���Ƃ��ĕԂ��܂��B
% �Ȃ̂ŁA�����ł͋��t�M���̓���̍s�̒��ɂ����ăe�X�g�M���̒l��
% ���v������̂��������邩��num�Ƃ��ĕԂ��悤�ɂ��Ă��܂��B
num=size(find(data_row==xvec_id),2);

% num���s�̃T�C�Y�Ŋ���΁A�m���i�����j�������܂��B
out=num/cl;

end