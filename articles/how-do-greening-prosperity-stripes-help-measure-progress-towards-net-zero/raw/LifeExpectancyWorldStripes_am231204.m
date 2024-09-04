%% MATLAB program to create stripes colormap of Life Expectancy for the World in Years since 1960 annually
% File name: LifeExpectancyWorldStripes_am231204.m
% AM230630 in R2017a 1st trial -> and success! -> based on:
% http://mres.uni-potsdam.de/index.php/2022/11/16/ed-hawkins-warming-stripes-with-matlab/
% AM230701 in R2023a further minor edits and development
% AM230709 in R2023a further minor edits and development
% AM231204 in R2023a final checks and minor edits

%% Acknowledgement

% "NOVEMBER 16, 2022 BY MARTIN H. TRAUTH
% Ed Hawkins? Warming Stripes with MATLAB"

% "Ed Hawkins, climatologist at U Reading, published a visualization graphics for climate data to display global warming.
% Here's a script to display the warming stripes with MATLAB. To display the popular warming stripes, Python scripts and
% R scripts exist, but I was not able to find a MATLAB script, inspired by a discussion on Twitter. In following script
% I used the HadCRUT.4.6.0.0 dataset by the Met Office Hadley Centre. The hex colormap was taken from the Python script
% and converted to RGB colors using a script by Jos van der Geest published on the MathWorks File Exchange."

%% Housekeeping

% Clear the Workspace and the Command Window and close all Figure Windows (respectively,the 3 commands in the next line).
clear; clc; close all

diary LifeExpectancyWorldStripes_am231204.txt % create a diary log (*.txt) file saving the output from the command window
tic                                           % start stopwatch timer
t = datetime('now')                           % return a datetime scalar representing the current date and time


%% Loading the Dataset and Defining the Time Interval

data_LEW = load('LifeExpectancyWorld.txt'); %AM230630 Select the data vector (from the *.txt datafile) to be displayed!
ticks = 1960:2022; %AM230630 Select the date range, i.e., data vector (from the *.txt datafile), to be displayed!

%% Creating the Colormap (16 colours, as per their RGB 3-vector code for each colour below)

% These are the colors from the Python script cited above, converted with Jos van der Geest's MATLAB code to RGB colors,
% and then stored in the variable wscolors (next).

wscolors = [
   0.0314 0.1882 0.4196
   0.0314 0.3176 0.6118
   0.1294 0.4431 0.7098
   0.2588 0.5725 0.7765
   0.4196 0.6824 0.8392
   0.6196 0.7922 0.8824
   0.7765 0.8588 0.9373
   0.8706 0.9216 0.9686
   0.9961 0.8784 0.8235
   0.9882 0.7333 0.6314
   0.9882 0.5725 0.4471
   0.9843 0.4157 0.2902
   0.9373 0.2314 0.1725
   0.7961 0.0941 0.1137
   0.6471 0.0588 0.0824
   0.4039 0.0000 0.0510
];

%% Creating the Figure

% To create the graphics, we use imagesc (below). We first create a landscape Figure Window with white background. We
% then create axes with the time axes as defined above (e.g., running from 1960 to 2021), rotate the tick labels of the
% x-axis by 90 degrees, and display annual tick labels. We also hide the tick labels of the y-axis. Then use imagesc
% to display the stripes and the colormap wscolors.

%absolute
figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticks) max(ticks)],...
   'XTickMode','manual',...
   'XTick',ticks,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticks',...
   'YData',[2000 2040],...
   'XData',[1960 2022],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_LEW(:,2)') %AM230630 Select the data vector (from the *.txt datafile) to be displayed! Can be 2 or 3!
colormap(wscolors)
colorbar
title('Average World Life Expecatncy at Birth, Years');

saveas(gcf,'LEWAbsSince1960Annual.fig') %AM230701
saveas(gcf,'LEWAbsSince1960Annual .png')
saveas(gcf,'LEWAbsSince1960Annual.epsc')

%relative/deviation
figure('Position',[100 100 800 300],...
   'Color',[1 1 1])
axes(...
   'XLim',[min(ticks) max(ticks)],...
   'XTickMode','manual',...
   'XTick',ticks,...
   'XTickLabelRotation',90,...
   'YTick',[])
