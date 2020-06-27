function dice=segm_qpi_log_eval(II,GTT,lambda,sigmas,init_T,max_T,min_mass,min_hole,T_bg,h)

segmentation=zeros(size(GTT));
for k=1:size(II,3)

    segm=segm_qpi_log(II(:,:,k),lambda,sigmas,init_T,max_T,min_mass,min_hole,T_bg,h);
    
    segmentation(:,:,k)=segm;
    
end
[dice]=-dice_final_segmentation(GTT,segmentation);


end