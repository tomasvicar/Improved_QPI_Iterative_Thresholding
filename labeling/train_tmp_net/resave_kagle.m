clc;clear all;close all;

folder='kagle_cells/stage1_train';

names=dir(folder);

names={names(3:end).name};

citac=0;
for k=1:length(names)
    disp([num2str(k) '/' num2str(length(names))])

    data_name=[folder '/' names{k} '/images/' names{k} '.png'];
    data=imread(data_name);
    if length(size(data))>2
        data=rgb2gray(data);
    end
    
    mask=false(size(data));
    names_mask=subdir([folder '/' names{k} '/masks/*.png']);
    names_mask={names_mask(:).name};
    for name_mask = names_mask
        tmp=imread(name_mask {1});
        tmp2=imdilate(tmp>0,strel('disk',1));
        mask(tmp2)=0;
        mask(tmp>0)=1;
    end

    
    if size(data,1)>=160&&size(data,2)>=160
       citac=citac+1;
       if rand>0.1
            imwrite(data,['resave_kagle/train/data/img_' num2str(citac) '.png'])
            imwrite(mask,['resave_kagle/train/gt/mask_' num2str(citac) '.png'])
       else
           imwrite(data,['resave_kagle/valid/data/img_' num2str(citac) '.png'])
           imwrite(mask,['resave_kagle/valid/gt/mask_' num2str(citac) '.png'])
       end
    end
    
end

