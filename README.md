# NACI Spectral Clustering Analysis Based on HCP Data

This repository contains MATLAB code used for the analysis of the Neural Activation Constraint Index (NACI) and spectral clustering in the manuscript:

**"[Your manuscript title]"**

---

## Overview

This repository provides code for:

1. Calculating NACI values for task-evoked activation patterns
2. Performing spectral clustering based on seven-task NACI features
3. Evaluating robustness across preprocessing strategies and parcellation schemes
4. Assessing cluster consistency using consistency rates and Cohen’s kappa

The study is based on data from the Human Connectome Project (HCP) S1200 release.

---

## Data source

The original data were obtained from the Human Connectome Project:

https://www.humanconnectome.org/

Due to HCP data use restrictions, the full dataset is not redistributed in this repository.

---

## Repository structure

README.md
run_all.m
01_calculate_NACI_single_task.m
02_spectral_clustering_NACI.m
03_robustness_NACI_correlations.m
04_cluster_consistency_kappa.m

data/
outputs/

---

## Requirements

* MATLAB (R2021a or later recommended)
* Statistics and Machine Learning Toolbox

Main MATLAB functions used include:

readtable
pdist2
spectralcluster
silhouette
lillietest
ttest2
ranksum
corr
confusionmat
writetable

---

## Script descriptions

### step1_calculate_NACI_single_task.m

This script calculates subject-level NACI values for a single task condition.

For each subject, task-evoked activation in each cortical region is predicted from activations in other regions using subject-specific resting-state functional connectivity. NACI is calculated from the association between observed and predicted activation patterns.

---

### step2_spectral_clustering_NACI.m

This script performs spectral clustering based on a 1005 × 7 NACI feature matrix.

The seven columns correspond to NACI values from the following task paradigms:

* Language
* Social
* Working memory
* Emotion
* Motor
* Gambling
* Relational

A Gaussian-kernel similarity matrix is constructed across subjects. Spectral clustering is performed for candidate cluster numbers from K = 2 to K = 6. The optimal cluster number is determined using the mean silhouette coefficient.

The script also compares NACI values between clustering-defined groups and applies false discovery rate correction.

---

### step3_robustness_NACI_correlations.m

This script evaluates the robustness of NACI values across alternative analytical strategies, including:

* Functional connectivity with global signal regression
* Positive-only connectivity weights
* Alternative parcellation using the Glasser-360 atlas

Pearson and Spearman correlations are calculated between the main analysis and each robustness analysis.

---

### step4_cluster_consistency_kappa.m

This script evaluates cluster-label agreement across robustness analyses.

It calculates:

* Consistency rates
* Cohen’s kappa
* Confusion matrices

---

## Usage

Place the required input Excel file in the `data/` folder.

The main input file should be named:

GSR-CDM.xlsx

Then run in MATLAB:

run_all

Alternatively, each script can be run separately.

---

## Outputs

The scripts generate output files in the `outputs/` folder, including:

NACI_matrix.mat
cluster_result.xlsx
silhouette_results.xlsx
group_comparison_stats.xlsx
silhouette_curve.png
silhouette_curve.tiff
Task_Correlation_Results_withP.xlsx
Cluster_Consistency_Results.xlsx
Confusion_400_vs_GSR.xlsx
Confusion_400_vs_POS.xlsx
Confusion_400_vs_360.xlsx

---

## Reproducibility

The scripts are provided to reproduce the NACI calculation, spectral clustering, robustness analyses, and cluster consistency analyses described in the manuscript.

Because the original HCP data are governed by HCP data use terms, users should obtain the data directly from the HCP database.

---

## Code availability

This repository is publicly accessible and does not require login or password access.

---

## Contact

[ Chao Tao]
[2446010221@stu.ahmu.edu.cn]

---

## License

This code is provided for academic research use. Please cite the associated manuscript if you use this code.
