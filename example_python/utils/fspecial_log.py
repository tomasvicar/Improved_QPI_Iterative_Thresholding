import numpy as np


def fspecial_log(p2,p3):
    siz   = [(p2-1)/2,(p2-1)/2]
    std2   = p3**2
    
    x,y = np.meshgrid(np.arange(-siz[1],siz[1]+1),np.arange(-siz[0],siz[0]+1))
    arg   = -(x*x + y*y)/(2*std2)
    
    h     = np.exp(arg)
    h[h<np.finfo(np.float64).eps*np.max(h)] = 0

    sumh=np.sum(h)
    if sumh is not 0:
        h  = h/sumh
        
    h1 = h*(x*x + y*y - 2*std2)/(std2**2)
    h     = h1 - np.sum(h1)/p2**2
    
    return h
