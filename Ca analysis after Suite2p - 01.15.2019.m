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
%% 
% *Find Spikes*

for i=1:NumberofColumns
    figure(i)
    [amplitudes{i},locations{i}, widths{i}, prominences{1}] = findpeaks(Data(:,i));
    findpeaks(Data(:,i), 'Annotate', 'extents')
end   
%% 
% *Frequency of spikes*

%Change duration accordingly
Duration = duration(00,04,00);
%or for seconds, min*60 (for frequency in Hz)


%Change duration accordingly
for i = 1:NumberofColumns;
    Frequency{i} = length(locations{1,i})/240;
end

Frequency = cell2mat(Frequency);
Frequency = Frequency';
%% 
% *Mean interval between spikes*

%Shows the mean of intervals between peaks 
for i = 1:NumberofColumns;
    Interval{i} = mean(diff(cell2mat(locations(1,i))));
end

Interval=cell2mat(Interval);
Interval=Interval';
Interval_in_seconds=Interval./15;


%Shows distribution of peak intervals
hist(Interval)
%% 
% *Plot correlation matrix and find average of correlation coefficient*

[rho, pval] = corr(Data, 'rows', 'pairwise');
imagesc(rho)
colormap('jet')
colorbar

corrcoef=nonzeros(tril(rho,-1));
meanofcorrcoef=mean(corrcoef)
%% 
% *Sort matrix by similarity for a better correlation matrix*

%for this to work, each cell must be a row
%Max number of clusters can be adaptable
Data2 = Data';
cluster = clusterdata(Data2, 'maxclust', 6);
Data2 = [cluster Data2];
Data2 = sortrows(Data2);

%De-transform rows to columns again
Data2 = Data2(:, 2:end);
Data2 = Data2';

%run correlation again
[rho2, pval2] = corr(Data2, 'rows', 'pairwise');
imagesc(rho2)
colormap('jet')
colorbar

corrcoef2=nonzeros(tril(rho2,-1));
meanofcorrcoef2=mean(corrcoef2)
%% 
% *Write results to Excel file*

%Fill arrays with NaN for calculations
for i=1:NumberofColumns;
    amplitudes{1,i}(end+1:NumberofRows)=nan;
    locations{1,i}(end+1:NumberofRows)=nan;
    widths{1,i}(end+1:NumberofRows)=nan;
    prominences{1,1}(end+1:NumberofRows)=nan;
end

%%
%Transform arrays into matrixes
amplitudes=cell2mat(amplitudes);
locations=cell2mat(locations);
widths=cell2mat(widths);
prominences=cell2mat(prominences);
%%
%Write and save results in individual tables
xlswrite('amplitudes.xlsx', amplitudes);
xlswrite('peak_locations.xlsx', locations);
xlswrite('widths.xlsx', widths);
xlswrite('prominences.xlsx', prominences);
xlswrite('interval_between_peaks.xlsx', Interval);
xlswrite('peak_frequency.xlsx', Frequency);
xlswrite('Interval_in_seconds.xlsx', Interval_in_seconds);