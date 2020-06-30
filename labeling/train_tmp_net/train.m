

clc;clear all;close all force;



folder_train='resave/train';
folder_valid='resave/valid';




miniBatchSize=24;
patchSize=[160 160];
augment=[1,1,1];
% epoch=33;
% drop_period=10;
epoch=500;
drop_period=100;
% epoch=24;
% drop_period=7;
drop_faktor=0.3;
init_lr=0.001;


inDs = imageDatastore(folder_train ,'FileExtensions','.tif');
outDs = imageDatastore(folder_train ,'FileExtensions','.png','ReadFcn',@customreaderOut);


unique_lbls=[];
global max_val_lbl min_val_lbl
for i = 1:length(outDs.Files)
    img = readimage(outDs,i);
%     imshow(img,[])
%     drawnow
    u_tmp=unique(img);
    unique_lbls=unique([u_tmp;unique_lbls]);
%     unique_lbls
    max_val_lbl=max([max_val_lbl,max(img(:))]);
    min_val_lbl=min([min_val_lbl,min(img(:))]);
end

global uniques

uniques=unique_lbls;

global max_val min_val
for i = 1:length(inDs.Files)
    img = readimage(inDs,i);
    max_val=max([max_val,max(img(:))]);
    min_val=min([min_val,min(img(:))]);
end





lbl = readimage(outDs,1);
if length(unique_lbls)>20
    classif=0;
    outputs=1;
else
    classif=1;
    outputs=length(unique_lbls);
end


classNames={};
if classif
    for k=1:length(unique_lbls)
    classNames=[classNames char(['x' num2str(unique_lbls(k))])];
    end
end
pixelLabelIDs=unique_lbls;


in_size=[patchSize,size(img,3)];
% net=unet(in_size,4,32,outputs,classif);
load('net_April-07-2020-11-35-20-466.mat','net');
net=layerGraph(net);

inDs = imageDatastore([folder_train ],'FileExtensions','.tif','ReadFcn',@customreaderIn);
if classif
    outDs = pixelLabelDatastore([folder_train ],classNames,pixelLabelIDs,'FileExtensions','.png','ReadFcn',@customreaderOutClassif);    
else
    outDs = imageDatastore([folder_train ],'FileExtensions','.png','ReadFcn',@customreaderOut);
end

augmenter = imageDataAugmenter('RandRotation',@()randi([0,3*double(augment(1))],1)*90,'RandXReflection',augment(2),'RandYReflection',augment(3));

patchds = randomPatchExtractionDatastore(inDs,outDs,patchSize,'PatchesPerImage',1,'DataAugmentation',augmenter);
patchds.MiniBatchSize = miniBatchSize;



img = readimage(inDs,1);




if length(folder_valid)>0
    inDs_v = imageDatastore([folder_valid ],'FileExtensions','.tif','ReadFcn',@customreaderIn);
    if classif
        outDs_v = pixelLabelDatastore([folder_valid ],classNames,pixelLabelIDs,'FileExtensions','.png','ReadFcn',@customreaderOutClassif);    
    else
        outDs_v = imageDatastore([folder_valid ],'FileExtensions','.png','ReadFcn',@customreaderOut);
    end
    patchds_val = randomPatchExtractionDatastore(inDs_v,outDs_v,patchSize,'PatchesPerImage',1);
    patchds_val.MiniBatchSize = miniBatchSize;
end

img1 = readimage( inDs_v,1);

img2 = readimage( outDs_v,1);

valid_freq=30;

if length(folder_valid)>0
options = trainingOptions('adam', ...
    'InitialLearnRate', init_lr, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',drop_faktor, ...
    'LearnRateDropPeriod',drop_period, ...
    'GradientDecayFactor',0.9, ...
    'SquaredGradientDecayFactor',0.99, ...
    'L2Regularization', 1e-8, ...
    'Shuffle', 'every-epoch', ...
    'VerboseFrequency', 1, ...
    'MiniBatchSize', miniBatchSize, ...
    'ValidationData',patchds_val,...
    'ValidationFrequency',valid_freq,...
    'MaxEpochs', epoch, ...
    'Plots','training-progress'); 




else
options = trainingOptions('adam', ...
    'InitialLearnRate', init_lr, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',drop_faktor, ...
    'LearnRateDropPeriod',drop_period, ...
    'GradientDecayFactor',0.9, ...
    'SquaredGradientDecayFactor',0.99, ...
    'L2Regularization', 1e-8, ...
    'Shuffle', 'every-epoch', ...
    'VerboseFrequency', 1, ...
    'MiniBatchSize', miniBatchSize, ...
    'MaxEpochs', epoch, ...
    'Plots','training-progress');    
    
end


   
[net, info] = trainNetwork(patchds,net,options);


folder_net=folder_train;
folder_net=[folder_net '_net'];
mkdir(folder_net)
name_save=[folder_net '/net_' datestr(now,'mmmm-dd-yyyy-HH-MM-SS-FFF') '.mat'];
save(name_save,'net','max_val','min_val','min_val_lbl','max_val_lbl','classif','uniques','pixelLabelIDs','classNames','patchSize')


predict_net([folder_valid ],[folder_valid ],name_save);


% 93.83


