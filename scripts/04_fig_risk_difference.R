### g-formula risk difference ###
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(ggplot2)
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
library(dplyr)
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")
library(tibble)
if (!requireNamespace("purrr", quietly = TRUE)) install.packages("purrr")
library(purrr)

# Usage:
#   Rscript scripts/04_fig_risk_difference.R --sg all --date 260822
output_dir <- "./output/"
plot_time_window_index <- 28
dpi_out <- 600

args <- commandArgs(trailingOnly = TRUE)
flag_value <- function(args, flag, default = NULL) {
  idx <- which(args == flag)
  if (length(idx) == 0L || length(args) < idx[1] + 1L) return(default)
  args[idx[1] + 1L]
}
date <- flag_value(args, "--date", "260822")
if (!grepl("^[0-9]{6}$", date)) stop("--date must use YYMMDD format.")
sg <- flag_value(args, "--sg", "all")
outdir <- flag_value(args, "--outdir", output_dir)
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
plot_time_window_index <- suppressWarnings(
  as.integer(flag_value(args, "--day", as.character(plot_time_window_index)))
)
if (is.na(plot_time_window_index) || plot_time_window_index < 1L) {
  stop("--day must be a positive integer.")
}

font_family <- "sans"
if (requireNamespace("systemfonts", quietly = TRUE)) {
  fonts <- tryCatch(systemfonts::system_fonts()$family, error = function(e) character())
  if ("Arial" %in% fonts) font_family <- "Arial"
}

rdata_file <- file.path(output_dir, paste0(date, "_gformula_ci_24hr_", sg, ".RData"))
if (!file.exists(rdata_file)) {
  stop("RData file not found: ", rdata_file)
}
load(rdata_file)

dfc <- results[[paste0("combined_", sg)]]
if (is.null(dfc)) {
  stop(
    "Result not found for subgroup '", sg, "'. ",
    "Available keys: ", paste(names(results), collapse = ", ")
  )
}

tm_start_days <- if (exists("tm_start_days")) tm_start_days else 1:2

risk_diff_df <- tibble(
  tm_day = tm_start_days,
  strategy = paste0("TM_day", tm_start_days)
) %>%
  mutate(
    mean_col = paste0(strategy, "_risk_diff_mean"),
    ul_col   = paste0("ul_risk_diff_", strategy),
    ll_col   = paste0("ll_risk_diff_", strategy)
  )

missing_cols <- setdiff(
  c(risk_diff_df$mean_col, risk_diff_df$ul_col, risk_diff_df$ll_col),
  names(dfc)
)
if (length(missing_cols) > 0L) {
  stop("Missing risk-difference columns: ", paste(missing_cols, collapse = ", "))
}

risk_diff_plot_df <- pmap_dfr(
  risk_diff_df,
  function(tm_day, strategy, mean_col, ul_col, ll_col) {
    dfc %>%
      filter(time_points == plot_time_window_index) %>%
      transmute(
        tm_day = tm_day,
        strategy = strategy,
        risk_diff = .data[[mean_col]],
        ul = .data[[ul_col]],
        ll = .data[[ll_col]]
      )
  }
)

p_risk_diff <- ggplot(
  risk_diff_plot_df,
  aes(x = tm_day, y = risk_diff)
) +
  geom_hline(yintercept = 0, linetype = "dashed", linewidth = 0.5) +
  geom_errorbar(
    aes(ymin = ll, ymax = ul),
    width = 0.3,
    linewidth = 0.7
  ) +
  geom_point(size = 2.5) +
  geom_line(linewidth = 0.7) +
  scale_x_continuous(breaks = tm_start_days) +
  labs(
    x = "TM Start Day",
    y = "Risk Difference",
    title = paste0("Risk Difference at Day ", plot_time_window_index)
  ) +
  theme_classic() +
  theme(
    text       = element_text(family = font_family),
    axis.text  = element_text(size = 16),
    axis.title = element_text(size = 16),
    plot.title = element_text(size = 18)
  )

tryCatch(print(p_risk_diff), error = function(e) {
  message("[04] skip interactive print: ", conditionMessage(e))
})

f_risk_diff <- file.path(
  outdir,
  sprintf("%s_g_risk_diff_%shr_%s.png", date, time_window_width, sg)
)

ggsave(
  filename = f_risk_diff,
  plot     = p_risk_diff,
  width    = 8,
  height   = 6,
  dpi      = dpi_out
)
message("[04] wrote ", f_risk_diff)
