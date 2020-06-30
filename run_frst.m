clc;clear all;close all force;
% dbstop if error
% dbclear if error
addpath('utils')

for k=1:3
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '_maska.png']);
end




init_r_range=[4,25];
max_r_range=[15,70];
t_frst_range=[0,0.3];
kr_range=[5,15];
min_mass_range=[30,120];
alpha_range=[0.1,3];

min_hole=60;
T_bg=0.05;



init_r = optimizableVariable('init_r',init_r_range);
max_r = optimizableVariable('max_r',max_r_range);
t_frst = optimizableVariable('t_frst',t_frst_range);
kr = optimizableVariable('kr',kr_range);
alpha = optimizableVariable('alpha',alpha_range);
vars = [init_r,max_r,t_frst,kr,alpha];

fun = @(x) segm_frst_eval(II,GTT,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);
results = bayesopt(fun,vars,'NumSeedPoints',10,'MaxObjectiveEvaluations',300);


k=0;
for kk=4:18
    k=k+1;
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '_maska.png']);
end
fun = @(x) segm_frst_eval(II,GTT,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);

res=fun(results.XAtMinObjective)

save('params_frst.mat','results','res')

load('params_frst.mat')
