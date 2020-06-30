clc;clear all;close all;


data=uint8(imread('resave/valid/img_00032.png'));
    
r=6;
[x,y]=meshgrid(-r:r,-r:r);
s=sqrt(x.^2+y.^2);
s=s<=r;

data=uint8(imclose(data>0,ones(3)))+uint8(imerode(data>0,s));
    
    
I=imread('resave/valid/img_00032.tif');  

figure
imshow(I,[])
figure
imshow(data,[])