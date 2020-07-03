clc;clear all;close all force;



clc;clear all;close all force;
colormap_cells=[1 0 0;0 1 0;0 0 1;0.8314 0.8314 0.0588;1 0 1;1,0.5,0;0.00,1.00,1.00;0.45,0.00,0.08];
contour_line_width=1.5;
N=size(colormap_cells,1);
segms={};
norm=[-0.3,2];
siz=60;

k=0;
for kk=4:18
    k=k+1;
    II(:,:,k)=imread(['../../data_reveiw/qpi' num2str(kk) '.tif']);
    GTT(:,:,k)=imread(['../../data_reveiw/qpi' num2str(kk) '_maska.png']);
end
min_hole=60;
T_bg=0.05;



k=0;
for kk=6:14
    k=k+1;
    II(:,:,k)=imread(['../../data_dense/img_' num2str(kk,'%03.f') '.tif']);
    tmp=imread(['../../data_dense/img_' num2str(kk,'%03.f') '.png'])>0;
    GTT(:,:,k)=bwareaopen(tmp,30);
end
min_hole=60;
T_bg=0.05;


% img_num=8;
% pos=[58,17];



img_num=6;
pos=[209,292];

load('params_proposed2_dense.mat')
x=results.XAtMinObjective;

sigmas=x.sigmas;
lambda=x.lambda;
min_mass=x.min_mass;
h=x.h;


I=II(:,:,img_num);


input=I(pos(1):pos(1)+siz,pos(2):pos(2)+siz);




I_bg=I;



conn=4;
gamma=2;


log_map=zeros([size(I) length(sigmas)]);
for k=1:length(sigmas)
    
    
    sig=sigmas(k);
    filter_size= 2*ceil(3*sig)+1;
    hn=(4.^gamma)*fspecial('log', filter_size, sig);
    
    
    pom=conv2_spec_symetric(I,hn);
    log_map(:,:,k)=pom;
    
    
end
log_map=-min(log_map,[],3);

Ie=I+10*log_map;

enhanced_more=Ie(pos(1):pos(1)+siz,pos(2):pos(2)+siz);





conn=4;
gamma=2;

log_map=zeros([size(I) length(sigmas)]);
for k=1:length(sigmas)
    
    
    sig=sigmas(k);
    filter_size= 2*ceil(3*sig)+1;
    hn=(sig.^gamma)*fspecial('log', filter_size, sig);
    
    
    pom=conv2_spec_symetric(I,hn);
    log_map(:,:,k)=pom;
    
    
end
log_map=-min(log_map,[],3);

I=I+lambda*log_map;

enhanced=I(pos(1):pos(1)+siz,pos(2):pos(2)+siz);


bin=I>T_bg;
% bin =  bwareaopen(bin,min_size);
bin=mass_filt(bin,I_bg+T_bg,min_mass,conn);
bin =  ~bwareaopen(~bin,min_hole);

bg=bin(pos(1):pos(1)+siz,pos(2):pos(2)+siz);


L=uint16(bwlabel(bin));
max_L=max(L(:));
region_nums=1:max_L;
for T=T_bg:0.03:max(I(:))
    
    bin=I>T;   
%     bin =  bwareaopen(bin,min_size);
    bin=mass_filt(bin,I_bg+T_bg,min_mass,conn);
    s = regionprops(bin,'Centroid');
    centroids = round(cat(1,s(:).Centroid));
    sz=size(I);
    centroids_bin=zeros(size(I));
    try
        centroids_bin(sub2ind(sz,centroids(:,2),centroids(:,1)))=1;
    end
    LL=bwlabel(bin);
    
    s = regionprops(L,centroids_bin,'MeanIntensity','Area');
    cents_num = cat(1,s(:).MeanIntensity).*cat(1,s(:).Area);
    cents_num_tmp=zeros(size(cents_num));
    cents_num_tmp(region_nums)=cents_num(region_nums)>1;
    region_nums_tmp=find(cents_num_tmp)';
    
    for region_num=region_nums_tmp
        u=unique(LL(L==region_num));
        u(u==0)=[];
        if length(u)>1
            region_nums(region_nums==region_num)=[];

            for k=1:length(u)
                max_L=max_L+1;
                L(LL==u(k))=max_L;
                region_nums=[region_nums,max_L];
            end
        end
    end
end



nucs=false(size(I));
for k=region_nums
    nucs(L==k)=1;
end

not_separated=nucs(pos(1):pos(1)+siz,pos(2):pos(2)+siz);


D=bwdist(~nucs);
D=imhmin(-D,h);
w=watershed(D);
w=imerode(w>0,strel('disk',1));
nucs_tmp=nucs&w>0;
% removed=nucs_tmp-bwareaopen(nucs_tmp,min_size);
removed=nucs_tmp-mass_filt(nucs_tmp,I_bg+T_bg,min_mass,conn);
removed=imdilate(removed,ones(3)).*nucs;
nucs=nucs_tmp|removed;


separated=nucs(pos(1):pos(1)+siz,pos(2):pos(2)+siz);



w = imimposemin(-I, nucs);
w=watershed(w)>0;
bin=I_bg>T_bg;
% bin =  bwareaopen(bin,min_size);
bin=mass_filt(bin,I_bg+T_bg,min_mass,conn);
bin =  ~bwareaopen(~bin,min_hole);
segm=w.*bin;
segm=mass_filt(segm,I_bg+T_bg,min_mass,conn);


final=segm(pos(1):pos(1)+siz,pos(2):pos(2)+siz);




figure();
imshow(input,[])

figure();
imshow(bg,[])


figure();
imshow(enhanced,[])


figure();
imshow(enhanced_more,[])


figure();
imshow(not_separated,[])



figure();
imshow(separated,[])



figure();
imshow(final,[])

mix=zeros(size(separated));
mix(bg>0)=1;
mix(separated>0)=2;


imwrite(uint8(mat2gray(input)*255),'../../tmp_imgs/input.png')
imwrite(uint8(mat2gray(bg)*255),'../../tmp_imgs/bg.png')
imwrite(uint8(mat2gray(enhanced)*255),'../../tmp_imgs/enhanced.png')
imwrite(uint8(mat2gray(enhanced_more)*255),'../../tmp_imgs/enhanced_more.png')
imwrite(uint8(mat2gray(not_separated)*255),'../../tmp_imgs/not_separated.png')
imwrite(uint8(mat2gray(separated)*255),'../../tmp_imgs/separated.png')
imwrite(uint8(mat2gray(final)*255),'../../tmp_imgs/final.png')
imwrite(uint8(mat2gray(mix)*255),'../../tmp_imgs/mix.png')

segmentaion=colorize_notouchingsamecolor(final,8);

figure
imshow(input,[])
hold on
for k=1:N
    visboundaries(segmentaion==k,'Color',colormap_cells(k,:),'EnhanceVisibility',0,'LineWidth',contour_line_width);
end
print('../../tmp_imgs/final_cont','-depsc')

