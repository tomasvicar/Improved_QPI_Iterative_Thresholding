clc;clear all;close all;


names=subdir('hotova/*.txt');

names={names(:).name};


for name =names
    name=name{1};
    fid = fopen(name,'r');
    tline = fgetl(fid);
    k=1;
    while ischar(tline)
        k=k+1;
        tline = fgetl(fid);
        if k==4
            difi=replace(tline,'quality/difficulty: ','');
            difi=str2num(difi(1));
            if difi<3
                name_data=[ name(1:end-29) '.tif'];
                name_mask=replace(name,'.txt','.png');
                
                tmp=split(name_data,'\');

                tmp=tmp{end};
                
                if rand>0.10
                    name_data_save=['resave\train\'  tmp];
                else
                    name_data_save=['resave\valid\'  tmp];
                end
                name_mask_save=replace(name_data_save,'.tif','.png');

                copyfile(name_data,name_data_save)
                copyfile(name_mask,name_mask_save)
                drawnow;
            end
        end
        
    end
    
end