# Dynanets
The purpose of this code is to track communities in dynamic networks. 

## Dependices
Download the following software packages, required to track dynamic communities and analyze the networks.

- Download the [The Brain Connectivity Toolbox](https://sites.google.com/site/bctnet/)
- Download this "generalized Louvain" MATLAB code for community detection [GenLouvain2.1](http://netwiki.amath.unc.edu/GenLouvain/GenLouvain)
- Download the dynamic plex percolation method [DPPM](https://github.com/nathanntg/dynamic-plex-propagation)

## Initial MATLAB setup
Rename the file `dynanets_defaults_local_example.m` --> `dynanets_defaults_local.m`

- Line 7, replace `'My-MAC'` with the name of the computer that's running the code. To find this name, type `system('hostname')` at the MATLAB command line.
- Line 8, replace  `'/Users/me/analysis/toolboxes/dpp/'` with a string to the directory where DPPM was installed.
- Line 9, replace `'/Users/me/analysis/toolboxes/BCT'` with a string to the directory where the Brain Connectivity Toolbox was installed.
- Line 10, replace `'/Users/me/analysis/toolboxes/GenLouvain-2.1'` with a string to the directory where the generalized Louvain code was installed.
- Line 11, replace `'/Volumes/Data/Output_Data/'` with a string to an output write directory for data.
- Line 12, replace `'/Volumes/Data/Output_Data/'` with a string to an output write directory for figures.

You can enter information for a second system in Lines 13-18, if useful.
