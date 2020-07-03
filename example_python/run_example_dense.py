import numpy as np
from skimage.io import imread
import matplotlib.pyplot as plt

from PIL import Image

from utils.visboundaries import visboundaries
from utils.colorize_notouchingsamecolor import colorize_notouchingsamecolor

from IIT import IIT


I=imread('../data_dense/img_013.tif')
GT=imread('../data_dense/img_013.png')



I=I[99:,:]
GT=GT[99:,:]




sigma=2.08
lambdaa=5.087
min_mass=79.68
h=0.964

T_bg=0.05
min_hole=60


segm=IIT(I,sigma,lambdaa,min_mass,h,T_bg,min_hole)


colormap_cells=[[1,0,0],[0,1,0],[0,0,1],[0.8314,0.8314,0.0588],[1,0,1],[1,0.5,0],[0.00,1.00,1.00],[0.45,0.00,0.08]]


L=colorize_notouchingsamecolor(segm>0)
    
plt.figure(figsize=(12,12))
plt.imshow(I)
for k,c in enumerate(colormap_cells):
    visboundaries(L==(k+1),color=c)
plt.show()



