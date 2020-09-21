Multiscale Context-aware Ensemble Deep KELM for Efficient Hyperspectral Image Classification, TGRS, 2020.
==
[Bobo Xi](https://scholar.google.com/citations?user=O4O-s4AAAAAJ&hl=zh-CN), [Jiaojiao Li](https://scholar.google.com/citations?user=Ccu3-acAAAAJ&hl=zh-CN&oi=sra), [Yunsong Li](https://dblp.uni-trier.de/pid/87/5840.html), [Rui song](https://scholar.google.com/citations?user=_SKooBYAAAAJ&hl=zh-CN), [Weiwei Sun](https://dblp.org/pid/63/6566-5.html) and [Qian Du](https://scholar.google.com/citations?user=0OdKQoQAAAAJ&hl=zh-CN).

***
Code for paper: Multiscale Context-aware Ensemble Deep KELM for Efficient Hyperspectral Image Classification (later it will be released).

<div align=center><img src="/Image/framework.jpg" width="80%" height="80%"></div>
Fig. 1: Illustration of the proposed multiscale context-aware ensemble deep KELM frameworks. Weighted output layer fusion strategy (WOLFS).

Training and Test Process
--
Please simply run the 'run_demo.m' to reproduce our MSC-EDKELM results on [IndianPines](http://www.ehu.eus/ccwintco/index.php?title=Hyperspectral_Remote_Sensing_Scenes#Indian_Pines) dataset. You can obtain the classification accuracies (15 training samples per class) and the corresponding classification maps shown below. We have successfully test it on Ubuntu 16.04 and Windows systems with Matlab R2017b.

<div align=center><p float="center">
<img src="/Image/falsecolorimage.jpg" width="200"/>
<img src="/Image/IndianP_gt.jpg" width="200"/>
<img src="/Image/trainingMap.jpg" width="200"/>
<img src="/Image/classification_map.jpg" width="200"/>
</p></div>
<div align=center>Fig. 2: The composite false-color image, groundtruth, training samples, and classification map of Indian Pines dataset.</div>
      
References
--
If you find this code helpful, please kindly cite:

[1] B. Xi, J. Li, Y. Li, R. Song, W. Sun and Q. Du, “Multiscale Context-aware Ensemble Deep KELM for Efficient Hyperspectral Image Classification,” IEEE Transactions on Geoscience and Remote Sensing, 2020. DOI: 10.1109/TGRS.2020.3022029.
[2] Li, J.; Xi, B.; Du, Q.; Song, R.; Li, Y.; Ren, G. Deep Kernel Extreme-Learning Machine for the Spectral–Spatial Classification of Hyperspectral Imagery. Remote Sens. 2018, 10, 2036. [DOI: 10.3390/rs10122036](https://www.mdpi.com/2072-4292/10/12/2036).

Citation Details
--
BibTeX entry:
```
@article{Li_2018,   
title={Deep Kernel Extreme-Learning Machine for the Spectral–Spatial Classification of Hyperspectral Imagery},   
volume={10}, ISSN={2072-4292},   
url={http://dx.doi.org/10.3390/rs10122036},   
DOI={10.3390/rs10122036},   
number={12}, journal={Remote Sensing}, publisher={MDPI AG},   
author={Li, Jiaojiao and Xi, Bobo and Du, Qian and Song, Rui and Li, Yunsong and Ren, Guangbo},   
year={2018},month={Dec},pages={2036}}
```

Licensing
--
Copyright (C) 2020 Bobo Xi and Jiaojiao Li

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.