imagesc('XData',ticks',...
   'YData',[2000 2040],...
   'XData',[1960 2022],... %AM230630 Select the x-axis data vector (corresponding to the *.txt datafile) to be displayed!
   'CData',data_LEW(:,3)') %AM230630 Select the data vector (from the *.txt datafile) to be displayed! Can be 2 or 3!
colormap(wscolors)
colorbar
title('Deviation from Average World Life Expecatncy at Birth, Years');

saveas(gcf,'LEWDevSince19960Annual.fig') %AM230701
saveas(gcf,'LEWDevSince19960Annual.png')
saveas(gcf,'LEWDevSince19960Annual.epsc')

%% "References

% Hawkins, Ed (2018-12-04). 2018 visualisation update / Warming stripes for 1850?2018 using the WMO annual global
% temperature dataset. Climate Lab Book."

%% Plot - absolute level

figure
plot(data_LEW(:,1),data_LEW(:,2),'LineWidth',2)
axis ([1960 2022 50 75])
fontsize(12,"points")
grid on
xlabel('years (sample 1960-2022)')
ylabel('life expectancy, in years')
title('Average World Life Expectancy, Years');

saveas(gcf,'Plot_LEWAbsSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_LEWAbsSince1960Annual.png')
saveas(gcf,'Plot_LEWAbsSince1960Annual.epsc')

%% Histogram - absolute level

figure
histogram(data_LEW(:,2),16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('')
ylabel('deviation from average world life expectancy for 1960-1990, years')
title('Deviation from Average World Life Expectancy for 1960-1990 Normalized to 0');

%% Computation and Export of a Descriptive Stats Table - absolute level

data_LEWAbs_min = min(data_LEW(:,2))
data_LEWAbs_max = max(data_LEW(:,2))
data_LEWAbs_range = data_LEWAbs_max - data_LEWAbs_min
stripe_LEWAbs_range = data_LEWAbs_range/16
data_LEWAbs_mean = mean(data_LEW(:,2))
data_LEWAbs_median = median(data_LEW(:,2))
%data_LEWAbs_mode = mode(data_LEW(:,2),'all') %AM230708 Sth's wrong about the mode command?!
data_LEWAbs_std = std(data_LEW(:,2))

saveas(gcf,'Hist_LEWAbsSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_LEWAbsSince1960Annual.png')
saveas(gcf,'Hist_LEWAbsSince1960Annual.epsc')

tabLEWAbs = table(categorical({'data_LEWAbs_min';'data_LEWAbs_max';'data_LEWAbs_range';'stripe_LEWAbs_range';'data_LEWAbs_mean';'data_LEWAbs_median';'data_LEWAbs_std'}),{data_LEWAbs_min; data_LEWAbs_max; data_LEWAbs_range; stripe_LEWAbs_range; data_LEWAbs_mean; data_LEWAbs_median; data_LEWAbs_std})
writetable(tabLEWAbs,'tabLEWAbs.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")

%% Plot - relative/deviastion level

figure
plot(data_LEW(:,1),data_LEW(:,3),'LineWidth',2)
axis ([1960 2022 -15 +10])
fontsize(12,"points")
grid on
xlabel('years (sample 1960-2022)')
ylabel('life expectancy deviation, in years from the mean for 1960-1990 at 0')
title('Deviation from Average World Life Expectancy for 1960-1990 Normalized to 0');

saveas(gcf,'Plot_LEWDevSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Plot_LEWDevSince1960Annual.png')
saveas(gcf,'Plot_LEWDevSince1960Annual.epsc')

%% Histogram - relative/deviastion level

figure
histogram(data_LEW(:,3),16)
%axis ([1850 2023 -0.6 +1.0])
fontsize(12,"points")
xlabel('life expectancy deviation, in years from the mean for 1960-1990 at 0')
ylabel('frequency')
title('Deviation from Average World Life Expectancy for 1960-1990 Normalized to 0');

saveas(gcf,'Hist_LEWDevSince1960Annual.fig') %AM230701 checking online
saveas(gcf,'Hist_LEWDevSince1960Annual.png')
saveas(gcf,'Hist_LEWDevSince1960Annual.epsc')

%% Computation and Export of a Descriptive Stats Table - relative/deviastion level

data_LEWDev_min = min(data_LEW(:,3))
data_LEWDev_max = max(data_LEW(:,3))
data_LEWDev_range = data_LEWDev_max - data_LEWDev_min
stripe_LEWDev_range = data_LEWDev_range/16
data_LEWDev_mean = mean(data_LEW(:,3))
data_LEWDev_median = median(data_LEW(:,3))
%data_LEWDev_mode = mode(data_LEW(:,3),'all') %AM230708 Sth's wrong about the mode command?!
data_LEWDev_std = std(data_LEW(:,3))

tabLEWDev = table(categorical({'data_LEWDev_min';'data_LEWDev_max';'data_LEWDev_range';'stripe_LEWDev_range';'data_LEWDev_mean';'data_LEWDev_median';'data_LEWDev_std'}),{data_LEWDev_min; data_LEWDev_max; data_LEWDev_range; stripe_LEWDev_range; data_LEWDev_mean; data_LEWDev_median; data_LEWDev_std})
writetable(tabLEWDev,'tabLEWDev.xlsx')
%path = export(table,"//Users//alexandermihailov//Desktop//tempwork//ProsperityStripes",Format="tex")
