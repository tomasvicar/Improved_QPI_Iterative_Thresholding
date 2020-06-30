clc;clear all;close all;




names=subdir('na_predikci/*.tif');

names={names(:).name};
for k=1:length(names)
    
    name=names{k};
    img = imread(name);
    
    name_save=name;
    name_save=replace(name_save,'.tif','_mask.png');
    
    mask=imread(name_save);
    
    
    centers=mask==2;
    
    
    centers=~bwareafilt(~centers,[100,Inf]);
    
    
    d=bwdist(~centers);
    d=-1*imhmax(d,7);
    w=watershed(d)>0;
    centers=w&centers;
    

    centers=bwareafilt(centers,[70,Inf]);
    


    
         
    r=3;
    [x,y]=meshgrid(-r:r,-r:r);
    s=sqrt(x.^2+y.^2);
    s=s<=r;
    
    
    whole=imclose(mask>0,s);
    
    
    whole=~bwareafilt(~whole,[70,Inf]);

    whole=bwareafilt(whole,[120,Inf]);
    
    
    
    d = bwdistgeodesic(whole,centers);
    d=d;
    d(isnan(d))=99999999;
    w=watershed(d)>0;
    final=w&whole;

    imshow(final,[])
    
    
    
    
end
    
    
    