clc;clear all;close all force;
addpath('utils')


I=imread('../tmp_data/Compensated phase-pgpum2-001-001.tiff',1);
% I=imread('../tmp_data/Compensated phase-pgpum2-002-001.tiff',1);
% I=imread('../tmp_data/Compensated phase-pgpum2-003-001.tiff',1);

figure();
imshow(I,[])


mass_threshold=100;
tLo=-0.3;
tHi=-0.1;
max_LIT_threshold=2;
hole_area_threshold=50;

segm=qpi_iterative_segmenation_hysteresis(I,mass_threshold,tLo,tHi,max_LIT_threshold,hole_area_threshold,4);



imshow(segm,[])


% sig=10;
% filter_size= 2*ceil(3*sig)+1;
% h=(sig.^gamma)*fspecial('log', filter_size, sig);
% figure();
% imshow(-conv2(I,h,'same'),[])


s1=4;
s2=7;
lam=3;


% gamma=2;
% sigma=s1:s2;
% log_map=zeros([size(I) length(sigma)]);
% for k=1:length(sigma)
%     
%     
%     sig=sigma(k);
%     filter_size= 2*ceil(3*sig)+1;
%     h=(sig.^gamma)*fspecial('log', filter_size, sig);
%     
%     
%     pom=conv2_spec_symetric(I,h);
%     log_map(:,:,k)=pom;
%     
%     
% end
% log_map=-min(log_map,[],3);
% 
% figure;
% imshow(log_map,[])
% 
% 
% 
% 
% figure;
% imshow(I+lam*log_map,[])







