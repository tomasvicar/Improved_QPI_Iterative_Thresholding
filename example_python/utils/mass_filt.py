from skimage.measure import label
from skimage.measure import regionprops


def mass_filt(b,I,thresh,conn):
    
    L=label(b>0,connectivity=int(conn/4))
    
    
    p = regionprops(L,I)
    
    
    for i,pp in enumerate(p):
        
        mass=pp.area*pp.mean_intensity
        
        if mass<thresh:
            
            b[L==(i+1)]=0
    
    
    return b
    
    