# Irrigated Crop Yields Reveal Distinct Influences of Heat and Moisture

**Authors:** Penelope L. Hunter, Dongyang Wei, Avery W. Driscoll, John T. Abatzoglou, Danica Lombardozzi, Phuong D. Dao, and Nathaniel D. Mueller


---

## Overview

This repository contains all code used to process data, run analyses, and generate figures for the manuscript "Irrigated Crop Yields Reveal Distinct Influences of Heat and Moisture." The analysis examines how water availability mediates the apparent sensitivity of maize and soybean yields to extreme heat, using paired irrigated and rainfed county-level yield observations across the U.S. Great Plains.

---

## File Order and Description

Scripts should be run in the following order. Each script depends on outputs from the previous one.

### 1. `LM_KDD_Analysis.Rmd`
**Data preparation, historical regression, and bootstrap inference**

- Loads and merges daily PRISM climate variables (Tmax, Tmin, PPT, VPD) into a single county-level panel
- Extracts crop-specific growing seasons from USDA NASS Crop Progress median emergence and harvest dates
- Calculates daily Killing Degree Days (KDD) and Growing Degree Days (GDD) using a sinusoidal hourly temperature profile following Schlenker & Roberts (2009) and Snyder (1985)
- Aggregates climate variables to annual county-level summaries
- Merges with USDA NASS irrigated and rainfed yield data
- Applies a minimum 10-year paired data requirement
- Saves `maize_gs` and `soybeans_gs` as the primary modeling datasets
- Runs four OLS panel regressions (maize/soybean × irrigated/rainfed) with county and year fixed effects
- Runs a 1,000-iteration state-year block bootstrap for KDD coefficient uncertainty quantification
- Exports regression coefficient tables to Word (.docx)
- **Produces:** Figure 1 (KDD bootstrap coefficients)

---

### 2. `Anomaly_Analysis.Rmd`
**Hydroclimatic anomaly composite analysis**

- Loads NCA-LDAS soil moisture data (0–10 cm, 10–40 cm, 40–100 cm depth layers) and PRISM climate data
- Merges all variables into a single daily county-level panel
- Computes a smoothed day-of-year climatology (±7-day centered running mean) and daily anomalies for all variables
- Identifies extreme heat days (Tmax ≥ 30°C) and computes KDD for each day
- Runs a 1,000-iteration state-year block bootstrap to estimate KDD-weighted mean anomalies in a ±30-day window around hot days (61-day composite window)
- **Produces:** Figure 3 (climate and soil moisture anomaly composites)

---

### 3. `bootstrap_yield_projections.Rmd`
**Future yield projections under SSP2-4.5**

- Loads bias-corrected CMIP6 projections for five GCMs (GFDL-ESM4, IPSL-CM6A-LR, MPI-ESM1-2-HR, MRI-ESM2-0, UKESM1-0-LL) under SSP2-4.5
- Computes projected KDD and GDD from daily tasmax/tasmin for all study counties through 2100
- Runs 1,000-iteration state-year block bootstrap, refitting the historical regression on each resampled dataset and predicting through all 5 GCMs, yielding 5,000 yield trajectories per crop-by-water-regime model
- Freezes the year fixed effect at 2018 to isolate climate impacts from technological trends
- Applies CO₂ fertilization adjustment following Moore et al. (2017) as applied by Hultgren et al. (2025), with a 360 ppm reference baseline
- Summarizes trajectories and computes 10-year average yield changes (2015–2024 vs 2091–2100)
- **Produces:** Figure 2 (spaghetti plot of projected yield trajectories)

---

### 4. `Supplemental_Graphs.Rmd`
**Supplemental figures**

- Loads `maize_gs`, `soybeans_gs`, and `counties_combined` (with Hidalgo County, NM excluded)
- Computes county-level mean climate variables (GDD, KDD, precipitation, Tmax, VPDmax) pooled across both crops and all years
- Computes crop presence by county (both crops, maize only, soybean only)
- Computes county-level mean historical yields by crop and water regime
- **Produces:** Figure S1 (mean growing-season climate variables and crop distribution) and Figure S2 (mean historical yields by crop and water regime)

---

## Key Notes

- **Hidalgo County, NM (FIPS 35031)** is excluded from all analyses. Although this county has paired yield data, it lacks USDA NASS Crop Progress growing season dates for maize, resulting in all-NA climate variables downstream.
- **Year fixed effect** is frozen at 2018 in all future projections to isolate climate impacts from technological trends.
- **CO₂ fertilization** uses a Michaelis-Menten functional form with a 360 ppm preindustrial reference baseline, crop-specific parameters (maize: β = 10.82, A = 50 ppm; soybean: β = 17.20, A = 100 ppm), and SSP2-4.5 CO₂ concentrations interpolated between 400 ppm (2015) and 538 ppm (2100).
- **Bootstrap inference** uses state-year block resampling with replacement in all scripts. Point estimates are taken from OLS regression on the full dataset; bootstrap distributions are used only for 95% confidence intervals.
- All analyses were conducted in R using RStudio Version 2024.04.2+764.

---

## Data Sources

- **PRISM climate data:** PRISM Climate Group, Oregon State University (https://prism.oregonstate.edu)
- **Soil moisture:** NCA-LDAS Version 3 (Tangdamrongsub et al., 2020)
- **Crop yields:** USDA NASS Quick Stats (https://quickstats.nass.usda.gov)
- **Growing season dates:** USDA NASS Crop Progress reports
- **Future climate:** MACA bias-corrected CMIP6 projections (Abatzoglou & Brown, 2012)

---

## Dependencies

All R package dependencies are loaded within each script. Key packages include:
`dplyr`, `ggplot2`, `sf`, `tigris`, `viridis`, `patchwork`, `lubridate`, `arrow`, `data.table`, `slider`, `officer`
