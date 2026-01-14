# COEFSTABILITY: Coefficient Stability Test (Oster 2019 Method)

## SYNTAX

```stata
coefstability depvar indepvar [if] [in] [weight] ,
    controls(varlist) [ delta(#) rmax(#) model(cmd) modelopts(string)
    bootstrap reps(#) seed(#) cluster(varname) level(#) noisily
    saving(filename [ , replace ] ) ]
```

*`if` and `in` qualifiers are allowed. Weights (such as aweights or fweights) are also allowed and are applied to both base and full regressions. The command is r-class, returning results in r().*

## DESCRIPTION

`coefstability` tests the stability of a regression coefficient to omitted variable bias using the method of Oster (2019). It estimates how the coefficient of an independent variable (the "treatment") changes when adding a set of control variables, and computes the Oster (2019) bias-adjusted coefficient under assumptions about unobserved selection.

The command runs two regressions:

1. **Base Model**: Using `depvar` on `indepvar` with no controls.
2. **Full Model**: Including `indepvar` plus the specified `controls()` variables.

Using the estimates from these models and user-specified parameters $\delta$ (delta) and $R_{max}$, `coefstability` calculates the **adjusted coefficient** (often called $\beta^*$) for the independent variable of interest. This adjusted coefficient is an estimate of the true effect of the independent variable, under the assumption that selection on unobservables is $\delta$ times the selection on observables and that the maximum attainable R-squared is $R_{max}$.

In addition, the command computes the value of $\delta$ (denoted $\delta^*$) that would be required to drive the adjusted coefficient to zero (i.e., the degree of unobserved selection needed to explain away the effect, given the chosen $R_{max}$). By comparing $\delta^*$ to a benchmark (such as $\delta = 1$, equal selection on unobservables and observables), researchers can assess the robustness of the result.

If the `bootstrap` option is specified, `coefstability` will also provide a bootstrapped standard error and confidence interval for the adjusted coefficient $\beta^*$. This allows formal inference on the adjusted estimate. The output of the command displays the unadjusted coefficients and R-squared from the base and full models, the bias-adjusted coefficient $\beta^*$ given the specified $\delta$ and $R_{max}$, its standard error and confidence interval (if bootstrapped), and the solved $\delta^*$ that sets $\beta^*$ to zero.

This method implements Oster’s (2019) coefficient stability analysis (often referred to as the Oster $\delta$ method or Oster’s bounding approach) for linear regression models. It is useful for examining how robust an estimated effect is to potential omitted variable bias, by formally adjusting the coefficient based on the movement of the coefficient and R-squared when controls are added.

## OPTIONS

* **`controls(varlist)`**
  Specifies the control variables to include in the full model (in addition to the main independent variable of interest). The coefficient on `indepvar` is compared between a regression with only `indepvar` (base model) and a regression including `indepvar` plus these controls (full model). **This option is required**: it defines the set of observed controls whose inclusion is used to test stability. The base model will exclude these controls, while the full model includes them. (Any fixed effects or other controls that should be in both models—e.g., panel fixed effects—can be handled via the `modelopts()` or `model()` options as described below.)
* **`delta(#)`**
  Sets the assumed relative degree of selection on unobservables to observables, $\delta$. This parameter $\delta$ represents how strongly the unobserved factors are related to the treatment relative to the observed controls. For example:

  * $\delta = 1$ corresponds to equal selection on unobservables and observables (a commonly used benchmark).
  * $\delta = 0.5$ assumes unobservables are half as correlated with the treatment as observables.
  * $\delta = 2$ assumes unobservables are twice as important as observables.
    The specified $\delta$ is used in calculating the bias-adjusted coefficient $\beta^*$.
    *Default: `delta(1)`* (equal selection on unobservables and observables), which provides an upper-bound robustness check as suggested by Oster (2019). $\delta$ must be non-negative; values between 0 and 1 indicate relatively less selection on unobservables, whereas values greater than 1 indicate stronger selection on unobservables than on observables.
