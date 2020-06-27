clc;clear all;close all force;
addpath('utils')


% I=imread('../tmp_data/Compensated phase-pgpum2-001-001.tiff',1);
% I=imread('../tmp_data/Compensated phase-pgpum2-002-001.tiff',1);
% I=imread('../tmp_data/Compensated phase-pgpum2-003-001.tiff',1);
% 
% init_T=-0.15;
% max_T=1.5;
% min_size=80;
% min_hole=80;
% T_bg=-0.25;
% h=1;



I=imread('../tmp_data/QPI_A2780_30mj_500ms_004.tiff',1);


figure();
imshow(I,[-0.4,2])

init_T=0.2;
max_T=1.5;
min_size=60;
min_hole=60;
T_bg=0.05;
h=1;


[segm,nuc]=segm_qpi(I,init_T,max_T,min_size,min_hole,T_bg,h);


figure();
imshow(I,[-0.4,1.5])
hold on 
visboundaries(segm>0,'LineWidth',0.1)





% sig=10;
% filter_size= 2*ceil(3*sig)+1;
% h=(sig.^gamma)*fspecial('log', filter_size, sig);
% figure();
% imshow(-conv2(I,h,'same'),[])




init_T=0.2;
max_T=4;
min_mass=80;
min_hole=60;
T_bg=0.05;
h=1;
lambda=4;
sigmas=4;

segm=segm_qpi_log(I,lambda,sigmas,init_T,max_T,min_mass,min_hole,T_bg,h);


figure();
imshow(I,[-0.4,1.5])
hold on 
visboundaries(segm>0,'LineWidth',0.1)






