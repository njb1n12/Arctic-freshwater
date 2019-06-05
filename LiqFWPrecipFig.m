%% Produces plots for Fig 4c: liquid FWC anomalies in precipitation experiments
% 21 March 18 
% Augmented 21 May 18 to include CORE precipitation runs
% Amended 5 Sep 18 to use Colorbrewer colours

clear all; clc

%% Load data

load Data/FWLvol_AO_Sref35_PembertonNilsson.mat;  % For original set of experiments
FW_AR = ncread('fwvolume_Sref35_AR.nc','freshwater'); % For JRA runs
FW_B7 = ncread('fwvolume_Sref35_B7.nc','freshwater'); % Precip only 
FW_C8 = ncread('fwvolume_Sref35_C8.nc','freshwater');
FW_A_R_CORE = ncread('fwvolume_Sref35_AR_CORE.nc','freshwater'); % For CORE runs
FW_P30dec = ncread('fwvolume_Sref35_P-30_CORE.nc','freshwater'); % Precip only
FW_P30inc = ncread('fwvolume_Sref35_P+30_CORE.nc','freshwater');

A_R_wholeArc = (squeeze(FW_AR(1,19,:)))*1e-12; % Take subset for whole domain and integration to -277m and convert to 10^3 km^3
B_7_wholeArc = (squeeze(FW_B7(1,19,:)))*1e-12;  
C_8_wholeArc = (squeeze(FW_C8(1,19,:)))*1e-12;
A_R_CB = (squeeze(FW_AR(6,19,:)))*1e-12; % Take subset Canada Basin and integration to -277m and convert to 10^3 km^3
B_7_CB = (squeeze(FW_B7(6,19,:)))*1e-12;  
C_8_CB = (squeeze(FW_C8(6,19,:)))*1e-12;
A_R_CORE_wholeArc = (squeeze(FW_A_R_CORE(1,19,1:419)))*1e-12;
P30dec_wholeArc = (squeeze(FW_P30dec(1,19,1:419)))*1e-12;
P30inc_wholeArc = (squeeze(FW_P30inc(1,19,1:419)))*1e-12;
A_R_CORE_CB = (squeeze(FW_A_R_CORE(6,19,1:419)))*1e-12;
P30dec_CB = (squeeze(FW_P30dec(6,19,1:419)))*1e-12;
P30inc_CB = (squeeze(FW_P30inc(6,19,1:419)))*1e-12;

% Define month number to plot against
mth = linspace(1,419,419)';

%% Take differences between expt results and reference case

B_7_diff = B_7_wholeArc - A_R_wholeArc;
C_8_diff = C_8_wholeArc - A_R_wholeArc;
P30dec_diff = P30dec_wholeArc - A_R_CORE_wholeArc;
P30inc_diff = P30inc_wholeArc - A_R_CORE_wholeArc;

%% Set colours for figures

% Set colours
red = [0.894 0.102 0.110];
blue = [0.216 0.494 0.722];
green = [0.302 0.686 0.290];
purple = [0.596 0.306 0.639];
orange  = [1.000 0.498 0.000];

%% Plot figure

% Figure: precipitation results for DRAFT PAPER
f1 = figure('units','normalized','position',[0.06,0.06,0.75,0.65]);
ax2 = axes('units','normalized','position',[0.09 0.06 0.90 0.90]);
ax2.YLim = [0 5.5];
ax2.XLim = [0 419];
hold on
p2 = plot(mth, P30dec_diff.*-1,'b-',mth,P30inc_diff,'m-',mth,B_7_diff.*-1,'k-',mth,C_8_diff,'k-','Linewidth',4);
p2(1).Color = [0.302 0.686 0.290];
p2(2).Color = [0.596 0.306 0.639];
p2(3).Color = [0.216 0.494 0.722];
p2(4).Color = [0.894 0.102 0.110];
ax2.FontWeight = 'normal';
ax2.FontSize = 20;
ax2.XTick = [0 60 120 180 240 300 360];
ax2.XTickLabel = {'0','5','10','15','20','25','30'};
ax2.YLabel.String = 'Adjusted \DeltaV_{F} (x 10^3 km^3)';
ax2.YLabel.Position = (get(ax2.YLabel,'Position')) + [-5 0 0]; % Shift the label out to make the numbers easier to read
grid on
leg = legend('  -30% CORE','  +30% CORE','  -30% JRA','  +30% JRA','Location','northwest');
Pl = get(leg,'Position');
%leg.Position(1) = leg.Position(1) - 0.045;
leg.Position(2) = leg.Position(2) - 0.030;
leg.Position(3) = leg.Position(3) + 0.025;
leg.Position(4) = leg.Position(4) + 0.030;
box on