* **`rmax(#)`**
  Sets the assumed maximum R-squared ($R_{max}$) for a hypothetical regression of `depvar` on `indepvar` plus all relevant observed and unobserved controls. $R_{max}$ represents the theoretical upper bound of the R-squared if we could include all controls (observed and unobserved) that determine the outcome. The user should choose $R_{max}$ based on subject matter knowledge; it should be at least as large as the R-squared from the full model and cannot exceed 1.
  *Default: `rmax(1)`* (100% of outcome variation explainable), which is a conservative assumption often used in robustness analysis. In practice, researchers sometimes set $R_{max}$ to 1 or to a value slightly above the R-squared of the full model (e.g., 1.3 times $R_{full}$ if that does not exceed 1). The choice of $R_{max}$ will affect the adjusted estimate: a lower $R_{max}$ (closer to $R_{full}$) implies less scope for unobservables to explain additional variance, usually leading to a smaller adjustment ($\beta^*$ closer to the full model coefficient).
* **`model(cmd)`**
  Specifies an alternate estimation command to use for the regressions. By default, `coefstability` uses OLS regression (`regress`) for both the base and full model. With `model()`, you can choose a different regression estimator, for example:

  * `model(reghdfe)` to use the `reghdfe` command (from SSC) for high-dimensional fixed effects. This is useful if you need to absorb fixed effects (multiple levels) in both the base and full models. If `model(reghdfe)` is used, the user must have the `reghdfe` package installed.
  * `model(xtreg)` to use Stata’s `xtreg` for panel data models. This can be combined with appropriate `modelopts()` such as `fe` or `re` to specify fixed-effects or random-effects.
    The `model()` option allows the coefficient stability test to be applied in contexts beyond simple OLS, as long as the chosen model command produces an R-squared (or within R-sq for fixed effects) that can be compared between the base and full specification.
    *Default: `model(regress)`* (standard OLS regression).
* **`modelopts(string)`**
  Passes additional options or arguments to the chosen model command specified in `model()`. The content of `modelopts()` is appended to the regression command.

  * For example, if using `model(reghdfe)`, you might specify `modelopts(absorb(region) vce(cluster county))` to absorb a fixed effect for region and request clustered standard errors by county in the regression.
  * If using `model(xtreg)`, you can add `modelopts(fe)` for a fixed-effects model (within estimator), or `modelopts(re)` for random-effects, and you may include `vce(robust)` or `vce(cluster clustvar)` if desired.
  * For OLS (`model(regress)`), any valid regress options (e.g., `vce(robust)`) can be supplied via `modelopts()`.
    *Note: Do not include the dependent variable, independent variable, or control variables in `modelopts()` — those are already handled by the command. Also, be cautious not to duplicate options that are provided elsewhere (for instance, if using the `cluster()` option, you typically should not also specify a cluster in `modelopts()`, unless you intend to cluster at a different level for the regression output). In general, `modelopts()` is used to specify `vce` options, fixed effects absorption, or other regression-specific settings that apply to both the base and full model runs.*
* **`bootstrap`**
  A flag (no argument) that requests bootstrap estimation of the standard error for the adjusted coefficient $\beta^*$. When `bootstrap` is specified, the command will perform a bootstrap procedure, repeatedly resampling the data and recalculating $\beta^*$ for each replication, in order to estimate the sampling variability of the adjusted coefficient. The bootstrap is applied to the entire sequence (base model, full model, and $\beta^*$ calculation) on each replication. By default, the bootstrap uses simple random resampling of observations (with replacement); if the `cluster()` option is also given, resampling will be done at the cluster level (see `cluster()` below). Bootstrapping can be time-consuming, especially with many controls or large datasets, so consider using a moderate number of replications or parallel processing if available. The output will include the bootstrap standard error for $\beta^*$ and a confidence interval at the specified `level()`.
* **`reps(#)`**
  Specifies the number of bootstrap replications to perform when `bootstrap` is chosen. More replications generally yield more precise estimates of the standard error but take longer.
  *Default: 100 replications* (if `bootstrap` is enabled and `reps()` is not specified). You can increase this (e.g., `reps(500)` or `reps(1000)`) for more stable results, especially if you plan to use the confidence interval or test significance.
* **`seed(#)`**
  Sets the random-number seed for the bootstrap replications. Setting a seed ensures that the bootstrap results are reproducible. For example, `seed(12345)` will initialize the random number generator to 12345 before drawing bootstrap samples. If no seed is specified, the current state of Stata’s random-number generator is used (meaning results may differ each run unless a seed is set externally). This option is only relevant when `bootstrap` is used.
