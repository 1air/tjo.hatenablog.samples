data {
	int<lower=0> N; // �T���v���T�C�Y
	int<lower=0> y[N]; // ��q8������̐������i�ړI�ϐ��j
}
parameters {
	real beta; // �S�̋��ʂ̃��W�X�e�B�b�N�Ή�A�W��
	real r[N]; // �̍�
	real<lower=0> s; // �̍��̂΂��
}
transformed parameters {
	real q[N];
	for (i in 1:N)
		q[i] <- inv_logit(beta+r[i]); // �����m�����̍��Ń��W�b�g�ϊ�
}
model {
	for (i in 1:N)
		y[i] ~ binomial(8,q[i]); // �񍀕��z�Ő����m�������f�����O
	beta~normal(0,1.0e+2); // ���W�X�e�B�b�N�Ή�A�W���̖���񎖑O���z
	for (i in 1:N)
		r[i]~normal(0,s); // �̍��̊K�w���O���z
	s~uniform(0,1.0e+4); // r[i]��\�����邽�߂̖���񎖑O���z
}