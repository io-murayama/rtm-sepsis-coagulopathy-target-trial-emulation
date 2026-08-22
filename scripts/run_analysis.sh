#!/usr/bin/env bash
# Paper analysis: gformula bootstrap CI + main figures
#   - 02 gformula
#   - 03 mortality curves
#   - 04 risk difference at day 28
#
# Usage:
#   bash scripts/run_analysis.sh
#   DATE=260822 N_ITER=25 SG=all bash scripts/run_analysis.sh
#   DATE=260822 N_ITER=25 SGS=all,sofa_10_or_higher bash scripts/run_analysis.sh
#   VISUALIZE=0 DATE=260822 N_ITER=25 SG=all bash scripts/run_analysis.sh
#
# Output:
#   output/${DATE}_gformula_ci_24hr_${sg}.RData
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
echo "[run_analysis] Done."
