%% Produces plots for Fig 4a and 4b: liquid FWC for the reference simulation and anomalies in runoff experiments
% 18 August 2016
% Amended 22 May 2018 to normalise to 30% rather than 100% to match precip
% results, and to resize figures for paper draft
% Amended 5 Sep 2018 to use Colorbrewer colours and reformat paper plots

clear all; clc

%% Load data

load Data/FWLvol_AO_Sref35_Nummelin.mat;
load Data/FWLvol_AO_Sref35_PembertonNilsson.mat;

% Define month number to plot against
mth = linspace(1,419,419)';

mth0 = linspace(0,420,420)'; % Set up arrays to draw zero line on plots
zeroy = zeros(420,1);

%% Take differences between expt results and reference case

B_1_diff = B_1 - A_R;
R_10_diff = R_10 - A_R;
C_1_diff = C_1 - A_R;
R_60_diff = R_60 - A_R;
R_100_diff = R_100 - A_R;

%% Apply 12 month moving average filter to AR freshwater height

MthsPerYr = 12;
coeffMA = ones(1,MthsPerYr)/MthsPerYr; % Set up coefficients for ...
% the filter with equal weighting over the 12 month period
A_R_filt = filter(coeffMA,1,A_R);  % Apply filter  
A_R_12MthAv = (ones(1,419).* NaN)';  % Set up skeleton variable for filtered data
A_R_12MthAv(7:414) = A_R_filt(12:419); % Copy in output from filter, shifted ...
% up 6 months to account for filter delay 

%% Scale by the proportion of runoff increase to check linearity

B_1_scale = B_1_diff ./ -1;  % Coefficients to normalise to 30% expts
R_10_scale = R_10_diff ./ (1/3);
C_1_scale = C_1_diff ./ 1;
R_60_scale = R_60_diff ./ (6/3);
R_100_scale = R_100_diff ./ (10/3);

%% Calculate notional relaxation curves from FW perturbation timescales

% Input mean FW responses and timescales from expts 
% a = 0.120; % Mean (C_1,R_60,R_100) eventual H perturbation per percent FW perturbation
% a = 0.114; % Mean (R_10,C_1,R_60,R_100) eventual H perturbation per percent FW perturbation
a = 0.134; % Mean (B_1,R_10,C_1,R_60,R_100) eventual H perturbation per percent FW perturbation
% T = 101.6; % Mean (C_1,R_60,R_100) timescale in months
% T = 93.94; % Mean (R_10,C_1,R_60,R_100) timescale in months
T = 106.38; % Mean (B_1,R_10,C_1,R_60,R_100) timescale in months

C_1_H_E = a * 30 * (1 - exp(-mth/T));

%% Set colours for figures

% Set colours
red = [0.894 0.102 0.110];
blue = [0.216 0.494 0.722];
green = [0.302 0.686 0.290];
purple = [0.596 0.306 0.639];
orange  = [1.000 0.498 0.000];

%% Plot figures

% AR figure for paper draft
f1 = figure('units','normalized','position',[0.06,0.06,0.75,0.65]);
ax2 = axes('units','normalized','position',[0.09 0.06 0.90 0.90]);
ax2.XLim = [0 419];
hold on
p1 = plot(mth,A_R,'k-', 'Linewidth',1.5);
p2 = plot(mth,A_R_12MthAv,'k-', 'Linewidth',4);
ax2.FontWeight = 'normal';
ax2.FontSize = 20;
ax2.XTick = [0 60 120 180 240 300 360];
ax2.XTickLabel = [ ];
ax2.YLabel.String = 'V_{F} in control simulation  (x 10^3 km^3)';
ax2.YLabel.Position = (get(ax2.YLabel,'Position')) + [-5 0 0]; % Shift the label out to make the numbers easier to read
grid on
box on

% Scaled differences figure
% Amended 21 March 18 for paper draft
f2 = figure('units','normalized','position',[0.06,0.06,0.75,0.65]);
ax2 = axes('units','normalized','position',[0.09 0.06 0.90 0.90]);
ax2.YLim = [0 5.5];
ax2.XLim = [0 419];
hold on
p2 = plot(mth,B_1_scale,'k-',mth,R_10_scale,'m-',mth,C_1_scale,'g-',mth,R_60_scale,'b-',mth,R_100_scale,'g-',mth,C_1_H_E,'r--', 'Linewidth',4);
p2(1).Color = [0.216 0.494 0.722];
p2(2).Color = [0.596 0.306 0.639];
p2(3).Color = [0.894 0.102 0.110];
p2(4).Color = [0.302 0.686 0.290];
p2(5).Color = [1.000 0.498 0.000];
p2(6).Color = [0.600 0.600 0.600];
ax2.FontWeight = 'normal';
ax2.FontSize = 20;
ax2.XTick = [0 60 120 180 240 300 360];
ax2.XTickLabel = [ ];
ax2.YLabel.String = 'Adjusted \DeltaV_{F}  (x 10^3 km^3)';
ax2.YLabel.Position = (get(ax2.YLabel,'Position')) + [-5 0 0]; % Shift the label out to make the numbers easier to read
grid on
leg = legend('  -30%','  +10%','  +30%','  +60%','  +100%','  Ideal relaxation','Location','northwest');
Pl = get(leg,'Position');
% leg.Position(1) = leg.Position(1) - 0.045;
leg.Position(2) = leg.Position(2) - 0.028;
leg.Position(3) = leg.Position(3) + 0.025;
leg.Position(4) = leg.Position(4) + 0.028;
box on

