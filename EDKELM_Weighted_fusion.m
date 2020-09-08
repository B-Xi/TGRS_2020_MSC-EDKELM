function [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy, oa, aa, ap,K, ua,ub]  = EDKELM(Regularization_coefficient,layers,Kernel_type, kernel_para,act_para)
%%%%%%%%%%% Load training dataset
load('IndianTrainingIndexRandom1percent.mat')
load('IndianTestingIndexRandom1percent.mat')
load('train_x.mat')
load('train_y.mat')
load('test_x.mat')
load('test_y.mat')
load 'Indian_pines_gt.mat'
load 'whole_x.mat'
image_gt = indian_pines_gt;
%% Initialization
C = Regularization_coefficient;
class_num=max(image_gt(:));
[rows,cols] = size(image_gt);
train_num=size(train_y,2);
test_num=size(test_y,2);
T = train_y;%(1,240)
TV.T = test_y; %(1,10009)
%% Preprocessing the data of classification
sorted_target=sort(cat(2,T,TV.T),2);
label=zeros(1,1);  % Find and save in 'label' class label from training and testing data sets
label(1,1)=sorted_target(1,1);
j=1;
for i = 2:(train_num+test_num)
    if sorted_target(1,i) ~= label(1,j)
        j=j+1;
        label(1,j) = sorted_target(1,i);
    end
end
%% Processing the targets of training
temp_T=zeros(class_num, train_num);
for i = 1:train_num
    for j = 1:class_num
        if label(1,j) == T(1,i)
            break;
        end
    end
    temp_T(j,i)=1;
end
T=temp_T*2-1;
%% Processing the targets of testing
temp_TV_T=zeros(class_num, test_num);
for i = 1:test_num
    for j = 1:class_num
        if label(1,j) == TV.T(1,i)
            break;
        end
    end
    temp_TV_T(j,i)=1;
end
TV.T=temp_TV_T*2-1;
%% Training Phase 
ensemble_num = size(train_x,1);
temp_inputLayer = cell(ensemble_num,1);
OutputWeight_final = cell(ensemble_num,1);
OutputWeight = cell(ensemble_num,layers-1);
Y = cell(ensemble_num,1);
tic;
for s = 1:ensemble_num
    temp_inputLayer{s,1} =zscore(train_x{s,1}');
    temp = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(1));
    OutputWeight{s,1}=(temp+speye(train_num)/C(1))\temp_inputLayer{s,1}';
    temp_inputLayer{s,1} =  (OutputWeight{s,1}*temp_inputLayer{s,1});
%     temp_inputLayer{s,1} = 1./(1+exp(-act_para(1)*temp_inputLayer{s,1})); % sigmoid function
%     temp_inputLayer{s,1} = max(temp_inputLayer{s,1},0);%relu 
%%  
    if layers>=3
        for i = 2:(layers-1)
            temp = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(i));
            OutputWeight{s,i} = (temp+speye(train_num)/C(i))\temp_inputLayer{s,1}';
            temp_inputLayer{s,1} =  (OutputWeight{s,i}*temp_inputLayer{s,1});
