clear
rng(0)

addpath('code/');
addpath('data/');


save_path = 'data/longdress_fps.ply';
pc = pcread('longdress.ply');
    
pc_sample = FPS_sampling(pc, 1000);


pcwrite(pc_sample, save_path);




