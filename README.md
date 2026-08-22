# rtm-sepsis-coagulopathy-target-trial-emulation

This repository contains the full set of R scripts, SQL queries, and environment configuration files used in a study evaluating recombinant human soluble thrombomodulin (rTM) treatment strategies in patients with sepsis-associated coagulopathy. Using multicenter ICU observational data from Japan, the analyses emulate a target trial and estimate the effects of initiating rTM within 24 hours, between 24 and 48 hours, or not at all, on 28-day all-cause mortality.

---

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
- [Usage](#usage)
- [Contact](#contact)
- [License](#license)

---

## Overview

This project evaluates the effects of clinically relevant rTM treatment strategies on short-term mortality in ICU patients with sepsis-associated coagulopathy, using a target trial emulation framework.

Statistical analyses were conducted in R, and data extraction used SQL. This repository provides:

- SQL queries used for cohort definition and data extraction
- R scripts used for data processing, modeling, and visualization
- Files required to reproduce the R computational environment (`renv`, Docker)

---

## Repository Structure

```
rtm-sepsis-coagulopathy-target-trial-emulation
├── README.md
├── LICENSE
├── renv.lock
├── repository.Rproj
├── renv/
│   ├── activate.R
│   └── settings.json
├── rocker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── up.sh
├── sql/
│   ├── research_tte_anticoagulant_2026_01_eligibility_criteria.sql
│   ├── research_tte_anticoagulant_2026_02_daily_time_windows.sql
│   ├── research_tte_anticoagulant_2026_03_labeling_treatment.sql
│   ├── research_tte_anticoagulant_2026_04_labeling_icu_death_and_discharge_alive.sql
│   ├── research_tte_anticoagulant_2026_05_static_variables.sql
│   ├── research_tte_anticoagulant_2026_11_blood_gas.sql
│   ├── research_tte_anticoagulant_2026_12_laboratory_tests.sql
│   ├── research_tte_anticoagulant_2026_13_bleeding_status.sql
│   ├── research_tte_anticoagulant_2026_14_vital_measurements.sql
│   ├── research_tte_anticoagulant_2026_21_mechanical_ventilations.sql
│   ├── research_tte_anticoagulant_2026_22_renal_replacement_therapy.sql
│   ├── research_tte_anticoagulant_2026_23_scoring.sql
│   ├── research_tte_anticoagulant_2026_24_noradrenaline_equivalent_dose.sql
│   ├── research_tte_anticoagulant_2026_25_heparin_use.sql
│   ├── research_tte_anticoagulant_2026_26_transfusions.sql
│   ├── research_tte_anticoagulant_2026_31_join_all_features.sql
│   ├── research_tte_anticoagulant_2026_32_forward_filling.sql
│   └── research_tte_anticoagulant_2026_33_extract_windows_up_to_28days.sql
└── scripts/
```

- renv
  - Contains files required to reproduce the exact R package environment used in the analysis.
- rocker
  - Contains a Dockerfile for building a containerized R environment consistent with the analysis setup.
- sql
  - Contains SQL queries for data extraction, numbered in pipeline order: cohort and labels (`01`–`05`), time-varying features (`11`–`26`), then join, forward-filling, and final extraction up to 28 days (`31`–`33`).
- scripts
  - Contains R scripts used for data preparation, parametric g-formula simulations, and visualization.

---

## Requirements

To Be Edited

---

## Usage

To Be Edited

---

## Contact

For questions or collaboration inquiries, please reach out to us by email:

- [MeDiCU, Inc.](mailto:info@medicu.co.jp)

---

## License

This project is licensed under the GNU General Public License (GPL) - see the [LICENSE](https://github.com/io-murayama/rtm-sepsis-coagulopathy-target-trial-emulation/blob/main/LICENSE) file for details.

---

**Disclaimer:**
The code in this repository is provided for academic research and educational purposes. Individual patient data are not provided.
