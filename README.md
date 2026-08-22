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
└── scripts/
```

- renv
  - Contains files required to reproduce the exact R package environment used in the analysis.
- rocker
  - Contains a Dockerfile for building a containerized R environment consistent with the analysis setup.
- sql
  - Contains SQL queries used for data extraction.
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
