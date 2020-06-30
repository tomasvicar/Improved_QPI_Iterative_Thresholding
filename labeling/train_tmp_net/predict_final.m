clc;clear all;close all;

names=subdir('C:\Users\xvicar03\Desktop\tmp_antih\dense_for_labels/*.tif');

names={names(:).name};

global uniques max_val min_val max_val_lbl min_val_lbl

net_path='net_April-07-2020-12-33-59-857.mat';
load(net_path,'net','max_val','min_val','min_val_lbl','max_val_lbl','classif','uniques','pixelLabelIDs','classNames','patchSize','ext')


border=floor(patchSize(1)/8);

vahokno=2*ones(patchSize);
vahokno=conv2(vahokno,ones(2*border+1)/sum(sum(ones(2*border+1))),'same');
vahokno=vahokno-1;
vahokno(vahokno<0.01)=0.01;

for k=1:length(names)
    
    name=names{k};
    img = customreaderIn(name);

    
    img_size=[size(img,1) size(img,2)];
    
    
    
%     poskladany_p=zeros(img_size);
    
    
    poskladany=zeros(img_size);
    podelit=zeros(img_size);
    
   


    posx_start=1:patchSize(1)-border-2:img_size(1);
    posx_start=posx_start(1:end-1);
    posx_end=posx_start+patchSize(1)-1;
    posx_end= [posx_end img_size(1)];
    posx_start=[posx_start posx_end(end)-patchSize(1)+1];


    posy_start=1:patchSize(2)-border-2:img_size(2);
    posy_start=posy_start(1:end-1);
    posy_end=posy_start+patchSize(2)-1;
    posy_end= [posy_end img_size(2)];
    posy_start=[posy_start posy_end(end)-patchSize(2)+1];

    k=0;
    for x=posx_start
        k=k+1;
        xx=posx_end(k);
        kk=0;
         for y=posy_start
            kk=kk+1;
            yy=posy_end(kk);


            imgg = img(x:xx,y:yy,:);

            if classif
%                 img_out_tmp=predict(net,imgg);
%                 [~,img_out_tmp]=max(img_out,[],3);
%                 img_out=zeros(size(img,1),size(img,2),'single');
                  [img_out_tmp,~,scores] = semanticseg(imgg,net);
                  img_out=zeros(size(img_out_tmp,1),size(img_out_tmp,2),'single');
                  for kq=1:length(classNames)               
                      img_out(img_out_tmp==classNames(kq))=pixelLabelIDs(kq);
                  end
                  
                
            else
                img_out=((predict(net,imgg)+0.5)*single((max_val_lbl-min_val_lbl)))+single(min_val_lbl);
            end
            
%             poskladany_p(x:xx,y:yy)=poskladany_p(x:xx,y:yy)+scores(:,:,2).*vahokno;
            
            poskladany(x:xx,y:yy)=poskladany(x:xx,y:yy)+img_out.*vahokno;
            podelit(x:xx,y:yy)=podelit(x:xx,y:yy)+vahokno;


         end
    end
    
%     p_final=poskladany_p./podelit;

    img_final=poskladany./podelit;
    
    
    if 0
        if classif
            gt_tmp = readimage(outDs,i);
            gt=zeros(size(gt_tmp,1),size(gt_tmp,2),'single');
            for kq=1:length(classNames)               
                gt(gt_tmp==classNames(kq))=pixelLabelIDs(kq);
            end
                
            
        else
            gt = readimage(outDs,i);
            gt=(gt+0.5)*single((max_val_lbl-min_val_lbl))+single(min_val_lbl);
        end
        img_final_show=cat(2,((img(:,:,1)+0.5)*single((max_val_lbl-min_val_lbl)))+single(min_val_lbl),img_final,gt);
    else
        img_final_show=img_final;
    end
    
    imshow(img_final,[])
    
    
    name_save=name;
    name_save=replace(name_save,'.tif','_mask.png');
    
    imwrite(uint8(img_final),name_save)
    
end



