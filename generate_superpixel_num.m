function N = generate_superpixel_num(delta, Res,image_gt,scale_num)
% Houston 2012
% load './HU2012/2012_Houston.mat'
% image_gt = gt_2012;
% Res = 2.5;
%% PaviaU
% load './UP/PaviaU_gt.mat'
% image_gt = paviaU_gt;
% Res = 1.3;
% %% Indianpines
% load('Indian_pines_gt.mat')
% image_gt = indian_pines_gt;
% Res = 20;
% %% YanCity
% load './YC/YC_samples.mat'
% image_gt=YC_samples;
% Res = 30;
% %%
% delta = 0.9;
% scale_num = 3;
%%
[rows, cols]=size(image_gt);
S = floor(100*delta^(Res^(1/2)));
N = zeros(1,scale_num);
for i =1:scale_num
    N(1,i)= floor(rows*cols/(2^(i-1)*S));
end