%% Produces Fig 6: scatter plot relating anomalies in liquid FW content to anomalies in fluxes 
% 22 May 2018 
% Amended 5 Sep 2018 to reformat paper plot
% Augmented 29 May 2019 to add fitted regression lines to plot

clear all; clc

bas = 1;  % Select data for Arctic Ocean
dep = 19;  % Select integration to 277m

% Define month number to plot against
mth = linspace(1,419,419)';
yr = mth./12;

%% Load FW volume data

FW_AR = ncread('fwvolume_Sref35_AR.nc','freshwater');  % Units m^3
FW_B1 = ncread('fwvolume_Sref35_B1.nc','freshwater');
FW_C1 = ncread('fwvolume_Sref35_C1.nc','freshwater');

A_R = (squeeze(FW_AR(bas,dep,:)))*1e-12;  % Take subset for basin and depth and convert to 10^3 km^3
B_1 = (squeeze(FW_B1(bas,dep,:)))*1e-12;
C_1 = (squeeze(FW_C1(bas,dep,:)))*1e-12;

B_1_diff = B_1 - A_R; % Take differences between experiment and control volumes
C_1_diff = C_1 - A_R;

%% Load flux data and calculate net exports

LiqFWOutAll_AR = ncread('fluxes_ed3_AR.nc','fw_out2'); % Units m^3 s^-1  
LiqFWInAll_AR = ncread('fluxes_ed3_AR.nc','fw_in2'); % Units m^3 s^-1 
LiqFWExport_AR_all = (- LiqFWOutAll_AR - LiqFWInAll_AR); % Calculate net exports, all grid cells
LiqFWExport_AR_upperlayers = LiqFWExport_AR_all(:,1:19,:);  % Select all depths to z = -276.68m
LiqFWExport_AR_upper = sum(LiqFWExport_AR_upperlayers,2);  % Sum upper layers
LiqFWExport_AR_persec = sum(LiqFWExport_AR_upper);  % Sum over all straits
LiqFWExport_AR_persec = squeeze(LiqFWExport_AR_persec);
LiqFWExport_AR = LiqFWExport_AR_persec * 0.03156;  % Convert m^3 s^-1 to km^3 yr^-1

clear  LiqFWOutAll_AR LiqFWInAll_AR LiqFWExport_AR_all LiqFWExport_AR_upperlayers  LiqFWExport_AR_upper 

LiqFWOutAll_B1 = ncread('fluxes_ed3_B1.nc','fw_out2'); % Units m^3 s^-1  
LiqFWInAll_B1 = ncread('fluxes_ed3_B1.nc','fw_in2'); % Units m^3 s^-1 
LiqFWExport_B1_all = (- LiqFWOutAll_B1 - LiqFWInAll_B1); % Calculate net exports, all grid cells
LiqFWExport_B1_upperlayers = LiqFWExport_B1_all(:,1:19,:);  % Select all depths to z = -276.68m
LiqFWExport_B1_upper = sum(LiqFWExport_B1_upperlayers,2);  % Sum upper layers
LiqFWExport_B1_persec = sum(LiqFWExport_B1_upper);  % Sum over all straits
LiqFWExport_B1_persec = squeeze(LiqFWExport_B1_persec);
LiqFWExport_B1 = LiqFWExport_B1_persec * 0.03156;  % Convert m^3 s^-1 to km^3 yr^-1

clear  LiqFWOutAll_B1 LiqFWInAll_B1 LiqFWExport_B1_all LiqFWExport_B1_upperlayers  LiqFWExport_B1_upper  

LiqFWOutAll_C1 = ncread('fluxes_ed3_C1.nc','fw_out2'); % Units m^3 s^-1  
LiqFWInAll_C1 = ncread('fluxes_ed3_C1.nc','fw_in2'); % Units m^3 s^-1 
LiqFWExport_C1_all = (- LiqFWOutAll_C1 - LiqFWInAll_C1); % Calculate net exports, all grid cells
LiqFWExport_C1_upperlayers = LiqFWExport_C1_all(:,1:19,:);  % Select all depths to z = -276.68m
LiqFWExport_C1_upper = sum(LiqFWExport_C1_upperlayers,2);  % Sum upper layers
LiqFWExport_C1_persec = sum(LiqFWExport_C1_upper);  % Sum over all straits
LiqFWExport_C1_persec = squeeze(LiqFWExport_C1_persec);
LiqFWExport_C1 = LiqFWExport_C1_persec * 0.03156;  % Convert m^3 s^-1 to km^3 yr^-1

