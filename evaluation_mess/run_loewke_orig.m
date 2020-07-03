clc;clear all;close all force;
% dbstop if error
% dbclear if error
addpath('utils')

for k=1:3
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '_maska.png']);
end





min_mass_range=[20,200];

min_hole=60;
T_bg=0.05;



min_mass = optimizableVariable('min_mass',min_mass_range);
vars = [min_mass];

fun = @(x) segm_loewke_orig_eval(II,GTT,x.min_mass,min_hole,T_bg);
results = bayesopt(fun,vars,'NumSeedPoints',5,'MaxObjectiveEvaluations',30);


k=0;
for kk=4:18
    k=k+1;
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '_maska.png']);
end
fun = @(x) segm_loewke_orig_eval(II,GTT,x.min_mass,min_hole,T_bg);

res=fun(results.XAtMinObjective)

save('params_loewke_orig.mat','results','res')

load('params_loewke_orig.mat')
