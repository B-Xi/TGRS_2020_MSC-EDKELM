% demo for MSC-DKELM classification algorithm
%-----Brief description----------------------------------
%
% This demo implements the MSC-DKELM efficient hyperspectral image classification [1]
%
% More details in:
% 
% [1] B. Xi, J. Li, Y. Li, R. Song, W. Sun and Q. Du, 
%  Multiscale Context-aware Ensemble Deep KELM for Efficient Hyperspectral Image Classification.
% IEEE Transactions on Geoscience and Remote Sensing.
% DOI: 10.1109/TGRS.2020.3022029
%
% contact: jjli@xidian.edu.cn (Jiaojiao Li)
% contact: xibobo1301@foxmail.com (Bobo Xi)
% 
% Note: testing with Indian Pines data with names of Indian_pines_corrected.mat, Indian_pines_gt.mat 
% http://www.ehu.eus/ccwintco/index.php?title=Hyperspectral_Remote_Sensing_Scenes
%%
clear, clc
training_num = 15; % 15 samples per-class
generate_lables_superpixel0
generateTrainingTestLoc1
generateTrainingTestDataSuper2
test

