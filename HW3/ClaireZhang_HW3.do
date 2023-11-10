version 17

set more off
clear all

cd "/Users/clairezhang/Dropbox/Fall2023/ResearchMethodsII/HW3"

** 1. Load the data

insheet using sports-and-education.csv, clear

// label variables

label variable collegeid "College ID"
label variable academicquality "Academic Quality"
label variable athleticquality "Athletic Quality`'"
label variable nearbigmarket "Near Big Market"
label variable ranked2017 "Ranked 2017"
label variable alumnidonations2018 "Alumni Donations in 2018"


** 2. Balance tables

global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch

esttab using test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)


** 3. Propensity score model

// predicting probability of being ranked

eststo: logit ranked2017 academicquality athleticquality nearbigmarket
predict pred_ranked

esttab using psm.tex, mtitle("Propensity Score Model") label replace tex

** 4. Stacked histogram
twoway histogram pred_ranked, start(0) width(.1) bc(red%30) freq || histogram pred_ranked if ranked2017==0, start(0) width(.1) bc(blue%30) freq legend(order(1 "Treatment (Ranked)" 2 "Control (Unranked)"))

graph export "histogram.jpg", replace

** 5. Blocking on propensity score

sort pred_ranked
gen block = ceil(_n/4)


** 6. Model

eststo clear

eststo: reg alumnidonations2018 ranked2017 pred_ranked academicquality athleticquality nearbigmarket i.block

esttab using blocked_reg.tex, mtitle("Effect of Being Ranked on Alumni Donations") label longtable replace tex



