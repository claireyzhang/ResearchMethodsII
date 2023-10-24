version 17

clear all
set more off

cd "/Users/clairezhang/Dropbox/Fall2023/ResearchMethodsII/HW1"

** a. Load the data

insheet using "assignment1-research-methods.csv", clear

* re-label variable

label variable eliteschoolcandidate "Elite School Candidate"

** b. Perform the regression necessary to measure the effect of having an elite college on whether 
** the fictitious candidate's job application was called back

reg calledback eliteschoolcandidate

* Store the regression
eststo regression_one

** c. Output your results into a publication-quality table. 

* Export to LaTex

global tableoptions "bf(%15.2gc) sfmt(%15.2gc) prehead(\begin{tabular}{l*{14}{c}}) postfoot(\end{tabular}) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"

esttab regression_one using HW1.tex, $tableoptions keep(eliteschoolcandidate) 
