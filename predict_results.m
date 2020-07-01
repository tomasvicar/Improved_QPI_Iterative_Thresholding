clc;clear all;close all force;
colormap_cells=[1 0 0;0 1 0;0 0 1;0.8314 0.8314 0.0588;1 0 1;1,0.5,0;0.00,1.00,1.00;0.45,0.00,0.08];
contour_line_width=1.5;
N=size(colormap_cells,1);
segms={};
norm=[-0.3,2];
siz=200;

k=0;
for kk=4:18
    k=k+1;
    II(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '.tif']);
    GTT(:,:,k)=imread(['../data_reveiw/qpi' num2str(kk) '_maska.png']);
end
min_hole=60;
T_bg=0.05;


% img_num=2;
% pos=[113,252];

% img_num=6;
% pos=[336,327];

% img_num=7;
% pos=[200,40];

img_num=12;
pos=[368,96];


I=II(:,:,img_num);


GT=GTT(:,:,img_num);
GT=GT(pos(1):pos(1)+siz,pos(2):pos(2)+siz);

GT=imerode(GT,[0,0,0;0,1,1;0,1,0]);

segms=[segms,zeros(size(GT))>0];
segms=[segms,GT>0];


load('params_loewke_orig.mat')
x=results.XAtMinObjective;
segm=segm_loewke_orig(I,x.min_mass,min_hole,T_bg);
segm=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz);
segms=[segms,segm>0];


load('params_frst.mat')
x=results.XAtMinObjective;
segm=segm_frst(I,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);
segm=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz); 
segms=[segms,segm>0];

load('params_proposed2.mat')
x=results.XAtMinObjective;
segm=segm_qpi_log2(I,x.sigmas,x.lambda,x.min_mass,min_hole,T_bg,x.h);
segm=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz);
segms=[segms,segm>0];


I=I(pos(1):pos(1)+siz,pos(2):pos(2)+siz);
Is=repmat({mat2gray(I,norm)},[1,5]);









k=0;
for kk=6:14
    k=k+1;
    II(:,:,k)=imread(['../data_dense/img_' num2str(kk,'%03.f') '.tif']);
    tmp=imread(['../data_dense/img_' num2str(kk,'%03.f') '.png'])>0;
    GTT(:,:,k)=bwareaopen(tmp,30);
end
min_hole=60;
T_bg=0.05;


img_num=8;
pos=[58,17];

% img_num=6;
% pos=[164,292];

I=II(:,:,img_num);

GT=GTT(:,:,img_num);
GT=GT(pos(1):pos(1)+siz,pos(2):pos(2)+siz);
segms=[segms,zeros(size(GT))>0];
segms=[segms,GT>0];


load('params_loewke_orig_dense.mat')
x=results.XAtMinObjective;
segm=segm_loewke_orig(I,x.min_mass,min_hole,T_bg);
segm=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz);
segms=[segms,segm>0];

load('params_frst_dense.mat')
x=results.XAtMinObjective;
segm=segm_frst(I,x.init_r,x.max_r,x.t_frst,x.kr,x.alpha,min_hole,T_bg);
segm=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz); 
segms=[segms,segm>0];


load('params_proposed2_dense.mat')
x=results.XAtMinObjective;
segm=segm_qpi_log2(I,x.sigmas,x.lambda,x.min_mass,min_hole,T_bg,x.h);
segm=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz);
segms=[segms,segm>0];


I=I(pos(1):pos(1)+siz,pos(2):pos(2)+siz);





Is=[Is,repmat({mat2gray(I,norm)},[1,5])];











tmp=montage(Is,'BorderSize',[5,5],'Size',[2,5]);
Is=tmp.CData;


tmp=montage(segms,'BorderSize',[5,5],'Size',[2,5]);
segms=tmp.CData;


segms= ~bwareaopen(~segms,50);
segms= bwareaopen(segms,50);

segmentaion=colorize_notouchingsamecolor(segms,8);

imshow(Is,[])
hold on
for k=1:N
    visboundaries(segmentaion==k,'Color',colormap_cells(k,:),'EnhanceVisibility',0,'LineWidth',contour_line_width);
end

axis on

shape=size(segms);

tmp=linspace(0,shape(2),6);
tmp=tmp(1:5);
tmp=tmp+0.5*tmp(2);
xticks(tmp)
xticklabels({'Input','Ground Truth','Iterative Thresholding','dFRST+MCWS ','IIT (proposed)'})


tmp=linspace(0,shape(1),3);
tmp=tmp(1:2);
tmp=tmp+0.5*tmp(2);
yticks(tmp)
yticklabels({'PNT1A','A2780'})
ytickangle(90)

set(gca,'fontsize', 16)

set(gca,'TickLength',[0 0])


print('../example_result','-depsc')

print('../example_result','-dtiff','-r600')
