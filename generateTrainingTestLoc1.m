clear,clc
rng ('default');
rng(1);
load 'Indian_pines_gt.mat'
image_gt = indian_pines_gt;
training_rate=0.1;
%% preprocessing
num_class=max(max(image_gt));
[rows,cols]=size(image_gt);
%%
trainingIndexRandom=cell(num_class,1);
gt_flatten = reshape(image_gt,rows*cols,1);
for i =1:num_class
    index = find(gt_flatten==i);
    
    rndIDX = randperm(length(index));
    if length(index)>30
        train_num_class_i = round(15);
    else
        train_num_class_i = round(15);
    end
    trainingIndexRandom{i,1}= index(rndIDX(1:train_num_class_i));
end
%% Visualization
trainingIndexRandom=cell2mat(trainingIndexRandom);
rndIDXt = randperm(length(trainingIndexRandom));
trainingIndexRandom = trainingIndexRandom(rndIDXt);
[trainingIndexRandom_rows,trainingIndexRandom_cols] = ind2sub(size(image_gt),trainingIndexRandom);
save IndianTrainingIndexRandom1percent.mat trainingIndexRandom trainingIndexRandom_rows trainingIndexRandom_cols
wholeSample = find(gt_flatten~=0);
testingIndexRandom=setdiff(wholeSample,trainingIndexRandom);
[testingIndexRandom_rows,testingIndexRandom_cols] = ind2sub(size(image_gt),testingIndexRandom);
save IndianTestingIndexRandom1percent.mat testingIndexRandom testingIndexRandom_rows testingIndexRandom_cols

