function out=nearindex(X,n)
[x,y]=find(X==n);%等于n的[行序号，列序号]
sz=size(X);%原矩阵大小

out=[x-1,y];%行序号减一的坐标
out=[out;[x+1,y]];%行序号加一的坐标
out=[out;[x,y-1]];%列序号减一的坐标
out=[out;[x,y+1]];%列序号加一的坐标
out(find(out(:,1)<=0),:)=[];%去掉行序号小于等于0的坐标
out(find(out(:,2)<=0),:)=[];%去掉列序号小于等于0的坐标
out(find(out(:,1)>sz(1)),:)=[];%去掉行序号大于原矩阵行数的坐标
out(find(out(:,2)>sz(2)),:)=[];%去掉列序号大于原矩阵列数的坐标
out=unique(out(:,1)+(out(:,2)-1)*sz(1));%取并集
out=out(find(X(out)~=n));%去除坐标处为n的坐标