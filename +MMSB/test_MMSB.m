
import MMSB.*
[ hyper_para_init ] = init_hyper_para( hyper_para_true );
[hyper_para,var_para] = mmsb(data.Y, hyper_para_init);

% [~, G_idx] = max(var_para.gama);
%[pi,zL,zR]= get_latent (phiL,phiR ,gama,alpha, B);
%[ scores] = score_var(hyper_para, var_para);
