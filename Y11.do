//import CSV
import delimited "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\Original files\GPPS Y11 Person Dataset weighted - No barcode CSV.csv", varnames(1)desc
//(156 vars, 808,332 obs)

//Log output and codes
log using "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\Original files\Y11 Log.log"

//save CSV as .dta
save "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\Year 11 -2017\Year11weighteddata.dta"

//start here-opening New Stata raw file
use "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\Year 11 -2017\Year11weighteddata.dta", clear
desc

//convert string to numeric
destring, replace
desc

//assumption check-missing data and outliers
misstable sum 
//18821 missing cancer info. No outliers.

sysdir set PLUS "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\plus"

findit mdesc_ado

mdesc 
//no missing cancer info
//7.43% did not provide QoL data so those were excluded from analysis

gen qol=eq_5d_5l
drop if qol==.
tab q31_6 [iweight=wt_new], missing 
//7.36% of patients missing cancer info

//recode cancer
gen cancer =q31_6
label var cancer  "cancer status"
label define canlab 0 "no cancer" 1 "has cancer"
label val cancer canlab
tab cancer [iweight= wt_new], missing

//exclude people w/o complete cancer info
keep if cancer>=0
drop if cancer==.

svyset [iweight=wt_new]
svy: mean qol, over(cancer)
svy: regress qol cancer
//The coefficient for cancer is the t-test.

//table 4.5
mean qol if cancer==1 [iw=wt_new]
tab depriv if cancer==1 [iw=wt_new]

//recode age
gen ageg=q48
drop if ageg<0
label define agelab 2 "18-24" 3 "25-34" 4 "35-44" 5 "45-54" 6 "55-64" 7 "65-74" 8 "75-84" 9 "85 or over"
label val ageg agelab
tab ageg if cancer==1 [iw=wt_new]

//recode sex
gen sex=q47
drop if sex<0
label define sexlab 1 "M" 2 "F" 
label val sex sexlab
tab sex if cancer==1 [iw=wt_new]

//recode ethnicity
gen whiteornot=q49
label var whiteornot "White or non-white"
recode whiteornot -3=-3 1=1 2=1 3=1 4=1 5=2 6=2 7=2 8=2 9=2 10=2 11=2 12=2 13=2 14=2 15=2 16=2 17=2 18=2
label define wlab -3 "missing" 1 "white" 2 "non-white"
label val whiteornot wlab
tab whiteornot q49
drop if whiteornot <0
tab whiteornot if cancer==1 [iw=wt_new]

//smoking recoded
gen smoking =q55
label var smoking "smoking history"
label define smlab -3 "missing" -1 "missing" 1 "never" 2 "former" 3 "occasional" 4 "regular"
label val smoking smlab
drop if smoking<0
tab smoking if cancer==1 [iw=wt_new]

//recode alzheimer
tab q31_1
gen alzheimer =q31_1
label var alzheimer  "Alzheimer/dementia"
label define alzlab 0 "no alz/dementia" 1 "has alz/dementia"
label val alzheimer alzlab
tab alzheimer

//recode heart
tab q31_2
gen heart =q31_2
label var heart  "long-term heart condition/angina"
label define heartlab 0 "no" 1 "yes"
label val heart heartlab
tab heart

//recode arthritis
tab q31_3
gen arthritis =q31_3
label var arthritis  "Arthritis/joint problem"
label define artlab 0 "no arthritis/joint problem" 1 "has arthritis/joint problem"
label val arthritis artlab
tab arthritis

//recode asthma
tab q31_4
gen copd =q31_4
label var copd  "asthma/chest problem"
label define copdlab 0 "no" 1 "yes"
label val copd copdlab
tab copd

//recode blindness
tab q31_5
gen blind =q31_5
label var blind  "blindness/severe visual impairment"
label define blindlab 0 "no" 1 "yes"
label val blind blindlab
tab blind

//recode deaf
tab q31_7
gen deaf =q31_7
label var deaf  "deaf/hearing loss"
label define deaflab 0 "no" 1 "yes"
label val deaf deaflab
tab deaf

//recode diabetes
tab q31_8
gen diabetes =q31_8
label var diabetes  "diabetes"
label define dlab 0 "no" 1 "yes"
label val diabetes dlab
tab diabetes


//recode epilepsy
tab q31_9
gen epi =q31_9
label var epi  "epilepsy"
label define elab 0 "no" 1 "yes"
label val epi elab
tab epi