%           temp_inputLayer{s,1} = 1./(1+exp(-act_para(2)*temp_inputLayer{s,1})); % sigmoid function           
%           temp_inputLayer{s,1} = max(temp_inputLayer{s,1},0);%relu
        end
        temp = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(layers));
        OutputWeight_final{s,1}=((temp+speye(train_num)/C(layers))\(T'));
        Y{s,1} = OutputWeight_final{s,1}'*temp;                             %   Y: the actual output of the training data
        
    else
        %% Calculate the training output
        temp = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(layers));
        OutputWeight_final{s,1}=((temp+speye(train_num)/C(layers))\(T'));
        Y{s,1} = OutputWeight_final{s,1}'*temp;                             %   Y: the actual output of the training data
    end
end
TrainingTime=toc
%% Testing Phase 
TY = cell(ensemble_num,1);
tic;
for s = 1:ensemble_num
    Omega_test = (zscore(test_x{s,1}'))';    
    Omega_test =  (OutputWeight{s,1}*Omega_test' );
%     Omega_test = 1./(1+exp(-act_para(1)*Omega_test));%sigmoid function
%     Omega_test = max(Omega_test,0);%relu
    %%
    if layers>=3
        for i = 2:(layers-1)
            Omega_test =  (OutputWeight{s,i}*Omega_test);
%             Omega_test = 1./(1+exp(-act_para(2)*Omega_test));%sigmoid function
%             Omega_test = max(Omega_test,0);%relu
        end
        %%
        Omega_test = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(layers), Omega_test');
        
        TY{s,1}= OutputWeight_final{s,1}'*Omega_test; %   TY: the actual output of the testing data
    else
        Omega_test = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(layers), Omega_test');
        
        TY{s,1}= OutputWeight_final{s,1}'*Omega_test; %   TY: the actual output of the testing data
    end
end
TestingTime=toc
%% Calculate the training accuracy
A=zeros(ensemble_num,class_num);
label_expected_train = zeros(1,train_num);
label_actual_train = zeros(1,train_num);
for s = 1:ensemble_num
    MissClassificationRate_Training=0;
    for k = 1 : train_num
        [~, label_index_expected]=max(T(:,k));
        label_expected_train(1,k) = label_index_expected; 
        Y_temp = Y{s,1};
        [~, label_index_actual]=max(Y_temp(:,k));
        label_actual_train(1,k) = label_index_actual;
        if label_index_actual~=label_index_expected
            MissClassificationRate_Training=MissClassificationRate_Training+1;
        end
    end
    [~, ~, ~,~, ua,~]=confusion(label_expected_train,label_actual_train);
    A(s,:) = ua';
    TrainingAccuracy=1-MissClassificationRate_Training/train_num
end
U = A./sum(A,1);
%% Testing Whole output
wholeY = cell(ensemble_num,1);
tic;
for s = 1:ensemble_num
    Omega_whole = (zscore(whole_x{s,1}'))';   
    Omega_whole =  (OutputWeight{s,1}*Omega_whole' );
%     Omega_test = 1./(1+exp(-act_para(1)*Omega_test));%sigmoid function
%     Omega_test = max(Omega_test,0);%relu
    %%
    if layers>=3
        for i = 2:(layers-1)
            Omega_whole =  (OutputWeight{s,i}*Omega_whole);
%             Omega_test = 1./(1+exp(-act_para(2)*Omega_test));%sigmoid function
%             Omega_test = max(Omega_test,0);%relu
        end
        %%
        Omega_whole = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(layers), Omega_whole');
        
        wholeY{s,1}= OutputWeight_final{s,1}'*Omega_whole; %   TY: the actual output of the testing data
    else
        Omega_whole = kernel_matrix(temp_inputLayer{s,1}',Kernel_type, kernel_para(layers), Omega_whole');
        
        wholeY{s,1}= OutputWeight_final{s,1}'*Omega_whole; %   TY: the actual output of the testing data
    end
end
TestingTime=toc
%% output fusion whole map
OF_wholeYY = zeros(class_num, rows*cols);
for s= 1:ensemble_num
    OF_wholeYY = OF_wholeYY+ U(s,:)'.*wholeY{s,1};
end 
[~, whole_label_index_actual]=max(OF_wholeYY);
whole_predict_map = reshape(whole_label_index_actual,[rows,cols]);
whole_predict_map=label2color(whole_predict_map,'india');
figure
imagesc(whole_predict_map);
axis image
axis off
%% decsion fusion whole map
% DF_wholeYY = zeros(ensemble_num, rows*cols);
% for s=1:ensemble_num
%     [~, DF_wholeYY(s,:)]=max(wholeY{s,1});
% end
% whole_label_index_actual= mode(DF_wholeYY);
% whole_predict_map = reshape(whole_label_index_actual,[rows,cols]);
% whole_predict_map=label2color(whole_predict_map,'india');
% imagesc(whole_predict_map);
% axis image
% axis off
%% Single DKELM whole output
% [~, whole_label_index_actual]=max(wholeY{1,1});
% whole_predict_map = reshape(whole_label_index_actual,[rows,cols]);
% whole_predict_map=label2color(whole_predict_map,'india');
% figure
% imagesc(whole_predict_map);
% axis image
% axis off
% colormap('jet')
%% Calculate testing classification accuracy output fusion/single decision
%% single decision
% TYY=TY{1,1};
%% output fusion
TYY = zeros(class_num,test_num);
% for i=[1,2,3,4]
% for i=[1,5,6,7]
% for i=2:7
for i =1:ensemble_num
    TYY=TYY+U(i,:)'.*TY{i,1};
end
%% output fusion and single decision
MissClassificationRate_Testing=0;
label_expected = zeros(1,test_num);
label_actual = zeros(1,test_num);
for i = 1 : size(TV.T, 2)
    [~, label_index_expected]=max(TV.T(:,i));
    label_expected(1,i) = label_index_expected;
    [~, label_index_actual]=max(TYY(:,i));
    label_actual(1,i) = label_index_actual;
    if label_index_actual~=label_index_expected
        MissClassificationRate_Testing=MissClassificationRate_Testing+1;
    end
end
TestingAccuracy=1-MissClassificationRate_Testing/size(TV.T,2)
%% Decison fusion/Majority voting
% TY{ensemble_num+1,1}=TYY;
% label_expected = zeros(1,test_num);
% label_actual = zeros(1,test_num);
% MissClassificationRate_Testing=0;
% for i = 1 : test_num 
%     [~, label_index_expected]=max(TV.T(:,i));
%     label_expected(1,i) = label_index_expected;
%     for j=1:ensemble_num+1
%         TYY=TY{j,1};
%         [~, label_index_actual(j)]=max(TYY(:,i));
%     end
%     label_actual(1,i) = mode(label_index_actual);
%     if mode(label_index_actual)~=label_index_expected
%         MissClassificationRate_Testing=MissClassificationRate_Testing+1;
%     end
% end
% TestingAccuracy=1-MissClassificationRate_Testing/test_num
%% Calculate the classification measure index
[oa, aa, ap,K, ua,ub]=confusion(label_expected,label_actual);
pre_vector = reshape(image_gt,[1,rows*cols]);
for i = 1:test_num
    pre_vector(testingIndexRandom(i)) = label_actual(i);
end
predict_result = reshape(pre_vector,[rows,cols]);
predict_result=label2color(predict_result,'india');
figure
imagesc(predict_result);
axis image
axis off
colormap('jet')
%%
figure
image_gt=label2color(image_gt,'india');
imagesc(image_gt);
axis image
axis off
colormap('jet')

      