* **`cluster(varname)`**
  Specifies a clustering variable for the bootstrap (and for the regression models). If this option is given, bootstrap resampling is performed at the level of clusters defined by `varname` (rather than at the level of individual observations). In each replication, entire clusters are sampled with replacement, which is appropriate when the data are clustered (e.g., individuals within households, students within schools, etc.). Additionally, if `cluster()` is provided, the base and full regression models will be estimated with cluster-robust standard errors using `varname` as the cluster variable (where supported by the model command). This ensures the R-squared and coefficient estimates use all observations but any reported standard errors in the underlying model output would account for clustering. Note that clustering in the regression does not affect the coefficient or R-squared values used for the Oster calculation; it mainly affects standard error estimation. The primary effect of `cluster()` in this command is on the bootstrap resampling scheme.
* **`level(#)`**
  Specifies the confidence level, in percent, for the confidence interval of the adjusted coefficient reported when bootstrap is used. The default is `level(95)`, corresponding to a 95% confidence interval. You can set, for instance, `level(90)` for a 90% confidence interval or any other value between 0 and 100. The confidence interval is computed using the normal approximation ($\beta^* \pm z \times SE$, where $z$ is the critical value for the given level), assuming a sufficiently large sample such that the bootstrap estimate is approximately normally distributed. The `level()` option has no effect if `bootstrap` is not requested.
* **`noisily`**
  Displays the output of the internal regression commands. By default, `coefstability` runs the base and full regressions quietly (suppressing their detailed output) and only prints the summary results (coefficients, R-squared, etc., and the final calculations). If `noisily` is specified, the command will instead run the regressions verbosely, so you will see the full regression output for the base and full models in the Results window. This can be useful for debugging or to verify the regression results (e.g., to check coefficients, standard errors, or model diagnostics) before the stability calculations are shown.
* **`saving(filename [ , replace ])`**
  Saves the bootstrap results to a Stata dataset. If `bootstrap` is used, this option creates a new dataset file (`filename.dta`) containing the bootstrap estimates from each replication. Specifically, for each replication, the adjusted coefficient $\beta^*$ (and possibly related statistics) are saved as observations in the dataset. This allows you to analyze the bootstrap distribution or perform additional custom analyses on the bootstrap results. By default, `saving()` will not overwrite an existing file of the same name; the `replace` suboption can be specified to allow overwriting. For example, `saving(bs_results, replace)` will save the bootstrap estimates to `bs_results.dta`, replacing any file with that name. This option is ignored if `bootstrap` is not specified.

## RETURN VALUES

`coefstability` returns the following scalars in `r()`, which can be accessed after the command (e.g., with `return list`):

* **`r(b_full)`** – The coefficient estimate for `indepvar` from the full model (with controls). This is the "controlled" or fully adjusted OLS (or specified model) estimate of the effect, using all variables (`indepvar` + controls).
* **`r(b_base)`** – The coefficient estimate for `indepvar` from the base model (with no controls, or only the `indepvar` and any fixed effects specified via model options). This is the "uncontrolled" or baseline estimate of the effect of the independent variable.
* **`r(r2_full)`** – The R-squared from the full model regression. If using a fixed-effects model (e.g., `xtreg, fe` or `reghdfe`), this is the R-squared corresponding to that model (for `xtreg, fe` it would be the within R-squared; for OLS it’s the usual R-squared).
* **`r(r2_base)`** – The R-squared from the base model regression (analogous definition as above, but for the regression without the additional controls).
* **`r(beta_star)`** – The bias-adjusted coefficient ($\beta^*$) for `indepvar`, calculated using the Oster (2019) formula given the specified $\delta$ and $R_{max}$. This is the primary result of the coefficient stability test – an estimate of what the coefficient on `indepvar` would be if we could account for unobserved selection consistent with the provided $\delta$ and if the maximum R-squared is $R_{max}$.
* **`r(delta_star)`** – The implied value of $\delta$ (relative selection on unobservables) that would drive the adjusted coefficient to zero. This is solved from the Oster methodology holding $R_{max}$ constant: it is the threshold $\delta$ at which $\beta^* = 0$. If `r(delta_star)` is high (greater than 1), it means unobservables would have to be much stronger than observables to overturn the result; if it’s below 1, then even equal or modest unobservable selection could nullify the effect.
* **`r(se)`** – Returned only if `bootstrap` is specified. This is the bootstrap standard error for the adjusted coefficient `r(beta_star)`. It is calculated as the standard deviation of the $\beta^*$ estimates across the bootstrap replications.
* **`r(ci_low)`** – Returned only if `bootstrap` is specified. Lower bound of the confidence interval for $\beta^*$ at the specified `level()` (e.g., lower 95% bound by default).
* **`r(ci_high)`** – Returned only if `bootstrap` is specified. Upper bound of the confidence interval for $\beta^*$ at the specified confidence level.