//recode high blood pressure
tab q31_10
gen hbp =q31_10
label var hbp  "high blood pressure"
label define hlab 0 "no" 1 "yes"
label val hbp hlab
tab hbp

//recode kidney
tab q31_11
gen kidney =q31_11
label var kidney  "kidney/liver disease"
label define klab 0 "no" 1 "yes"
label val kidney klab
tab kidney

//recode back
tab q31_13
gen back =q31_13
label var back  "long term back problem"
label define backlab 0 "no back problem" 1 "has back problem"
label val back backlab
tab back

//recode learning disabilty
tab q71
gen LD =q71
drop if LD<0
label var LD  "learning disability"
recode LD 1=1 2=0
label define LDlab 1 "yes" 0 "no" 
label val LD LDlab
tab LD

//recode mnental health condition
tab q31_14
gen MH =q31_14
label var MH  "long-term mental health condition"
label define mlab 0 "no" 1 "yes"
label val MH mlab
tab MH

//recode neurological
tab q31_15
gen neurological =q31_15
label var neurological  "LT neurological problem"
label define nlab 0 "no" 1 "yes"
label val neurological nlab
tab neurological


//recode other
tab q31_16
gen other =q31_16
label var other  "other LTC/disability"
label define olab 0 "no" 1 "yes"
label val other olab
tab other

tab1 alzheimer heart arthritis copd blind  deaf  diabetes  epi hbp kidney back LD MH  neurological other if cancer==1 [iweight= wt_new]

//work out prevalence with multimorbidity 16 total including cancer
gen numberofLTC = alzheimer+ heart+ arthritis+ cancer+copd+ blind+  deaf + diabetes + epi + hbp + kidney + back + LD+ MH + neurological+ other

//check it's coded correctly
tab numberofLTC if cancer==1 [iw=wt_new]
sum cancer alzheimer heart arthritis copd blind  deaf  diabetes  epi hbp kidney back LD MH  neurological other if cancer==1 [iweight= wt_new]

mean numberofLTC if cancer==1 [iw=wt_new]

//recode usual activities - do not use as it's EQ5D's subscale
/*tab q34c
gen ADL =q34c
label var ADL  "Q34c. State of health today...Usual Activities"
recode ADL 1=0 2=1 3=1 4=1 5=1
label define ADLlab 0 "no problems doing usual activities"  1 "slight/moderate/severe/unable" 
label val ADL ADLlab
tab ADL if cancer==1 [iweight= wt_new]*/

//recode pain- do not use as it's EQ5D's subscale
/*
tab q34d
gen pain =q34d
label var pain  "Q34d. State of health today...Pain/Discomfort"
recode pain 1=0 2=1 3=1 4=1 5=1
label define painlab 0 "none"  1 "slight/moderate/severe/extreme" 
label val pain painlab
tab pain if cancer==1 [iweight= wt_new]*/

//given written care plan ?
tab q59
gen plan=q59
label var plan "given a written care plan"
label define planlab 1 "yes" 2 "no" 3 "don't know"
label val plan planlab
drop if plan<0
tab plan if cancer==1 [iweight= wt_new]

//•	Q18: Overall, how would you describe your experience of making an appointment?
tab q18
gen exp=q18
label var exp "Overall experience of making an appointment"
label define explab 1"very good" 2"fairly good" 3"neutral" 4 "fairly poor" 5"very poor"
label val exp explab
drop if exp<0
tab exp if cancer==1 [iweight= wt_new]

//•	Q21a: Last time you had a general practice appointment, how good was the healthcare professional at: Giving you enough time – GP
tab q21a
gen time=q21a
label var time "Did GP give you enough time?"
label define timelab 1"very good" 2"good" 3"neutral" 4 "poor" 5"very poor" 6"Not Applicable"
label val time timelab
drop if time<0
tab time if cancer==1 [iweight= wt_new]

//•	Q28: Overall, how would you describe your experience of your GP practice?
tab q28
gen GPexp=q28
label var GPexp "Overall, how would you describe your experience of your GP practice"
label define GPexplab  1"very good" 2"good" 3"neutral" 4 "poor" 5"very poor" 
label val GPexp GPexplab
drop if GPexp <0
tab GPexp if cancer==1 [iweight= wt_new]

//Q51. Journey time from home to work
tab q51
gen commute=q51
label var commute "Journey time from home to work"
recode commute 1=0 2=0 3=1 4=0 
label define clab  0 "up to 1 hour" 1">1hr" 
label val commute clab
drop if commute <0
tab commute if cancer==1 [iweight= wt_new]

