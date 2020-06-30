clc;clear all;close all force;
addpath('utils')

% for k=1:3
%     II(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '.tif']);
%     GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '_maska.png']);
% end

for k=1:5
    II(:,:,k)=imread(['../data_dense/img_' num2str(k,'%03.f') '.tif']);
    tmp=imread(['../data_dense/img_' num2str(k,'%03.f') '.png'])>0;
    GTT(:,:,k)=bwareaopen(tmp,30);
end


sigmas_range=[2,15];
lambda_range=[1,10];
init_T_range=[0,1];
max_T_range=[1,5];
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
init_T = optimizableVariable('init_T',init_T_range);
max_T = optimizableVariable('max_T',max_T_range);
min_mass = optimizableVariable('min_mass',min_mass_range);
h = optimizableVariable('h',h_range);
vars = [sigmas,lambda,init_T,max_T,min_mass,h];
fun = @(x) segm_qpi_log_eval(II,GTT,x.sigmas,x.lambda,x.init_T,x.max_T,x.min_mass,min_hole,T_bg,x.h);

results = bayesopt(fun,vars,'NumSeedPoints',10,'MaxObjectiveEvaluations',300);

% k=0;
% for kk=4:18
%     k=k+1;
%     II(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '.tif']);
%     GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '_maska.png']);
% end

k=0;
for kk=6:14
    k=k+1;
    II(:,:,k)=imread(['../data_dense/img_' num2str(kk,'%03.f') '.tif']);
    tmp=imread(['../data_dense/img_' num2str(kk,'%03.f') '.png'])>0;
    GTT(:,:,k)=bwareaopen(tmp,30);
end
fun = @(x) segm_qpi_log_eval(II,GTT,x.sigmas,x.lambda,x.init_T,x.max_T,x.min_mass,min_hole,T_bg,x.h);

res=fun(results.XAtMinObjective)

save('params_proposed_dense.mat','results','res')

