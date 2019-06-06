{% subsection Exercise 2 %}
- Estimate the posterior distribution of `branch_rates` under the relaxed multivariate BM model.
- Compare the estimated correlation parameters under the relaxed mvBM model to those when the average rate is constant across branches. Do the estimated correlation coefficients differ? Do they differ in a consistent direction?
- Modify the `mcmc_relaxed_multivariate_BM.Rev` script to estimate the posterior distribution of `branch_rates` when assuming that characters are uncorrelated. This can be achieved by setting the off-diagonal elements of correlation matrix to 0:
```
R <- diagonalMatrix(nchar)
```
How do branch-specific rates of evolution vary between the correlated and uncorrelated models?
