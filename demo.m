%% Date 2024.9.19
%% Author: Yujie Zhang (Any question, please contact: yujie19981026@sjtu.edu.cn)
%% Affiliation: Shanghai Jiao Tong University
%% If you find our code is useful, please cite our paper: Perception-Guided Quality Metric of 3D Point Clouds Using Hybrid Strategy
%% ***************************************************************************************************************

clear

addpath('code/');
addpath('data/');
addpath(genpath('gspbox/'));

%% Parameter setting
param = {};
if ~isfield(param, 'type'), param.type = 'abspline3'; end % Wavelet type
if ~isfield(param, 'Nscales'), param.Nscales = 4; end % The number of wavelet subbands
if ~isfield(param, 'k'), param.k = 10; end % The KNN number for graph construction
if ~isfield(param, 'AR_order'), param.AR_order = 20; end % The order of auto-regressive model
if ~isfield(param, 'bin_num'), param.bin_num = 50; end % The bin number of WCM



%% Data loading
pt_r = pcread('longdress.ply'); % Reference PC
pt_d = pcread('longdress_vpcc_r01.ply'); % Distored PC
pt_fast = pcread('longdress_fps.ply'); % Sampled points


%% Running
PHM_score = PHM(pt_r, pt_d, pt_fast, param);
fprintf('PHM score is: %d\n',PHM_score);
