%% 
% *Clear Workspace*

clear all
clc
%% 
% *Import Data*

%Import Deconvolved file
File = uigetfile('*.xlsx');
PreData = xlsread(File);
%Import file with info if it is a cell or not
File2 = uigetfile('*.xlsx');
IsCell = xlsread(File2);
cells = IsCell==1;
%Keep only info about cells
PreData = PreData(cells, :);
Data = PreData';
[NumberofRows, NumberofColumns] = size(Data);
fps = round(str2double(inputdlg('What is the FPS?')));
duration = str2double(inputdlg('What is the duration in minutes?'))
%% 
% *Find Spikes*

for i=1:NumberofColumns
    figure(i)
    [amplitudes{i},locations{i}, ~, ~] = findpeaks(Data(:,i));
    findpeaks(Data(:,i), 'Annotate', 'extents')
end   
%% 
% *Amplitudes*

%Calculates the average amplitudes per cell

for i = 1:NumberofColumns;
    AvgAmplitudes{i} = mean(amplitudes{1,i});
end

AvgAmplitudes = cell2mat(AvgAmplitudes);
AvgAmplitudes = AvgAmplitudes';
%% 
% *Frequency of spikes (Hz)*

for i = 1:NumberofColumns;
    Frequency{i} = length(locations{1,i})/(60*duration);
end

Frequency = cell2mat(Frequency);
Frequency = Frequency';
%% 
% *Interspike Interval*

for i = 1:NumberofColumns;
    Interval{i} = (diff(cell2mat(locations(1,i))))./fps;
end
%%
%Calculates the mean of interspike intervals 
for i = 1:NumberofColumns;
    MeanInterval{i} = mean(diff(cell2mat(locations(1,i))))./fps;
end

%Change fps accordingly
MeanInterval=cell2mat(MeanInterval);
MeanInterval=MeanInterval';

%Shows distribution of peak intervals
hist(MeanInterval)
%% 
% *Plot correlation matrix and find average of correlation coefficient*

% [rho, pval] = corr(Data, 'rows', 'pairwise');
% imagesc(rho)
% colormap('jet')
% colorbar
% 
% corrcoef=nonzeros(tril(rho,-1));
% meanofcorrcoef=mean(corrcoef)
%% 
% *Sort matrix by similarity for a better correlation matrix*

% %for this to work, each cell must be a row
% %Max number of clusters can be adaptable
% Data2 = Data';
% cluster = clusterdata(Data2, 'maxclust',3);
% Data2 = [cluster Data2];
% Data2 = sortrows(Data2);
% 
% %De-transform rows to columns again
% Data2 = Data2(:, 2:end);
% Data2 = Data2';
% 
% %run correlation again
% [rho2, pval2] = corr(Data2, 'rows', 'pairwise');
% imagesc(rho2)
% colormap('jet')
% colorbar
% 
% corrcoef2=nonzeros(tril(rho2,-1));
% meanofcorrcoef2=mean(corrcoef2)
%% 
% *Transform arrays into matrixes*

%Fill arrays with NaN for calculations
for i=1:NumberofColumns;
    amplitudes{1,i}(end+1:NumberofRows)=nan;
    locations{1,i}(end+1:NumberofRows)=nan;
    %widths{1,i}(end+1:NumberofRows)=nan;
    %prominences{1,1}(end+1:NumberofRows)=nan;
    Interval{1,i}(end+1:NumberofRows)=nan;
end

%Transform arrays into matrixes
amplitudes=cell2mat(amplitudes);
locations=cell2mat(locations);
%widths=cell2mat(widths);
%prominences=cell2mat(prominences);
Interval=cell2mat(Interval);
%% 
% *Synchronization plots*

matrix=zeros(NumberofRows,NumberofColumns);
for i=1:NumberofColumns;
    matrix(:,i)=i;
end

plot(locations,matrix,'*')

axis([0 NumberofRows 0 (NumberofColumns+1)]);
title('Synchronization');
xlabel('Frame');
ylabel('Cell Number')

%%
% %Plot some plots only:
% plot(locations(:,1),matrix(:,1),'*')
% hold on
% plot(locations(:,2),matrix(:,2),'*')
%% 
% *Write results to Excel file*

%Write and save results in individual tables
xlswrite('Amplitudes.xlsx', amplitudes);
xlswrite('Peak_locations.xlsx', locations);
%xlswrite('widths.xlsx', widths);
%xlswrite('prominences.xlsx', prominences);
xlswrite('Average_amplitudes.xlsx', AvgAmplitudes);
xlswrite('Frequency.xlsx', Frequency);
xlswrite('Interspike_interval.xlsx', Interval);
xlswrite('Average_Interspike_interval.xlsx', Mean_Interval);