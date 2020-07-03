clc;clear all; close all;
addpath('utils')

path='Y:\CELL_MUNI\marek\new_09_04_19\data_send\A2780';

save_path='../dense_for_labels';
save_path_hlp='../dense_for_labels_hlp';

mkdir(save_path);
mkdir(save_path_hlp);

file_names=subdir([path filesep '*.tiff']);
file_names={file_names(:).name};

rng(42)
frame=5;

file_names=file_names(randperm(length(file_names)));

all_imgs={};

counter=0;
for file_num=1:length(file_names)
    
    file_name=file_names{file_num};
    
    
    I=imread(file_name,frame);

    dists=[Inf];
    for k=1:length(all_imgs)
        dists=[dists,sqrt(sum(sum((I-all_imgs{k}).^2)))];
        
    end
    
    dist=min(dists)
    
    is_not_in=dist>0;
    
    if is_not_in
        
        counter=counter+1;
        
        file_name_save=[save_path filesep 'img_' num2str(counter,'%03.f') '.tif'];

        imwrite_single(I,file_name_save)
        
        all_imgs=[all_imgs,I];
        
        for frame_hlp=20:10:70
            I=imread(file_name,frame_hlp);
            file_name_save=[save_path_hlp filesep 'img_' num2str(counter,'%03.f') '_'  num2str(frame_hlp,'%03.f') '.tif'];

            imwrite_single(I,file_name_save)
        end
    end
    
    
end



