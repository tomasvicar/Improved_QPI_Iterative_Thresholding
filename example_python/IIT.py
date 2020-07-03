
from scipy.signal import convolve2d as conv2
from skimage.measure import label
from skimage.measure import regionprops
from scipy.ndimage import distance_transform_edt
from skimage.morphology import watershed
from skimage.morphology import h_minima
from skimage.morphology import binary_dilation

from utils.fspecial_log import fspecial_log
from utils.mass_filt import mass_filt
from utils.area_filt import area_filt
import numpy as np


    
def IIT(I,sigma,lambdaa,min_mass,h,T_bg,min_hole):
    I_bg=I
    
    
    
    conn=4
    gamma=2
    
    
    
    sig=sigma
    filter_size= 2*np.ceil(3*sig)+1
    hn=(sig**gamma)*fspecial_log(filter_size, sig)
        
    log_map=-conv2(I,hn, 'same','symm')
        
    
    
    I=I+lambdaa*log_map
    
    
    
    
    bin=I>T_bg
    
    
    bin = mass_filt(bin,I_bg+T_bg,min_mass,conn)
    bin = area_filt(bin==0,min_hole)==0
    
    
    
    L=label(bin)
    max_L=np.max(L);
    region_nums=np.arange(max_L)
    
    
    for T in np.arange(T_bg,np.max(I),0.03):
        
        bin=I>T
        
        bin = mass_filt(bin,I_bg+T_bg,min_mass,conn)
        
        s = regionprops(label(bin))
        centroids = np.array([c.centroid for c in s])
    
        centroids=np.round(centroids).astype(np.int)
        
        sz=I.shape
        
        centroids_bin=np.zeros(sz)
        if len(centroids.shape)>1:
            centroids_bin[centroids[:,0],centroids[:,1]]=1
        
        LL=label(bin)
        
        s = regionprops(L,centroids_bin)
        
        cents_num=np.array([c.mean_intensity*c.area for c in s])
        cents_num_tmp=np.zeros(cents_num.shape)
        cents_num_tmp[region_nums]=cents_num[region_nums]>1
        
        region_nums_tmp = np.argwhere(cents_num_tmp)[:,0]
    
    
        for region_num in region_nums_tmp:
            u=np.unique(LL[L==(region_num+1)])
            
            u=u[u>0]
            
            if len(u)>1:
                
                region_nums=np.delete(region_nums,np.argwhere(region_nums==region_num)[:,0])
                
                for k in u:
                    
                    max_L=max_L+1
                    
                    L[LL==k]=max_L
            
                    region_nums=np.append(region_nums,max_L-1)
            
            
    nucs=np.zeros(I.shape)
    for k in region_nums:
        nucs[L==(k+1)]=1
    D=distance_transform_edt(nucs)
    seeds=h_minima(-D, h)
    w=watershed(-D,label(seeds),watershed_line=True)
    nucs_tmp=(nucs>0)&(w>0)
    
    removed=nucs_tmp.astype(np.int)-mass_filt(nucs_tmp,I_bg+T_bg,min_mass,conn).astype(np.int)
    removed=binary_dilation(removed>0,np.ones((3,3),np.int))*nucs
    nucs=(nucs_tmp>0)|(removed>0)
    
    
    w=watershed(-I,label(nucs),watershed_line=True)>0
    bin=I_bg>T_bg
    bin = mass_filt(bin,I_bg+T_bg,min_mass,conn)
    bin = area_filt(bin==0,min_hole)==0
    segm=w*bin
    segm = mass_filt(segm,I_bg+T_bg,min_mass,conn)
    
    
    return segm