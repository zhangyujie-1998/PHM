function seed = RS_sampling(pc, L)

pc_coor = pc.Location;
count = pc.Count;
indx = datasample(1:count, L, 'Replace', false);
seed = pc_coor(indx,:);

