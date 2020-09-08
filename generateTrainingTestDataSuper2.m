clc,clear
load 'Indian_pines_gt.mat'
load 'Indian_pines_corrected.mat'
load('IndianTrainingIndexRandom1percent.mat')
load('IndianTestingIndexRandom1percent.mat')
load('labels_superpixel.mat')
%%
X = indian_pines_corrected;
image_gt = indian_pines_gt;
gt_flatten =image_gt(:);
[rows,cols,depth] = size(X);
alpha=10;
train_loc = trainingIndexRandom;
train_loc_rows = trainingIndexRandom_rows;
train_loc_cols = trainingIndexRandom_cols;
test_loc = testingIndexRandom;
test_loc_rows = testingIndexRandom_rows;
test_loc_cols = testingIndexRandom_cols;
labeled_loc = [trainingIndexRandom;testingIndexRandom];
whole_loc = double(1:rows*cols)';
%%
train_y = gt_flatten(train_loc)';
test_y = gt_flatten(test_loc)';
labeled_y = gt_flatten(labeled_loc)';

scale_num = size(labels_superpixel,1);
ensemble_num = scale_num*2+1;
train_num = size(train_y,2);
test_num = size(test_y,2);
labeled_num = size(labeled_y,2);
%% preprocessing
Data = X;
for i=1:depth
    Data(:,:,i) = (Data(:,:,i)-min(min(Data(:,:,i))))/ (max(max(Data(:,:,i)))-min(min(Data(:,:,i))));
end
%% spectral train data
spectral_data=reshape(Data,rows*cols,depth);
train_data_spectral = spectral_data(trainingIndexRandom,:);
test_data_spectral = spectral_data(testingIndexRandom,:);
whole_data_spectral = spectral_data;
%% 
spectral_data0 = cell(scale_num,1);
for k=1:scale_num
    spectral_data0{k,1}=zeros(rows*cols,depth);
end
soi_index = cell(scale_num,1);
for k = 1:scale_num 
    soi_index{k,1} = labels_superpixel{k,1}(whole_loc);
    soi_index{k,1}  = unique(soi_index{k,1});
end
%% mean and weighted mean of neighbor superpixels
labeled_data_neighbor_temp = cell(scale_num,1);
train_data_neighbor = cell(scale_num,1);
test_data_neighbor = cell(scale_num,1);
whole_data_neighbor = cell(scale_num,1);
train_data_super = cell(scale_num,1);
test_data_super = cell(scale_num,1);
whole_data_super = cell(scale_num,1);
%%
tic
for k = 1:scale_num
    labeled_data_neighbor_temp{k,1}=zeros(rows*cols,depth);
    train_data_neighbor{k,1}=zeros(train_num,depth);
    test_data_neighbor{k,1}=zeros(test_num,depth);
    whole_data_neighbor{k,1}=zeros(rows*cols,depth);
    train_data_super{k,1}=zeros(test_num,depth);
    train_data_super{k,1}=zeros(test_num,depth);
    whole_data_super{k,1}=zeros(rows*cols,depth);
    for j=1:size(soi_index{k,1},1)
        super_index = find(labels_superpixel{k,1}==soi_index{k,1}(j,1)); %location of soi_j
        spectral_data0{k,1}(super_index,:) = ...
            repmat(mean(spectral_data(super_index,:)),size(super_index ,1),1);  
        
        labeled_loc_in_spj = intersect(super_index,whole_loc);%labeled_loc in soi_j
       
        edge_location=nearindex(labels_superpixel{k,1},soi_index{k,1}(j,1));
        neighbor_region_index=unique(labels_superpixel{k,1}(edge_location));        

        neighbor_num = length(neighbor_region_index);
        pixel2 = zeros(neighbor_num,depth);
        for i=1:neighbor_num
            neighbor_super_index = find(labels_superpixel{k,1}==neighbor_region_index(i,1));
            pixel2(i,:) = mean(spectral_data(neighbor_super_index,:));
        end       
        pixel1= spectral_data(labeled_loc_in_spj,:);
        factors = getSam(pixel1,pixel2,alpha);
        labeled_data_neighbor_temp{k,1}(labeled_loc_in_spj,:) = factors*pixel2./sum(factors,2);
    end
    train_data_neighbor{k,1} = labeled_data_neighbor_temp{k,1}(trainingIndexRandom,:);
    test_data_neighbor{k,1} = labeled_data_neighbor_temp{k,1}(testingIndexRandom,:);  
    whole_data_neighbor{k,1} = labeled_data_neighbor_temp{k,1}(whole_loc,:);  
    train_data_super{k,1} = spectral_data0{k,1}(trainingIndexRandom,:);
    test_data_super{k,1} = spectral_data0{k,1}(testingIndexRandom,:); 
    whole_data_super{k,1} = spectral_data0{k,1}(whole_loc,:);  
end

Gtrainingtest_data_time = toc 
train_x = cell(ensemble_num,1);
train_x{1,1}=train_data_spectral;
for i =1:scale_num
    train_x{i+1,1}=train_data_super{i,1};
end
for j = 1:scale_num
    train_x{scale_num+1+j,1}=train_data_neighbor{j,1};
end
save train_x train_x
save train_y.mat train_y
test_x = cell(ensemble_num,1);
test_x{1,1}=test_data_spectral;
for i =1:scale_num
    test_x{i+1,1}=test_data_super{i,1};
end
for j = 1:scale_num
    test_x{scale_num+1+j,1}=test_data_neighbor{j,1};
end
save test_x test_x
save test_y.mat test_y

whole_x = cell(ensemble_num,1);
whole_x{1,1}=whole_data_spectral;
for i =1:scale_num
    whole_x{i+1,1}=whole_data_super{i,1};
end
for j = 1:scale_num
    whole_x{scale_num+1+j,1}=whole_data_neighbor{j,1};
end
save whole_x whole_x




