function gid=tjo_NN_classify(xvec,x_list,cl)
% NN�@�̕��ޕ��B
% �ɂ߂ăV���v���ɁA���t�M��x_list�ƃe�X�g�M��xvec�Ƃ�
% ���[�N���b�h�����i�m�����j���v�Z���āA���̍ŏ��l��^����
% ���t�M���v�f��3��ځi�N���X�l�j���Q�Ƃ��A������e�X�g�M����
% ��������i�Ɣ��肳���j�N���X�Ƃ��ĕԂ��悤�ɂ��Ă���܂��B

% �m�����l���i�[�����x�N�g���B
dist=zeros(cl,1);

% ���t�M�����ɑ΂��ăm�������v�Z�B
for i=1:cl
    dist(i)=norm(xvec-x_list(1:2,i));
end;

% find(statement)�֐���statement�𖞂����x�N�g���̃C���f�b�N�X��
% �x�N�g���Ƃ��ĕԂ��i�����̏ꍇ�F1�����Ȃ���ΐ���1�j�B
% ����ōŏ��m������Ԃ����t�M��x_list�̃C���f�b�N�X��������B
nn_id=find(dist==min(dist));
% x_list�̓��Y�C���f�b�N�X���3��ڂ��N���X�l�Ȃ̂ŁA�����Ԃ��B
gid=x_list(3,nn_id);

end