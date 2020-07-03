clc;clear all;close all force;
addpath('utils')
addpath('../evaluation_mess')

colormap_cells=[1 0 0;0 1 0;0 0 1;0.8314 0.8314 0.0588;1 0 1;1,0.5,0;0.00,1.00,1.00;0.45,0.00,0.08];
contour_line_width=1.5;
N=size(colormap_cells,1);
norm=[-0.3,2];


I=imread('../data_dense/img_013.tif');
GT=imread('../data_dense/img_013.png');

I=I(100:end,:);
GT=GT(100:end,:);





% 
% min_mass=40.299;
% 
% T_bg=0.05;
% min_hole=60;
% 
% 
% segmetnation=IT(I,min_mass,min_hole,T_bg);







sigma=2.08;
lambda=5.087;
min_mass=79.68;
h=0.964;

T_bg=0.05;
min_hole=60;

segmetnation=IIT(I,lambda,sigma,min_mass,min_hole,T_bg,h);
 





% init_r=4.586;
% max_r=31.438;
% t_frst=0.00087;
% kr=5.291;
% alpha=0.950;
% 
% T_bg=0.05;
% min_hole=60;
% 
% segmetnation=dFRST_MCWS(I,init_r,max_r,t_frst,kr,alpha,min_hole,T_bg);







figure;


subplot(1,2,1)
imshow(I,norm)
hold on
title('Resutls')
masks_color=colorize_notouchingsamecolor(segmetnation,8);
for k=1:N
    visboundaries(masks_color==k,'Color',colormap_cells(k,:),'EnhanceVisibility',0,'LineWidth',contour_line_width);
end




subplot(1,2,2)
imshow(I,norm)
hold on
title('Ground Truth')
masks_color=colorize_notouchingsamecolor(GT>0,8);
for k=1:N
   
    visboundaries(masks_color==k,'Color',colormap_cells(k,:),'EnhanceVisibility',0,'LineWidth',contour_line_width);
end






