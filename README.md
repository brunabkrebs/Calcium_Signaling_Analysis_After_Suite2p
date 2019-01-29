# Calcium_Signaling_Astrocytes
Developed on 01/15/2019.

Pipeline written in MATLAB to analyze Calcium Signaling data from Astrocytes. The image data is acquired from live mice using a two-photon microscope. The acquisition software is NIS Elements. I first proccess the imaging data using an open-source software Suite2p, and use the output from it as the input for this pipeline.  

Output:
- Find and plot spikes and its characteristics (amplitudes, locations, widths, prominences)
- Frequency of spikes
- Mean Interval between spikes
- Correlation matrix
- Correlation coefficient
- Export results to excel files

Observations:
- "width" and "prominence" values cannot be taken into consideration if the input was the deconvolved "spks.py", only if the input was the DF/F0.
- Change duration in seconds according to experiment.
