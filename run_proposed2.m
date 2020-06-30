clc;clear all;close all force;
addpath('utils')

for k=1:3
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '_maska.png']);
end




sigmas_range=[2,15];
lambda_range=[1,10];
min_mass_range=[30,120];
h_range=[0,5];

min_hole=60;
T_bg=0.05;




% A = [];
% b = [];
% Aeq = [];
% beq = [];
% lb = [sigmas_range(1),lambda_range(1),init_T_range(1),max_T_range(1),min_mass_range(1),h_range(1)];
% ub = [sigmas_range(2),lambda_range(2),init_T_range(2),max_T_range(2),min_mass_range(2),h_range(2)];
% nonlcon = [];
% options = optimoptions('ga','PlotFcn', @gaplotbestf);
% fun = @(x) segm_qpi_log_eval(II,GTT,x(1),x(2),x(3),x(4),x(5),min_hole,T_bg,x(6));
% x =  ga(fun,length(lb),A,b,Aeq,beq,lb,ub,nonlcon,options);


sigmas = optimizableVariable('sigmas',sigmas_range);
lambda = optimizableVariable('lambda',lambda_range);
min_mass = optimizableVariable('min_mass',min_mass_range);
h = optimizableVariable('h',h_range);
vars = [sigmas,lambda,min_mass,h];
fun = @(x) segm_qpi_log2_eval(II,GTT,x.sigmas,x.lambda,x.min_mass,min_hole,T_bg,x.h);

results = bayesopt(fun,vars,'NumSeedPoints',10,'MaxObjectiveEvaluations',200);

k=0;
for kk=4:18
    k=k+1;
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '_maska.png']);
end
fun = @(x) segm_qpi_log2_eval(II,GTT,x.sigmas,x.lambda,x.min_mass,min_hole,T_bg,x.h);

res=fun(results.XAtMinObjective)

save('params_proposed2.mat','results','res')