//SVY and iweight fucntions not allowed with hist
hist qol if cancer==1, norm

//can you transform QOL
gladder qol if cancer==1
//svy not allowed

// create mean QoL by var and significance test table 4.6 unadjusted 
//show mean and 95%CI
xi: svy: mean qol if cancer==1, over (depriv)

oneway qol depriv if cancer==1 [w=wt_new], tab //doesn't work with freq weighting
oneway qol depriv if cancer==1, tab //Bartlett's test for = variance doesn't show much difference than analytical weighting
//p<0.05 show unequal variance so need to use nonparametric
kwallis qol if cancer==1, by(depriv) //weights not allowed
//sig difference bw the 4 age groups (p=.0001)

//use regress for anova oneway
xi: svy: regress qol i.depriv if cancer==1 
//p<0.05 associated w/QoL
testparm _I*
//p<0.05 sig dif btw groups  


//does age have a quad efx?
gen agesq=ageg*ageg
label var agesq "Age square"
regress qol ageg agesq if cancer==1 [iw=wt_new]
//yes

xi: svy: mean qol if cancer==1, over (ageg)
oneway qol ageg if cancer==1, tab
//p<0.05 show unequal variance so need to use nonparametric
kwallis qol if cancer==1, by(ageg)
//sig difference bw the age groups (p=.0001)
xi: svy: regress qol i.ageg if cancer==1 
testparm _I*
//made no sense, age is not associated w/QoL in regression, yet shows dif bw age groups
gen age2=ageg
label var age2 ">=65 vs <65"
recode age2 2=1 3=1 4=1 5=1 6=1 7=2 8=2 9=2
label define age2lab 1 "<65 years old" 2 ">=65"
label val age2 age2lab
tab age2 ageg if cancer==1 [iweight= wt_new]
xi: svy: mean qol if cancer==1, over (age2)
xi: svy: regress qol i.age2 if cancer==1 
testparm _I*


xi: svy: mean qol if cancer==1, over(sex)
sdtest qol if cancer==1, by(sex)
//weights not allowed
//p<.05 use unequal ttest
ttest qol if cancer==1, by(sex) unequal //weights not allowed
xi: svy: regress qol i.sex if cancer==1 
testparm _I*


xi: svy: mean qol if cancer==1, over(whiteornot)
sdtest qol if cancer==1, by(whiteornot)
//p<.05 use unequal ttest
ttest qol if cancer==1, by(whiteornot) unequal
xi: svy: regress qol i.whiteornot if cancer==1 
testparm _I*

gen job=q50
drop if job<0
label define joblab 1 "FT paid work >=30h/w" 2 "PT paid work <30h/w" 3 "FT education" 4 "unemployed" 5 "permanently sick/disabled" 6 "fully retired" 7 "looking after the home" 8 "doing something else"
label val job joblab
tab q50 job if cancer==1 [iw=wt_new]

xi: svy: mean qol if cancer==1, over(job)
oneway qol job if cancer==1, tab
kwallis qol if cancer==1, by(job)
xi: svy: regress qol i.job if cancer==1 
//only education not associated w/qol
testparm _I*
//but sig dif btw employment grp

xi: svy: mean qol if cancer==1, over(smoking)
oneway qol smoking if cancer==1, tab
kwallis qol if cancer==1, by(smoking)
xi: svy: regress qol i.smoking if cancer==1 
testparm _I*


xi: svy: mean qol if cancer==1, over(commute)
sdtest qol if cancer==1, by(commute)
//p>.05 use equal ttest
ttest qol if cancer==1, by(commute)
xi: svy: regress qol i.commute if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (alzheimer)
xi: svy: regress qol i.alzheimer if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (heart)
xi: svy: regress qol i.heart if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (arthritis)
xi: svy: regress qol i.arthritis if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (copd)
xi: svy: regress qol i.copd if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (blind)
xi: svy: regress qol i.blind if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (deaf)
xi: svy: regress qol i.deaf if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (diabetes)
xi: svy: regress qol i.diabetes if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (epi)
xi: svy: regress qol i.epi if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (hbp)
xi: svy: regress qol i.hbp if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (kidney)
xi: svy: regress qol i.kidney if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (back)
xi: svy: regress qol i.back if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (LD)
xi: svy: regress qol i.LD if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (MH)
xi: svy: regress qol i.MH if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (neurological)
xi: svy: regress qol i.neurological if cancer==1 
testparm _I* 

svy: mean qol if cancer==1, over (other)
xi: svy: regress qol i.other if cancer==1 
testparm _I* 

