


function data = customreaderOut(name);
    
    data=uint8(imread(name));
    
    r=6;
    [x,y]=meshgrid(-r:r,-r:r);
    s=sqrt(x.^2+y.^2);
    s=s<=r;
    
    data=uint8(imclose(data>0,ones(3)))+uint8(imerode(data>0,s));
    
    
end
