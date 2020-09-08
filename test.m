clc
clear 
%% 15samples per-class  % majority voting:94.13% weighted fusion:94.66%
[TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy, oa, aa, ap,K, ua,ub]  =...
    EDKELM_Weighted_fusion([1,100,10000], 3, 'RBF_kernel',[1e2, 1e5, 1e7],[5,10]);
result1= [ua;aa;oa;K;TrainingTime;TestingTime];
result2= [ub;ap];
%% parameter-tuning
% regular1 = [1e-4, 1e-3,1e-2,1e-1,1,10,100,1000,10000];
% regular2 = [1e-4, 1e-3,1e-2,1e-1,1,10,100,1000,10000];
% regular3 = [1e-4, 1e-3,1e-2,1e-1,1,10,100,1000,10000];
% h=1
% rhoAcc = zeros(9^3,4);
% TestingAccuracy=zeros(9^3,1);
% for i=1:length(regular1)
%     for j=1:length(regular2)
%         for k=1:length(regular3)
%             [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy, oa, aa, ap,K, ua,ub]  =...
%                 EDKELM_Weighted_fusion([regular1(i),regular2(j),regular3(k)], 3, 'RBF_kernel',[1e2, 1e5, 1e7],[5,10]);
%             rhoAcc(h,:)=[regular1(i),regular2(j),regular3(k),TestingAccuracy];
%             h=h+1
%         end
%     end
% end

