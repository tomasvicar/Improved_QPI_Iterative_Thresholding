function segm=segm_frst(I,init_r,max_r,t_frst,kr,alpha,min_hole,T_bg)



I_bg=I;

I=mat2gray(I,[-1.0169 2.9386]);

fg_mask=I_bg>T_bg;


fg_mask =  ~bwareaopen(~fg_mask,min_hole);
fg_mask =  bwareaopen(fg_mask,min_hole);

rrange=init_r:max_r;
detection = frst(I,fg_mask,rrange,t_frst,kr,alpha);


segm=seeded_watershed(I,detection,fg_mask);





