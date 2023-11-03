version 17

clear all
set more off

cd "/Users/clairezhang/Dropbox/Fall2023/ResearchMethodsII/HW2"

** 1. Load the data
insheet using "vaping-ban-panel.csv", clear 

label variable stateid "State"
label variable year "Year"
label variable vapingban "Vaping Ban"
label variable lunghospitalizations "Lung Hospitalizations"

// tell Stata this is panel data
*xtset stateid year

** 2. Use a regression to evaluate the "parallel trends" requirement of a difference-in-difference ("DnD") estimate. 
// create variable indicating the post period
gen post = (year >= 2021)

// create variable indicating if the state was treated at any time
egen treated = max(vapingban == 1), by(stateid)

gen treated_year = treated*year

eststo: reg lunghospitalizations treated_year if post == 0


* reg lunghospitalizations year if treated == 0 & year < 2021
* reg lunghospitalizations year if treated == 1 & year < 2021


** 3. Create the canonical DnD line graph. 
// calculate means per year
egen avg_lh = mean(lunghospitalizations), by(treated year)
label variable avg_lh "Average Lung Hospitalizations"

twoway (line avg_lh year if treated == 1, sort) (line avg_lh year if treated == 0, sort), xline(2020) legend(label(1 Treated) label(2 Control))

graph export "didlinegraph.jpg", replace


** 4. Runs a regression to estimate the treatment effect of the laws. 
/** 
Be sure that your DnD regression(s) include time period fixed effects as well as state fixed effects. 
 To get fixed-effects in Stata, you can either do: 
areg outcome_var [other vars], absorb(fixed_effects_variable)
or 
reg outcome_var [other vars] i.fixed_effects_variable 
**/

gen treated_post = treated*post

eststo: reg lunghospitalizations treated_post i.stateid i.year


** 5. Output your from regressions #1 and #4 into a publication-quality table. 
/** 
Do not manually create a table. 
Your code must create the table. 
**/

esttab using HW2tables.tex, mtitle("Parallel Trends Test" "DiD") longtable label replace tex

// test if state fixed effect coefficient is 0 
testparm i.stateid