clear  LiqFWOutAll_C1 LiqFWInAll_C1 LiqFWExport_C1_all LiqFWExport_C1_upperlayers  LiqFWExport_C1_upper


%% Apply 12 month moving average filter to FW export
% Using converted FW equivalents

MthsPerYr = 12;
coeffMA = ones(1,MthsPerYr)/MthsPerYr; % Set up coefficients for ...
% the filter with equal weighting over the 12 month period

LiqFWExport_AR_filt = filter(coeffMA,1,LiqFWExport_AR);  % Apply filter  
LiqFWExport_AR_12MthAv = (ones(1,419).* NaN)';  % Set up skeleton variable for filtered data
LiqFWExport_AR_12MthAv(7:414) = LiqFWExport_AR_filt(12:419); % Copy in output from filter, shifted ...
% up 6 months to account for filter delay 

LiqFWExport_B1_filt = filter(coeffMA,1,LiqFWExport_B1);  % Apply filter  
LiqFWExport_B1_12MthAv = (ones(1,419).* NaN)';  % Set up skeleton variable for filtered data
LiqFWExport_B1_12MthAv(7:414) = LiqFWExport_B1_filt(12:419); % Copy in output from filter, shifted ...
% up 6 months to account for filter delay 

LiqFWExport_C1_filt = filter(coeffMA,1,LiqFWExport_C1);  % Apply filter  
LiqFWExport_C1_12MthAv = (ones(1,419).* NaN)';  % Set up skeleton variable for filtered data
LiqFWExport_C1_12MthAv(7:414) = LiqFWExport_C1_filt(12:419); % Copy in output from filter, shifted ...
% up 6 months to account for filter delay 
 
%% Take differences between experiment 12 month averages and reference case

B1_LiqFWExport_12MthAv_diff = LiqFWExport_B1_12MthAv - LiqFWExport_AR_12MthAv;
C1_LiqFWExport_12MthAv_diff = LiqFWExport_C1_12MthAv - LiqFWExport_AR_12MthAv;

%% Perform regression for runoff results

% Whole simulation
sCrob = robustfit(C_1_diff.*1000,C1_LiqFWExport_12MthAv_diff,[],[],'off');  % const option off to force model through origin 
sBrob = robustfit(B_1_diff.*1000,B1_LiqFWExport_12MthAv_diff,[],[],'off');

%% Set data for fitted slopes

xC = (0:1:5000);
xB = (-5000:1:0);
yregC = xC .* sCrob;
yregB = xB .* sBrob;

%% Plot figure

figure('units','normalized','position',[0.06,0.06,0.75,0.65]);
ax2 = axes('units','normalized','position',[0.10 0.11 0.87 0.87]);
hold on
c = linspace(1,35,419);
sC = scatter(C_1_diff.*1000,C1_LiqFWExport_12MthAv_diff,30,c,'filled');
sB = scatter(B_1_diff.*1000,B1_LiqFWExport_12MthAv_diff,30,c,'filled');
pC = plot(xC,yregC,'-k','Linewidth',1.5); % Need to put the plot commands before the scatter commands if including legend
pB = plot(xB,yregB,'-k','Linewidth',1.5);
ax2.XLim = [-5000 5000];
ax2.YLim = [-600 600];
ax2.FontWeight = 'normal';
ax2.FontSize = 18;
ax2.XLabel.String = '\Delta V_F  (km^3)';
ax2.YLabel.String = 'Liquid FW net export anomaly  (km^3 yr^{-1})';
ax2.YLabel.Position = (get(ax2.YLabel,'Position')) + [-80 0 0]; % Shift the label out to make the numbers easier to read
grid on
c1 = colorbar('Location','Eastoutside','FontSize',16);
c1.TickLabels = {'5','10','15','20','25','30',[]};
box on





