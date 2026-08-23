#!/usr/bin/env bash
# Paper analysis: gformula bootstrap CI + point estimate + main figures
#   - 02 gformula (bootstrap CI per subgroup)
#   - 03 mortality curves
#   - 04 risk difference at day 28
#   - 02 gformula (--single, full cohort) + 09 natural course vs observed mortality
#
# Usage:
#   bash scripts/run_analysis.sh
#   DATE=260822 N_ITER=25 SG=all bash scripts/run_analysis.sh
#   DATE=260822 N_ITER=25 SGS=all,sofa_10_or_higher bash scripts/run_analysis.sh
#   VISUALIZE=0 DATE=260822 N_ITER=25 SG=all bash scripts/run_analysis.sh
#
# Output:
#   output/${DATE}_gformula_ci_24hr_${sg}.RData
#   output/${DATE}_gformula_pe_24hr_all.RData
#   (+ PNGs when VISUALIZE=1)

set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"
mkdir -p output/logs

DATE="${DATE:-260822}"
N_ITER="${N_ITER:-500}"
SGS="${SGS:-${SG:-all}}"
VISUALIZE="${VISUALIZE:-1}"

IFS=',' read -r -a SG_ARR <<< "${SGS}"
for sg in "${SG_ARR[@]}"; do
  sg="$(echo "${sg}" | xargs)"
  [[ -z "${sg}" ]] && continue
  echo "[run_analysis] date=${DATE} n_iter=${N_ITER} sg=${sg}"
  Rscript scripts/02_gformula.R \
    --sg "${sg}" \
    --date "${DATE}" \
    --n-iter "${N_ITER}" \
    2>&1 | tee "output/logs/gformula_ci_${DATE}_boot${N_ITER}_${sg}.log"

  if [[ "${VISUALIZE}" == "1" ]]; then
    rdata="output/${DATE}_gformula_ci_24hr_${sg}.RData"
    if [[ ! -f "${rdata}" ]]; then
      echo "[run_analysis] ERROR: missing ${rdata}" >&2
      exit 1
    fi
    echo "[run_analysis] visualize date=${DATE} sg=${sg}"
    Rscript scripts/03_fig_gformula_mortality.R \
      --date "${DATE}" --sg "${sg}" \
      2>&1 | tee "output/logs/viz_surv_${DATE}_${sg}.log"
    Rscript scripts/04_fig_risk_difference.R \
      --date "${DATE}" --sg "${sg}" \
      2>&1 | tee "output/logs/viz_rd_${DATE}_${sg}.log"
  fi
done

# Full-cohort point estimate + natural course vs crude mortality figure
echo "[run_analysis] point estimate date=${DATE} sg=all"
Rscript scripts/02_gformula.R \
  --sg all \
  --date "${DATE}" \
  --single \
  2>&1 | tee "output/logs/gformula_pe_${DATE}_all.log"

pe_rdata="output/${DATE}_gformula_pe_24hr_all.RData"
if [[ ! -f "${pe_rdata}" ]]; then
  echo "[run_analysis] ERROR: missing ${pe_rdata}" >&2
  exit 1
fi

if [[ "${VISUALIZE}" == "1" ]]; then
  echo "[run_analysis] natural course vs observed mortality date=${DATE}"
  Rscript scripts/09_fig_natural_course_vs_crude_mortality.R \
    --date "${DATE}" \
    2>&1 | tee "output/logs/viz_nc_vs_crude_${DATE}_all.log"
fi

echo "[run_analysis] Done."
