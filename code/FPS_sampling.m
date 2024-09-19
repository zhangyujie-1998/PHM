function samplePointCloud = FPS_sampling(pc, ratio)


Data=pc.Location;    
Count = pc.Count;

pointNum = round(Count/ratio);
n = size(Data,1);
idx = randperm(n,1);
samplePC = Data(idx,:);
Data(idx,:) = [];       
for i=1:pointNum-1  
    sampleKD = KDTreeSearcher(samplePC);        
    [~,dist] = knnsearch(sampleKD,Data,'K',1);
    [maxVal,maxIndex] = max(dist);
    samplePC = [samplePC;Data(maxIndex,:)];
    Data(maxIndex,:) = [];
end

samplePointCloud = pointCloud(samplePC);

