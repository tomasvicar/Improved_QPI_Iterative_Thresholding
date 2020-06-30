clc;clear all;close all force;


k=0;
for kk=4:18
    k=k+1;
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '_maska.png']);
end
min_hole=60;
T_bg=0.05;


I=II(:,:,1);

load('params_frst.mat')
segm=segm_frst(I,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);
    
load('params_loewke_orig.mat')
segm=segm_loewke_orig(I,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);

load('params_frst.mat')
segm=segm_frst(I,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);