*(No e-class results are saved, since `coefstability` is an r-class command. The underlying regression models (base and full) are run but their results are not retained in `e()`, aside from what is used to compute the above scalars. To access other regression output, use the `noisily` option or run the regressions separately.)*

## EXAMPLES

**Example 1: Basic usage (OLS)**
Suppose we want to test the stability of the effect of fuel efficiency (`mpg`) on `price` using the `auto` dataset. We include `weight` and `length` as control variables in the full model. By default, the command assumes $\delta = 1$ and $R_{max} = 1$.

```stata
sysuse auto, clear
coefstability price mpg, controls(weight length)
```

*Interpretation:* The command will output the coefficient of `mpg` from the full model (including weight and length) and from the base model (excluding controls), along with their R-squared values. It then calculates the adjusted coefficient $\beta^*$ for `mpg` based on the assumptions $\delta = 1$ and $R_{max} = 1$. It also reports $\delta^*$, which indicates how strong the selection on unobservables would need to be (relative to observables) to explain away the estimated effect.

**Example 2: Different $\delta$ and $R_{max}$ assumptions**
We can explore how the adjusted coefficient changes under different theoretical assumptions. Using the same data and variables as above, we first test a scenario with weaker unobserved selection ($\delta=0.5$) and a lower theoretical maximum R-squared ($R_{max}=0.8$). Then, we test a stricter scenario with stronger unobserved selection ($\delta=2$) assuming the full model could theoretically explain all variance ($R_{max}=1$):

```stata
* Assuming weaker unobserved selection (delta=0.5) and Rmax=0.8
coefstability price mpg, controls(weight length) delta(0.5) rmax(0.8)

* Assuming stronger unobserved selection (delta=2) with full Rmax=1
coefstability price mpg, controls(weight length) delta(2) rmax(1)
```

**Example 3: Bootstrapping the adjusted coefficient**
To assess the statistical uncertainty of the adjusted estimate $\beta^*$, we can request bootstrap standard errors and confidence intervals. In this example, we specify 500 replications and set a random seed for reproducibility:

```stata
coefstability price mpg, controls(weight length) bootstrap reps(500) seed(12345)
```

**Example 4: Using reghdfe (high-dimensional fixed effects)**
If the outcome is influenced by group fixed effects, we can employ the `reghdfe` package. Here, we test the effect of `mpg` on `price` while controlling for `weight` and `length`, and absorbing the `rep78` (repair record) categories as fixed effects in both the base and full models.

```stata
sysuse auto, clear
coefstability price mpg, controls(weight length) ///
   model(reghdfe) modelopts(absorb(rep78))
```

*Note: `model(reghdfe)` specifies the estimator, and `absorb(rep78)` is passed via `modelopts()` to handle the fixed effects.*

**Example 5: Using xtreg (panel data) with bootstrap**
For panel data analysis, we can evaluate coefficient stability using Stata's native `xtreg`. In this example using the National Longitudinal Survey dataset, we test the stability of the coefficient for `hours` worked on log wages (`ln_wage`), controlling for various covariates and year fixed effects.

```stata
webuse nlswork, clear
xtset idcode year
* Test effect of hours worked on log wages, controlling for age, tenure, etc. (FE model)
coefstability ln_wage hours, ///
    controls(age ttl_exp tenure not_smsa south i.year) ///
    model(xtreg) ///
    modelopts(fe) ///
    delta(1) rmax(1) ///
    bootstrap reps(100) ///
    seed(12345)
```

**Example 6: Using reghdfe (panel data) with cluster bootstrap**
We can also apply the stability test to high-dimensional panel models using `reghdfe` with two-way fixed effects. Here, we estimate the effect of `hours` on `ln_wage`, absorbing both individual (`idcode`) and time (`year`) fixed effects. We request clustered standard errors (clustered by `idcode`), assume $\delta=0.8$, and let the program automatically calculate $R_{max}$ (by setting it to -1).

```stata
webuse nlswork, clear
xtset idcode year
* Test effect of hours worked on log wages using reghdfe with 2-way FE
coefstability ln_wage hours, ///
    controls(age ttl_exp tenure not_smsa south) ///
    model(reghdfe) ///
    modelopts(absorb(idcode year)) ///
    cluster(idcode) ///
    delta(0.8) rmax(-1) ///
    bootstrap reps(100) seed(12345) ///
    noisily
```

## AUTHOR

马俊豪
