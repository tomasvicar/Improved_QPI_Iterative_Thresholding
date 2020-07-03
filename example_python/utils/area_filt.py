from skimage.measure import label
from skimage.measure import regionprops

def area_filt(b,thresh):
    
    L=label(b>0,connectivity=2)
    
    
    p = regionprops(L)
    
    
    for i,pp in enumerate(p):
        
        area=pp.area
        
        if area<thresh:
            
            b[L==(i+1)]=0
    
    
    return b