//xi: svy: regress qol i.alzheimer i.heart i.arthritis i.copd i.blind  i.deaf  i.diabetes  i.epi i.hbp i.kidney i.back i.LD i.MH  i.neurological i.other if cancer==1 
//testparm _I* 
//I don't thikn this is accurate for detecting dif in mean qol scores btween those groups using wald test --best to stick to individual regression ones

//svy: mean qol if cancer==1, over (ADL)
//xi: svy: regress qol i.ADL if cancer==1 
//testparm _I* 

//svy: mean qol if cancer==1, over (pain)
//xi: svy: regress qol i.pain if cancer==1 
//testparm _I* 

//gen anxious=q34e- do not use as it's EQ5D's subscale
/*
tab anxious
recode anxious 1=0 2=1 3=1 4=1 5=1
label define alab 0 "not anxious/depressed today" 1 "slightly/moderately/severely/extremeley"
label val anxious alab
tab q34e anxious if cancer==1 [iw=wt_new]*/

/*xi: svy: mean qol if cancer==1, over(anxious)
xi: svy: regress qol i.anxious if cancer==1 
testparm _I* */

xi: svy: mean qol if cancer==1, over(plan)
xi: svy: regress qol i.plan if cancer==1 
testparm _I*

xi: svy: mean qol if cancer==1, over(exp)
xi: svy: regress qol i.exp if cancer==1 
testparm _I*

xi: svy: mean qol if cancer==1, over(time)
xi: svy: regress qol i.time if cancer==1 
testparm _I*

xi: svy: mean qol if cancer==1, over(GPexp)
xi: svy: regress qol i.GPexp if cancer==1 
testparm _I*

//table 4.7 bivariate unadj analysis
gen dep2=depriv
label var dep2 "least vs most/mod deprived"
recode dep2 1=2 2=2 3=1
label define dep2lab 1 "least deprived" 2 "mod/most deprived"
label val dep2 dep2lab
tab dep2 depriv if cancer==1 [iweight= wt_new]

svy: regress qol dep2  if cancer==1
xi: svy: regress qol i.age2  if cancer==1
xi: svy: regress qol i.sex  if cancer==1
svy: regress qol whiteornot  if cancer==1

gen smoking2 =smoking
label var smoking2 "smoking history"
recode smoking2 1=1 2=1 3=2 4=2
label define sm2lab 1 "never/former" 2 "occasional/regular"
label val smoking2 sm2lab
tab smoking2 smoking if cancer==1 

svy: regress qol smoking2  if cancer==1
svy: regress qol numberofLTC  if cancer==1

svy: regress qol alzheimer  if cancer==1
svy: regress qol heart  if cancer==1
svy: regress qol arthritis  if cancer==1
svy: regress qol copd  if cancer==1
svy: regress qol blind  if cancer==1
svy: regress qol deaf if cancer==1 
svy: regress qol diabetes if cancer==1 
svy: regress qol epi if cancer==1 
svy: regress qol hbp if cancer==1 
svy: regress qol kidney if cancer==1 
svy: regress qol back if cancer==1 
svy: regress qol LD if cancer==1 
svy: regress qol MH if cancer==1 
svy: regress qol neurological if cancer==1 
svy: regress qol other if cancer==1 

//do not run as those are EQ5D subscales
/*svy: regress qol i.ADL if cancer==1 
svy: regress qol i.pain if cancer==1 
svy: regress qol i.anxious if cancer==1 */

drop if plan==3
tab plan if cancer==1 [iweight= wt_new]
svy: regress qol i.plan  if cancer==1

gen exp2 =exp
label var exp2 "overal exp making a GP appt"
recode exp2 1=1 2=1 3=2 4=2 5=2
label define exp2lab 1 "very/fairly good" 2 "neutral/fairly/very poor"
label val exp2 exp2lab
tab exp2 exp if cancer==1 
svy: regress qol i.exp2  if cancer==1

gen time2=time
drop if time2==6
label var time2 "Did GP give you enough time?"
recode time2 1=1 2=1 3=2 4=2 5=2
label define time2lab 1"very/fairly good" 2"neutral/poor/very poor" 
label val time2 time2lab
tab time2 time if cancer==1 
svy: regress qol i.time2  if cancer==1

