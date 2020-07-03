clc;clear all;close all force;
addpath('utils')



for k=1:3
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(k) '_maska.png']);
end


%  init_r |        max_r |       t_frst |           kr |        alpha 
%  11.081 |       15.289 |   9.0016e-05 |       6.6639 |      0.17684 |


% init_r=10;
% max_r=45;
% t_frst=0.02;
% kr=7.5;
% alpha=0.42;


init_r=10;
max_r=40;
alpha=0.4222;
t_frst=0.0154;
kr=7.5;


min_hole=60;
T_bg=0.05;

for k=1:3
    I=II(:,:,k);

    segm=segm_frst(I,init_r,max_r,t_frst,kr,alpha,min_hole,T_bg);
    [dice]=dice_final_segmentation(GTT(:,:,k),segm);
    
    figure();
    imshow(I,[-0.4,1.5])
    hold on 
    visboundaries(segm>0,'LineWidth',0.1)
    drawnow;
end






