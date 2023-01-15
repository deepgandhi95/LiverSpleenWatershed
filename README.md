# LiverSpleenWatershed

Description:
In certain cases where abdominal multi-organ segmentation needs to be performed, liver and spleen segmentation causes binary masks for the two organs to be conjoined due to the promixity of these organs. This MATLAB code separates conjoined Liver and Spleen binary masks based on watershed segmentation in MATLAB. 

Requirements:
MATLAB 2019a or later
Image processing toolbox

Usage:
Run the script in MATLAB

Input:
Conjoined liver-spleen binary mask .nii file

Output:
Separated Liver and Spleen binary mask .nii file

Author:
Deep B. Gandhi