gen GPexp2=GPexp
label var GPexp2 "Overall, how would you describe your experience of your GP practice"
recode GPexp2 1=1 2=1 3=2 4=2 5=2
label define GPexp2lab  1"very/fairly good" 2"neutral/poor/very poor"  
label val GPexp2 GPexp2lab
tab GPexp GPexp2 if cancer==1 [iweight= wt_new]
svy: regress qol i.GPexp2  if cancer==1

//do younger adults with 3 LTCs have worse QoL than older adults
xi: svy: regress qol numberofLTC i.age2 if cancer==1
testparm _I*

//strongest predictors

//reverse code 
//overal exp of making GP appt
recode exp2 1=1 2=0
label define exp2l 1 "very/fairly good" 0 "neutral/fairly/very poor"
label val exp2 exp2l
tab exp2 exp if cancer==1 
svy: regress qol i.exp2  if cancer==1

//Did GP give you enough time?"
recode time2 1=1 2=0
label define time2l 1"very/fairly good" 0"neutral/poor/very poor" 
label val time2 time2l
tab time2 time if cancer==1 
svy: regress qol i.time2  if cancer==1

//Overall, how would you describe your experience of your GP practice"
recode GPexp2 1=1 2=0
label define GPexp2l  1"very/fairly good" 0"neutral/poor/very poor"  
label val GPexp2 GPexp2l
tab GPexp GPexp2 if cancer==1 [iweight= wt_new]

//do not run with EQ5D subscales (ADL pain anxious)  xi: regress qol dep2 age2 sex whiteornot smoking2 numberofLTC alzheimer heart arthritis copd blind deaf diabetes epi hbp kidney back LD MH neurological other ADL pain anxious plan exp2 time2 GPexp2 if cancer==1, beta
xi: regress qol dep2 age2 sex whiteornot smoking2 numberofLTC alzheimer heart arthritis copd blind deaf diabetes epi hbp kidney back LD MH neurological other plan exp2 time2 GPexp2 if cancer==1 [iw=wt_new], beta
//why is Qol coefficient for # of LTC positive when it wasn't before weighting was applied?
//following resources suggest multicollinearity when Googled "Regression coefficients that flip sign after applying weighting"
//1. http://www.stat.columbia.edu/~gelman/stuff_for_blog/oh_no_I_got_the_wrong_sign.pdf 
//2. https://www.researchgate.net/post/Flip_sign_of_a_particular_variable_coefficient_while_using_different_regression_methods
//this is how to test multicollinearity https://www.youtube.com/watch?v=jo-es2s6Xpw multicollinearity
//numberofLTC is highly multicollinear (as expected) as it was generated off all the LTCs.
//to interpret, VIF must be >5 according to https://www.statisticshowto.datasciencecentral.com/variance-inflation-factor/
vif
//if you drop LTC, then there is no multicollinearity
xi: regress qol dep2 age2 sex whiteornot smoking2  alzheimer heart arthritis copd blind deaf diabetes epi hbp kidney back LD MH neurological other plan exp2 time2 GPexp2 if cancer==1 [iw=wt_new], beta
vif

//Another step from above youtube-found Number of LTCs and all LTCs are highly correlated with eahc other
vce, corr

//is the beta still the same when adjusting for age on quadratic
//do not run xi: regress qol dep2 i.ageg i.agesq sex whiteornot smoking2 numberofLTC alzheimer heart arthritis copd blind deaf diabetes epi hbp kidney back LD MH neurological other ADL pain anxious plan exp2 time2 GPexp2 if cancer==1, beta


//do cancer patients with HBP have better qol than those without hbp, after adjusting for all confounders?
/*xi: svy: regress qol dep2 age2 sex whiteornot smoking2 numberofLTC alzheimer heart arthritis copd blind deaf diabetes epi hbp kidney back LD MH neurological other plan exp2 time2 GPexp2 if cancer==1
//no difference, p>0.05

//with no adjustment hbp qol is still worse than those without hbp
xi: svy: regress qol i.hbp if cancer==1
testparm _I*
//sig difference bw groups in qol
*/

//QoL table for team
sum qol if cancer==1 [aw=wt_new], detail
bysort ageg: sum qol  if cancer==1 [aw=wt_new], detail
bysort sex: sum qol  if cancer==1 [aw=wt_new], detail
bysort depriv: sum qol  if cancer==1 [aw=wt_new], detail
bysort numberofLTC: sum qol  if cancer==1 [aw=wt_new], detail
//ltc 14 is outlier-22 out of 31 people selected 1
 tab qol if cancer==1 & numberofLTC==14 [iw=wt_new]
//stop when you drop some missing values/it affect the whole QoL, so redo table to before dropping
