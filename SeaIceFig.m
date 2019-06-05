%% Produces plots for Fig 5: sea ice FW volumes for the reference case and anomalies for key experiments
% 20 September 2016
% Augmented 24 May 2019 to produce paper plots

clear all; clc

% Define month number to plot against
mth = linspace(1,419,419)';

%% Sea ice to liquid freshwater conversion

Rho_ice = 0.90; % kg m^-3
Rho_liq = 1.007; % kg m^3 for 0 degC and 6 g kg^-1 
S_ice = 6; % Assumed salinity of sea ice
S_ref = 35; % Reference salinity
conv = ((S_ref - S_ice)/S_ref)*(Rho_ice/Rho_liq); % conversion factor

%% Load data

IceVolAllAR = ncread('area_int_AR.nc','ivol');  
IceVolAO_ARm3 = (IceVolAllAR(1,:))';  % Select Arctic Ocean data and transpose to column matrix
IceVolAO_AR = IceVolAO_ARm3 / 1e+12; % Convert from m^3 to 10^3 km^3
IceVolAO_FW_AR = IceVolAO_AR * conv; % Scale ice volume to liquid FW equivalent
clear IceVolAllAR IceVolAO_ARm3

IceVolAllB1 = ncread('area_int_B1.nc','ivol');  
IceVolAO_B1m3 = (IceVolAllB1(1,:))';  % Select Arctic Ocean data and transpose to column matrix
IceVolAO_B1 = IceVolAO_B1m3 / 1e+12; % Convert from m^3 to 10^3 km^3
IceVolAO_FW_B1 = IceVolAO_B1 * conv; % Scale ice volume to liquid FW equivalent
clear IceVolAllB1 IceVolAO_B1m3

IceVolAllB7 = ncread('area_int_B7.nc','ivol');  
IceVolAO_B7m3 = (IceVolAllB7(1,:))';  % Select Arctic Ocean data and transpose to column matrix
IceVolAO_B7 = IceVolAO_B7m3 / 1e+12; % Convert from m^3 to 10^3 km^3
IceVolAO_FW_B7 = IceVolAO_B7 * conv; % Scale ice volume to liquid FW equivalent
clear IceVolAllB7 IceVolAO_B7m3

IceVolAllC1 = ncread('area_int_C1.nc','ivol');  
IceVolAO_C1m3 = (IceVolAllC1(1,:))';  % Select Arctic Ocean data and transpose to column matrix
IceVolAO_C1 = IceVolAO_C1m3 / 1e+12; % Convert from m^3 to 10^3 km^3
IceVolAO_FW_C1 = IceVolAO_C1 * conv; % Scale ice volume to liquid FW equivalent
clear IceVolAllC1 IceVolAO_C1m3

IceVolAllC8 = ncread('area_int_C8.nc','ivol');  
IceVolAO_C8m3 = (IceVolAllC8(1,:))';  % Select Arctic Ocean data and transpose to column matrix
IceVolAO_C8 = IceVolAO_C8m3 / 1e+12; % Convert from m^3 to 10^3 km^3
IceVolAO_FW_C8 = IceVolAO_C8 * conv; % Scale ice volume to liquid FW equivalent
clear IceVolAllC8 IceVolAO_C8m3

%% Apply 12 month moving average filter to AR freshwater content

MthsPerYr = 12;
coeffMA = ones(1,MthsPerYr)/MthsPerYr; % Set up coefficients for ...
% the filter with equal weighting over the 12 month period
A_R_IceVol_filt = filter(coeffMA,1,IceVolAO_FW_AR);  % Apply filter  
A_R_IceVol_12MthAv = (ones(1,419).* NaN)';  % Set up skeleton variable for filtered data
A_R_IceVol_12MthAv(7:414) = A_R_IceVol_filt(12:419); % Copy in output from filter, shifted ...
% up 6 months to account for filter delay 

%% Take differences between expt results and reference case
% Using liquid FW equivalents

B_1_IceVol_diff = IceVolAO_FW_B1 - IceVolAO_FW_AR;
B_7_IceVol_diff = IceVolAO_FW_B7 - IceVolAO_FW_AR;
C_1_IceVol_diff = IceVolAO_FW_C1 - IceVolAO_FW_AR;
C_8_IceVol_diff = IceVolAO_FW_C8 - IceVolAO_FW_AR;


%% Plot figures

% Define plotting colours from Colorbrewer
blue = [0.216 0.494 0.722];
red = [0.894 0.102 0.110];
green = [0.302 0.686 0.290];
purple = [0.596 0.306 0.639];
orange = [1.000 0.498 0.000];
yellow = [1.000 1.000 0.200];

% Sea Ice AR for paper
figure('units','normalized','position',[0.06,0.06,0.75,0.65]);
ax2 = axes('units','normalized','position',[0.09 0.06 0.90 0.90]);
ax2.YLim = [0 20];
ax2.XLim = [0 419];
hold on
p1 = plot(mth,IceVolAO_FW_AR,'k-','LineWidth',1.5);
p2 = plot(mth,A_R_IceVol_12MthAv,'k-','LineWidth',4);
ax2.FontWeight = 'normal';
ax2.FontSize = 20;
ax2.XTick = [0 60 120 180 240 300 360];
%ax2.XTickLabel = {'0','5','10','15','20','25','30'};
ax2.XTickLabel = [];
ax2.YLabel.String = 'FWC (sea ice) in control simulation   (x 10^3 km^3)';
ax2.YLabel.Position = (get(ax2.YLabel,'Position')) + [-6 0 0]; % Shift the label out to make the numbers easier to read
grid on
box on

% 30% JRA anomalies for paper
figure('units','normalized','position',[0.06,0.06,0.75,0.65]);
ax2 = axes('units','normalized','position',[0.09 0.06 0.90 0.90]);
ax2.YLim = [-1.7 0.2];
ax2.XLim = [0 419];
hold on
p2 = plot(mth,B_1_IceVol_diff.*(-1),'k-',mth,C_1_IceVol_diff,'m-',mth,B_7_IceVol_diff.*(-1),'k-',mth,C_8_IceVol_diff,'m-','LineWidth',4);
p2(1).Color = blue;
p2(2).Color = red;
p2(3).Color = green;
p2(4).Color = purple;
ax2.FontWeight = 'normal';
ax2.FontSize = 20;
ax2.XTick = [0 60 120 180 240 300 360];
ax2.XTickLabel = {'0','5','10','15','20','25','30'};
ax2.YTick = [-1.5 -1.0 -0.5 0 ];
ax2.YLabel.String = 'Anomaly in FWC (sea ice)   (x 10^3 km^3)';
ax2.YLabel.Position = (get(ax2.YLabel,'Position')) + [-5 0 0]; % Shift the label out to make the numbers easier to read
grid on
leg = legend('  -30% runoff','  +30% runoff','  -30% precip','  +30% precip','Location','southeast');
Pl1 = get(leg,'Position');
leg.Position(1) = leg.Position(1) - 0.025;
leg.Position(3) = leg.Position(3) + 0.025;
leg.Position(4) = leg.Position(4) + 0.040;
box on


