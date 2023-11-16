version 17

set more off
clear all

cd "/Users/clairezhang/Dropbox/Fall2023/ResearchMethodsII/HW4"

** 1. Load the data

insheet using crime-iv.csv, clear

label variable defendantid "Defendant ID"
label variable republicanjudge "Republican Judge"
label variable severityofcrime "Severity of Crime"
label variable monthsinjail "Months in Jail"
label variable recidivates "Recidivates"

** 2. Balance test

global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest severityofcrime, by(republicanjudge) unequal welch

esttab using test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Democrat" "Republican" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

** 3. IV first stage

eststo: reg monthsinjail republicanjudge severityofcrime 

esttab using firststage.tex, mtitle("IV First Stage") label replace tex

** 4. IV reduced form
eststo clear

eststo: reg recidivates republicanjudge severityofcrime

esttab using reducedform.tex, mtitle("IV Reduced Form") label replace tex


** 5. IV Second Stage
* ssc install ivreg2

eststo clear

eststo: ivreg2 recidivates (monthsinjail = republicanjudge) severityofcrime

esttab using iv.tex, mtitle("IV") label replace tex
