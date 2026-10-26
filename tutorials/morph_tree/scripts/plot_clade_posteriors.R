# R script to compare the posterior probabilities of clades between different models
#
# Run from the directory that contains the output/ folder, after running
# scripts/mcmc_covariomorph.Rev with MODEL = "Mk", "ACRV", and "Covariomorph":
#           Rscript scripts/plot_clade_posteriors.R
#
# authors: Basanta Khakurel and Sebastian Höhna

library(ape)
library(ggplot2)
library(patchwork)
library(convenience)

DATASET <- "snakes"
MODELS <- c("Mk", "ACRV", "Covariomorph")
NUM_CATEGORIES <- 3
LABELS <- c(
  Mk = "Mk",
  ACRV = paste0("ACRV (m=", NUM_CATEGORIES, ")"),
  Covariomorph = paste0("Covariomorph (m=", NUM_CATEGORIES, ")")
)
BURNIN <- 0.25
ESS <- 200

# fucntyion to read trees and remove burnin
read_trees <- function(model) {
  files <- Sys.glob(file.path("output", paste0(DATASET, "_", model, "_run_*.trees")))
  if (length(files) == 0) stop("No tree files found for model ", model)
  trees <- lapply(files, function(f) {
    x <- read.table(f,
      header = TRUE, sep = "\t", stringsAsFactors = FALSE,
      comment.char = "", quote = ""
    )
    x <- x[-seq_len(floor(BURNIN * nrow(x))), ]
    read.tree(text = gsub("\\[[^]]*\\]", "", x$phylogeny))
  })
  do.call(c, trees)
}

# function for getting posteror probability of clade after rooting into one taxon
clade_probs <- function(trees, root_taxon) {
  trees <- root(trees, root_taxon, resolve.root = TRUE)
  parts <- prop.part(trees, check.labels = TRUE)
  tips <- attr(parts, "labels")
  size <- sapply(parts, length)
  keep <- size > 1 & size < length(tips) - 1
  key <- sapply(parts[keep], function(p) paste(sort(tips[p]), collapse = ","))
  setNames(attr(parts, "number")[keep] / length(trees), key)
}

trees <- lapply(MODELS, read_trees)
names(trees) <- MODELS
root_taxon <- sort(trees[[1]][[1]]$tip.label)[1]
probs <- lapply(trees, clade_probs, root_taxon = root_taxon)

# get the difference in expected clade probability between two samples of the
# same posterior distribution, each with an effective sample size of 200
expected_diff <- convenience:::expectedDiffSplits(ESS)
threshold_for <- function(p) {
  p <- pmin(pmax(round(p, 2), 0.01), 0.99)
  expected_diff["threshold", match(p, round(expected_diff["prob", ], 2))]
}

# function to compare two models
compare <- function(m1, m2) {
  clades <- union(names(probs[[m1]]), names(probs[[m2]]))
  p1 <- ifelse(clades %in% names(probs[[m1]]), probs[[m1]][clades], 0)
  p2 <- ifelse(clades %in% names(probs[[m2]]), probs[[m2]][clades], 0)
  keep <- pmax(p1, p2) >= 0.01
  p1 <- p1[keep]
  p2 <- p2[keep]
  different <- abs(p1 - p2) > threshold_for((p1 + p2) / 2)
  data.frame(
    x = p1, y = p2,
    difference = factor(ifelse(different, "Different", "Not different"),
      levels = c("Not different", "Different")
    )
  )
}

colors <- c("Not different" = "#2a78d6", "Different" = "#eb6834")
shapes <- c("Not different" = 16, "Different" = 17)

# one panel per pair
plot_pair <- function(m1, m2) {
  points <- compare(m1, m2)
  cat(
    LABELS[m1], "vs.", LABELS[m2], ":",
    sum(points$difference == "Different"), "of", nrow(points),
    "clades differ\n"
  )

  ggplot(points, aes(x = x, y = y, color = difference, shape = difference)) +
    geom_abline(
      slope = 1, intercept = 0, color = "grey50",
      linewidth = 0.4, linetype = "dashed"
    ) +
    geom_point(size = 2.2, alpha = 0.85) +
    scale_color_manual(values = colors, name = NULL, drop = FALSE) +
    scale_shape_manual(values = shapes, name = NULL, drop = FALSE) +
    scale_x_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    coord_equal() +
    labs(x = LABELS[m1], y = LABELS[m2]) +
    theme_minimal(base_size = 12) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey92"),
      panel.border = element_rect(fill = NA, color = "grey80"),
      plot.background = element_rect(fill = "white", color = NA)
    )
}

p <- plot_pair("Mk", "ACRV") +
  plot_pair("Mk", "Covariomorph") +
  plot_pair("ACRV", "Covariomorph") +
  plot_layout(nrow = 1, guides = "collect") &
  theme(legend.position = "top")

dir.create("figures", showWarnings = FALSE)
ggsave(paste0("figures/clade_posteriors_", DATASET, ".png"), p, width = 10, height = 4, dpi = 450)
ggsave(paste0("figures/clade_posteriors_", DATASET, ".pdf"), p, width = 10, height = 4)
