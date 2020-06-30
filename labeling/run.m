clc;clear all;close all force;
addpath('utils')


folder='C:\Users\xvicar03\Desktop\tmp_antih\dense_for_labels';
folder_hlp='C:\Users\xvicar03\Desktop\tmp_antih\dense_for_labels_hlp';

kdo_to_klika='Vicar';




%vyberte si jestli chcete prochazet nazvy automaticky nebo si vybrat cisla
%obrazku - to je to druhe zakomentovane....


files=subdir([folder filesep '*.tif']);
files={files(:).name};

for img_num=15%length(files)
    
    img_name=files{img_num}
    
    I_tmp={};
    for frame_hlp=20:10:70
        
        img_name_tmp=img_name;
        img_name_tmp=replace(img_name_tmp,folder,folder_hlp);
        img_name_tmp=replace(img_name_tmp,'.tif',['_'  num2str(frame_hlp,'%03.f') '.tif']);
        
        I=imread(img_name_tmp);
        
        I_tmp=[I_tmp,I];
    end

    
    montage(I_tmp,'DisplayRange',[-0.3,2.2])
    
    

    app=segmentation_tool(img_name,kdo_to_klika);

end






% for img_num=26:31
%     
%     img_num
% 
%     img_name=[folder filesep 'img_' num2str(img_num,'%05.f') '.tif'];
% 
%     app=segmentation_tool(img_name,kdo_to_klika);
% 
% 
% 
% end









