use "\\GPPS\GPPS Y12 Person Dataset weighted raw data.dta", clear
desc

//convert string to numeric
destring, replace
desc

 
//assumption check-missing data and outliers
misstable sum 

//show % missing
sysdir set PLUS "\\GPPS\plus"

findit mdesc_ado

mdesc

tab q31_6 [iweight=wt_new], missing 

//recode cancer
gen cancer =q31_6
label var cancer  "cancer status"
label define canlab 0 "no cancer" 1 "has cancer"
label val cancer canlab
tab cancer [iweight= wt_new], missing

//exclude people w/o complete cancer info
keep if cancer>=0
drop if cancer==.

tab cancer [iweight=wt_new], missing
sum q31_1-q31_17

//recode deprivation
gen deprive = depriv
label var deprive "deprivation"
tab deprive
label define deprivelab 1 "most" 2 "moderately" 3 "least"
label val deprive deprivelab
tab deprive 
//cross tabulate to make sure it's coded correctly
tab deprive depriv

//create frequency table 4.1
//cancer x deprivation
bysort cancer: tab deprive [iweight= wt_new]
svyset [iweight=wt_new]
bysort cancer: tab deprive

//sig test
svy: tab cancer deprive

//recode age
tab q48_merged
gen age = q48_merged
label var age "age groups"
label define agelab -1 "unknown" 2 "16 to 24" 3 "25 to 34" 4 "35 to 44" 5 "45 to 54" 6 "55 to 64" 7 "65 to 74" 8 "75 to 84" 9 "85 or over"
label val age agelab
drop if age<0
tab age q48_merged

//cancer by age
bysort cancer: tab age [iweight= wt_new]

//sig test
svy: tab cancer age

//recode sex
tab q47
gen sex = q47
label var sex "sex"
label define sexlab -3 "missing" -1 "missing" 1 "male" 2 "female"
label val sex sexlab
tab sex q47
drop if sex<1
tab sex q47

//cancer by sex
bysort cancer: tab sex [iweight= wt_new]
//sig test
svy: tab cancer sex

//recode ethnicity
tab q49
gen ethnicity = q49
label var ethnicity "ethnicities"
label define ethlab -3 "missing" 1 "Brit" 2 "Irish" 3 "Gypsy/Irish Traveler" 4 "Other White" 5 "white/black carribbean" 6 "white/black african" 7 "white/asian" 8 "other multi-racial" 9 "indian" 10 "pakistani" 11 "bangladeshi" 12 "chinese" 13 "Other Asian" 14 "african" 15 "caribbean" 16 "other Black" 17 "Arab" 18 "other"
label val ethnicity ethlab
tab ethnicity q49
drop if ethnicity<0

//group ethnicity into white vs non-white
gen whiteornot=q49
label var whiteornot "White or non-white"
recode whiteornot -3=-3 1=1 2=1 3=1 4=1 5=2 6=2 7=2 8=2 9=2 10=2 11=2 12=2 13=2 14=2 15=2 16=2 17=2 18=2
label define wlab -3 "missing" 1 "white" 2 "non-white"
label val whiteornot wlab
tab whiteornot q49
drop if whiteornot <0
tab whiteornot

//cancer by ethnicity
bysort cancer: tab whiteornot [iweight= wt_new]
//sig test
svy: tab cancer whiteornot

//recode employment status
tab q50
gen employment =q50
label var employment "employment status"
label define emplab -3 "missing" -1 "missing" 1 "full time" 2 "part time" 3 "FT student" 4 "unemployed" 5 "sick/disabled permanently" 6 "fully retired" 7 "looking after family/home" 8 "other"
label val employment emplab
tab employment q50
drop if employment<0

//cancer by employment
bysort cancer: tab employment [iweight= wt_new]
//sig test
svy: tab cancer employment

//recode smoking status
gen smoking =q55
label var smoking "smoking history"
label define smlab -3 "missing" -1 "missing" 1 "never" 2 "former" 3 "occasional" 4 "regular"
label val smoking smlab
drop if smoking<0
tab smoking q55

//cancer by smoking
bysort cancer: tab smoking [iweight= wt_new]
//sig test
svy: tab cancer smoking

//recode alzheimer
tab q31_1
gen alzheimer =q31_1
label var alzheimer  "Alzheimer/dementia"
label define alzlab 0 "no alz/dementia" 1 "has alz/dementia"
label val alzheimer alzlab
tab alzheimer

//recode arthritis
tab q31_3
gen arthritis =q31_3
label var arthritis  "Arthritis/joint/back problem"
label define artlab 0 "no arthritis/joint/back problem" 1 "has arthritis/joint/back problem"
label val arthritis artlab
tab arthritis

//recode blindness
tab q31_5
gen blind =q31_5
label var blind  "blindness/partial sight"
label define blindlab 0 "no blind/partial sight" 1 "has blind/partial sight"
label val blind blindlab
tab blind

//recode copd
tab q31_4
gen copd =q31_4
label var copd  "breathing problem: asthma/copd"
label define copdlab 0 "no breathing condition" 1 "has asthma/copd"
label val copd copdlab
tab copd


//recode deaf
tab q31_7
gen deaf =q31_7
label var deaf  "deaf/hearing loss"
label define deaflab 0 "no" 1 "yes"
label val deaf deaflab
tab deaf

//recode autism
tab q31_18
gen autism =q31_18
label var autism  "developmental disability: autism/ADHD"
label define autlab 0 "no" 1 "yes"
label val autism autlab
tab autism

//recode diabetes
tab q31_8
gen diabetes =q31_8
label var diabetes  "diabetes"
label define dlab 0 "no" 1 "yes"
label val diabetes dlab
tab diabetes

//recode heart
tab q31_2
gen heart =q31_2
label var heart  "heart condition: angina/atrial fibrillation"
label define heartlab 0 "no" 1 "yes"
label val heart heartlab
tab heart

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

//recode learning disabilty
tab q31_19
gen LD =q31_19
label var LD  "learning disability"
label define ldlab 0 "no" 1 "yes"
label val LD ldlab
tab LD

//recode mnental health condition
tab q31_14
gen MH =q31_14
label var MH  "mental health condition"
label define mlab 0 "no" 1 "yes"
label val MH mlab
tab MH


//recode epilepsy
tab q31_15
gen epi =q31_15
label var epi  "epilepsy"
label define elab 0 "no" 1 "yes"
label val epi elab
tab epi


//recode stroke
tab q31_20
gen stroke =q31_20
label var stroke  "stroke (which affects your daily life)"
label define slab 0 "no" 1 "yes"
label val stroke slab
tab stroke


//recode other
tab q31_16
gen other =q31_16
label var other  "other LTC/disability"
label define olab 0 "no" 1 "yes"
label val other olab
tab other


//recode no LTC
tab q31_17
gen noLTC =q31_17
label var noLTC  "I do not have any long term conditions"
label define nlab 0 "no" 1 "yes"
label val noLTC nlab
tab noLTC

//What proportion of vulnerable cancer patients have dementia/Alzheimer, learning disability, autism, split by age
bysort cancer: tab1 alzheimer arthritis blind copd deaf autism diabetes heart hbp kidney LD MH epi stroke other noLTC [iweight= wt_new]
//sig test by age
bysort alzheimer: tab age if cancer==1 [iweight= wt_new]
bysort autism: tab age if cancer==1 [iweight= wt_new]
bysort LD: tab age if cancer==1 [iweight= wt_new]

//chi sq test by ltc
svy: tab cancer alzheimer
svy: tab cancer arthritis
svy: tab cancer blind
svy: tab cancer copd
svy: tab cancer deaf
svy: tab cancer autism
svy: tab cancer diabetes
svy: tab cancer heart
svy: tab cancer hbp
svy: tab cancer kidney
svy: tab cancer LD
svy: tab cancer MH
svy: tab cancer epi
svy: tab cancer stroke
svy: tab cancer other
svy: tab cancer noLTC

//work out prevalence with multimorbidity-16 total including cancer
gen numberofLTC = alzheimer + arthritis + blind + cancer+ copd+ deaf+ autism+ diabetes +heart +hbp +kidney+ LD+ MH+ epi+ stroke+ other
tab numberofLTC
//check if 0 number of LTC matches noLTC
tab noLTC
//number of LTC by cancer status
bysort cancer: tab numberofLTC
//sig test
svy: mean numberofLTC, over(cancer)

//svy doesn't work with ttest, needs to use regress per https://stats.idre.ucla.edu/stata/faq/how-can-i-do-a-t-test-with-survey-data/
svy: regress numberofLTC cancer
//The coefficient for cancer is the t-test. 

//recode if LTC affects ADL
tab q93
gen ADL =q93
label var ADL  "Do any of these conditions reduce your ability to carry out your day-to-day activities?"
label define ADLlab 1 "yes a lot" 2 "yes a little" 3 "not at all"
label val ADL ADLlab
tab ADL [iweight= wt_new]
drop if ADL<0
//does LTC affect ADL by cancer status?
bysort cancer: tab ADL [iweight= wt_new]
//sig test
svy: tab cancer ADL

//any recent hospitalization due to LTC by cancer status?
tab q95
gen hosp=q95
label var hosp "In the last 12 months have you had any unexpected stays in hospital because of LTC?"
recode hosp 1=1 2=0
label define hospilab 1 "yes" 0 "no"
label val hosp hospilab
drop if hosp<0
bysort cancer: tab hosp [iweight= wt_new]
//sig test
svy: tab cancer hosp

//given written LTC management plan by cancer status?
tab q99
gen plan=q99
label var plan "given a chronic condition management plan from GP practice"
label define planlab 1 "yes" 2 "no" 3 "don't know"
label val plan planlab
drop if plan<0
bysort cancer: tab plan [iweight=wt_new] 
//sig test
svy: tab cancer plan


//making an appointment-not offered a choice of appointment by cancer
gen noappt =q79_4
tab q79_4
label var noappt "not offered an appointment when making an appt"
label define noapptlab 0 "false" 1"true"
label val noappt noapptlab
drop if noappt<0
bysort cancer: tab noappt [iweight=wt_new]
//sig test
svy: tab cancer noappt

//Q82_3: What did you do when you did not take the appointment you were offered?…Went to A&E
tab q82_3
gen er=q82_3
label var er "went to A&E when I didn't take the offered appt"
label define erlab 0 "no" 1"yes"
label val er erlab
drop if er<0
bysort cancer: tab er [iweight=wt_new]
tab er [iweight=wt_new]
//sig test
svy: tab cancer er

//Q82_3 (went to A&E when they didn't take offered appt) + Q80 (were not satisfied w/appt offered & didn't take appt)
tab q80
gen noPreferredAppt = q80
label var noPreferredAppt "were not satisfied w/appt offered & didn't take appt"
label define nolab 1 "Yes, and I accepted an appointment" 2 "No, but I still took an appointment" 3 "No, and I didn't take an appt"
label val noPreferredAppt nolab
drop if noPreferredAppt<0

//•	Q18: Overall, how would you describe your experience of making an appointment?
tab q18
gen exp=q18
label var exp "Overall experience of making an appointment"
label define explab 1"very good" 2"fairly good" 3"neutral" 4 "fairly poor" 5"very poor"
label val exp explab
drop if exp<0
bysort cancer: tab exp [iweight=wt_new]
//sig test
svy: tab cancer exp


//•	Q21a: Last time you had a general practice appointment, how good was the healthcare professional at: Giving you enough time – GP
tab q21a
gen time=q21a
label var time "Did GP give you enough time?"
label define timelab 1"very good" 2"good" 3"neutral" 4 "poor" 5"very poor" 6"Not Applicable"
label val time timelab
drop if time<0
bysort cancer: tab time [iweight=wt_new]
//sig test
svy: tab cancer time

//•	Q90: Thinking about the reason for your last general practice appointment, were your needs met?
tab q90
gen need=q90
label var need "were your needs met at your last GP appt?"
label define needlab 1"yes, def" 2"yes, to some extent" 3 "no" 4"don't know"
label val need needlab
drop if need<0
bysort cancer: tab need [iweight=wt_new]
//sig test
svy: tab cancer need

//•	Q28: Overall, how would you describe your experience of your GP practice?
tab q28
gen GPexp=q28
label var GPexp "Overall, how would you describe your experience of your GP practice"
label define GPexplab  1"very good" 2"good" 3"neutral" 4 "poor" 5"very poor" 
label val GPexp GPexplab
drop if q28<0
bysort cancer: tab GPexp [iweight=wt_new]
//sig test
svy: tab cancer GPexp
xi: svy: logistic cancer i.GPexp


//•	Q67_4: Considering all of the services you contacted, which of the following happened on that occasion?…I went to A&E
tab q67_4
gen ERclose=q67_4
label var ERclose "Went to A&E when GP is closed"
label define ERcloselab  0 "no" 1"yes" 
label val ERclose ERcloselab
drop if q67_4<0
bysort cancer: tab ERclose [iweight=wt_new]
tab ERclose [iweight=wt_new]
//sig test
svy: tab cancer ERclose
svy: logistic cancer ERclose

//Q82_9 did not see/speak to anyone when I did not take the offered appt
tab q82_9 [iw=wt_new]
tab q82_9 if cancer==1 [iw=wt_new]

//Table 4.2 Deprivation

bysort deprive: tab age if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive age if cancer==1

//for cancer patients only-deprivation x sex
bysort deprive: tab sex if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive sex if cancer==1

//for cancer patients only-deprivation x eth
bysort deprive: tab whiteornot if cancer==1 [iw=wt_new]
bysort ethnicity: tab deprive if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive whiteornot if cancer==1
svy: tab deprive ethnicity if cancer==1

//for cancer patients only-deprivation x employment
bysort employment: tab deprive if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive employment if cancer==1

//for cancer patients only-deprivation x smoking
bysort deprive: tab smoking if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive smoking if cancer==1

//cancer deprivation x LTC
bysort deprive: tab1 alzheimer arthritis blind copd deaf autism diabetes heart hbp kidney LD MH epi stroke other noLTC if cancer==1 [iweight= wt_new]

//chi sq test by ltc
svy: tab deprive alzheimer if cancer==1
svy: tab deprive arthritis if cancer==1
svy: tab deprive blind if cancer==1
svy: tab deprive  copd if cancer==1
svy: tab deprive  deaf if cancer==1
svy: tab deprive  autism if cancer==1
svy: tab deprive  diabetes if cancer==1
svy: tab deprive  heart if cancer==1
svy: tab deprive  hbp if cancer==1
svy: tab deprive  kidney if cancer==1
svy: tab deprive  LD if cancer==1
svy: tab deprive  MH if cancer==1
svy: tab deprive  epi if cancer==1
svy: tab deprive  stroke if cancer==1
svy: tab deprive  other if cancer==1
//svy: tab deprive cancer noLTC

svy: mean numberofLTC if cancer==1, over(deprive)
//sig test
xi: regress numberofLTC i.deprive if cancer==1 [iw=wt_new]

//for cancer patients only-deprivation x ADL
bysort deprive: tab ADL if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive ADL if cancer==1 

//for cancer patients only-deprivation x unexpected hospital stays
bysort deprive: tab hosp if cancer==1 [iw=wt_new]
svy: tab deprive hosp if cancer==1 


//for cancer patients only-deprivation x mgmt plan
bysort deprive: tab plan if cancer==1 [iw=wt_new]
svy: tab deprive plan if cancer==1 

//for cancer patients only-deprivation x no appt
bysort deprive: tab noappt if cancer==1 [iw=wt_new]
svy: tab deprive noappt if cancer==1 

//for cancer patients only-deprivation x went to AE when did not take appt
bysort deprive: tab er  if cancer==1 [iw=wt_new]
svy: tab deprive er if cancer==1 

//for cancer patients only-deprivation x appointment making experience
bysort deprive: tab exp if cancer==1 [iw=wt_new]
svy: tab deprive exp if cancer==1 


//for cancer patients only-deprivation x GP giving enough time
bysort deprive: tab time if cancer==1 [iw=wt_new]
svy: tab deprive time if cancer==1


//for cancer patients only-deprivation x needs met at GP appt
svy: tab deprive need if cancer==1

bysort deprive: tab need if cancer==1 [iw=wt_new]

//for cancer patients only-deprivation x overall experience of GP pracitce
bysort deprive: tab GPexp if cancer==1 [iw=wt_new]
svy: tab deprive GPexp if cancer==1


//for cancer patients only-deprivation x went to A&E when Gp closed
bysort deprive: tab ERclose if cancer==1 [iw=wt_new]
svy: tab deprive ERclose if cancer==1

//table 4.2 Age 
//group age into binary variable
tab age if cancer==1 [iweight= wt_new]

gen age2=age
label var age2 ">=65 vs <65"
recode age2 2=1 3=1 4=1 5=1 6=1 7=2 8=2 9=2
label define age2lab 1 "<65 years old" 2 ">=65"
label val age2 age2lab
tab age2 age if cancer==1 [iweight= wt_new]


bysort age2: tab deprive if cancer==1 [iw=wt_new]
//sig test
svy: tab age2 deprive if cancer==1

//for cancer patients only-age x sex
bysort age2: tab sex if cancer==1 [iw=wt_new]
//sig test
svy: tab age2 sex if cancer==1


//for cancer patients only-age x ethn
bysort age2: tab whiteornot if cancer==1 [iw=wt_new]
svy: tab age2 whiteornot if cancer==1

//for cancer patients only-age x smoking
bysort age2: tab smoking if cancer==1 [iw=wt_new]
svy: tab age2 smoking if cancer==1

bysort age2: tab1 alzheimer arthritis blind copd deaf autism diabetes heart hbp kidney LD MH epi stroke other noLTC if cancer==1 [iweight= wt_new]

//chi sq test by ltc
svy: tab age2 alzheimer if cancer==1
svy: tab age2 arthritis if cancer==1
svy: tab age2 blind if cancer==1
svy: tab age2  copd if cancer==1
svy: tab age2  deaf if cancer==1
svy: tab age2  autism if cancer==1
svy: tab age2  diabetes if cancer==1
svy: tab age2  heart if cancer==1
svy: tab age2  hbp if cancer==1
svy: tab age2  kidney if cancer==1
svy: tab age2  LD if cancer==1
svy: tab age2  MH if cancer==1
svy: tab age2  epi if cancer==1
svy: tab age2  stroke if cancer==1
svy: tab age2  other if cancer==1

//can't do scatter or histogram with svy or iweight
svy: mean numberofLTC if cancer==1, over(age2)
//shows mean numberofLTC by age 
svy: regress numberofLTC age2 if cancer==1 


//for cancer patients only-age x ADL
bysort age2: tab ADL if cancer==1 [iw=wt_new]
svy: tab age2 ADL if cancer==1 


//for cancer patients only-age x unexpected hospital stays
bysort age2: tab hosp if cancer==1 [iw=wt_new]
svy: tab age2 hosp if cancer==1 


//for cancer patients only-age x mgmt plan
bysort age2: tab plan if cancer==1 [iw=wt_new]
svy: tab age2 plan if cancer==1 

//for cancer patients only-age x appointment making experience
bysort age2: tab exp if cancer==1 [iw=wt_new]
svy: tab age2 exp if cancer==1

//for cancer patients only-age x GP giving enough time
bysort age2: tab time if cancer==1 [iw=wt_new]
svy: tab age2 time if cancer==1


//for cancer patients only-age x needs met at GP appt
bysort age2: tab need if cancer==1 [iw=wt_new]
svy: tab age2 need if cancer==1


//for cancer patients only-age x overall experience of GP pracitce
bysort GPexp: tab age if cancer==1 [iw=wt_new]
svy: tab age GPexp if cancer==1

//for cancer patients only-age x went to A&E when Gp closed
bysort ERclose: tab age if cancer==1 [iw=wt_new]
svy: tab age ERclose if cancer==1

//table 4.3 age adj OR

//can age and deprive be binary?
xi: svy: regress numberofLTC i.deprive*i.age if cancer==1
//age*depr no interaction, so yes!
//group deprive into binary variable
tab deprive if cancer==1 [iweight= wt_new]
gen dep2=deprive
label var dep2 "least vs most/mod deprived"
recode dep2 1=2 2=2 3=1
label define dep2lab 1 "least deprived" 2 "mod/most deprived"
label val dep2 dep2lab
tab dep2 deprive if cancer==1 [iweight= wt_new]

//LTC
svy: regress numberofLTC dep2 if cancer==1
svy: regress numberofLTC dep2 age2 if cancer==1

//group exp into binary variable
tab exp if cancer==1 [iweight= wt_new]

gen exp2=exp
label var exp2 "very/fairly good vs neutral/fairly/very poor"
recode exp2 1=0 2=0 3=1 4=1 5=1
label define ex2lab 0 "very/fairly good" 1 "neutral/fairly/very poor"
label val exp2 ex2lab
tab exp2 exp if cancer==1 [iweight= wt_new]

svy: logistic exp2 dep2 if cancer==1
svy: logistic exp2 dep2 age2 if cancer==1


//group time into binary

tab time if cancer==1 [iweight= wt_new]
gen time2=time
label var time2 "very/fairly good vs neutral/fairly/very poor"
recode time2 1=0 2=0 3=1 4=1 5=1 6=6
label define time2lab 0 "very/fairly good" 1 "neutral/fairly/very poor"
label val time2 time2lab
drop if time2==6
tab time2 time if cancer==1 [iweight= wt_new]

svy: logistic time2 dep2 if cancer==1
svy: logistic time2 dep2 age2 if cancer==1


//group needs into binary
tab need if cancer==1 [iweight= wt_new]
gen need2=need
label var need2 "yes def/some extent vs no"
recode need2 1=0 2=0 3=1 4=4 
label define n2lab 0 "yes def/some extent" 1 "no"
label val need2 n2lab
drop if need2==4
tab need2 need if cancer==1 [iweight= wt_new]

svy: logistic need2 dep2 if cancer==1
svy: logistic need2 dep2 age2 if cancer==1


//group gpexp into binary
tab GPexp if cancer==1 [iweight= wt_new]
gen GPexp2=GPexp
label var GPexp2 "very/fairly good vs neutral/fairly/very poor"
recode GPexp2 1=0 2=0 3=1 4=1 5=1 
label define G2lab 0 "very/fairly good" 1 "neutral/fairly/very poor"
label val GPexp2 G2lab
tab GPexp2 GPexp if cancer==1 [iweight= wt_new]
svy: logistic GPexp2 dep2 if cancer==1
svy: logistic GPexp2 dep2 age2 if cancer==1


svy: logistic ERclose dep2 if cancer==1
svy: logistic ERclose dep2 age2 if cancer==1

//reverse code deprive
gen deprive2=deprive
recode deprive2 1=3 2=2 3=1
label define d2lab 1 "least" 2"moderate" 3"most"
label val deprive2 d2lab
tab deprive2 deprive if cancer==1 [iw=wt_new]

xi: svy: logistic ERclose i.deprive2 if cancer==1
xi: svy: logistic ERclose i.deprive2 age2 if cancer==1

//table 4.3 LTC
//gen non-cancerous ltc based on 15 LTCs that are not cancer
gen ncLTC=alzheimer + arthritis + blind + copd+ deaf+ autism+ diabetes +heart +hbp +kidney+ LD+ MH+ epi+ stroke+ other
label var ncLTC "number of non-cancerous LTCs"
tab ncLTC if cancer==1 [iweight= wt_new]
tab1 ncLTC q31_1-q31_17 if cancer==1 [iw=wt_new]

svy: logistic noappt dep2 ncLTC if cancer==1
svy: logistic er dep2 ncLTC if cancer==1
svy: logistic exp2 dep2 ncLTC if cancer==1
svy: logistic time2 dep2 ncLTC if cancer==1
svy: logistic need2 dep2 ncLTC if cancer==1
svy: logistic GPexp2 dep2 ncLTC if cancer==1
svy: logistic ERclose dep2 ncLTC if cancer==1
xi: svy: logistic ERclose i.deprive2 ncLTC if cancer==1



//table 4.3 Covariates
svy: regress numberofLTC dep2 age2 sex MH whiteornot if cancer==1
svy: logistic noappt dep2 age2 sex MH ncLTC whiteornot if cancer==1
svy: logistic er dep2 age2 sex MH ncLTC whiteornot if cancer==1
svy: logistic exp2 dep2 age2 sex MH ncLTC whiteornot if cancer==1
svy: logistic time2 dep2 age2 sex MH ncLTC whiteornot if cancer==1
svy: logistic need2 dep2 age2 sex MH ncLTC whiteornot if cancer==1
svy: logistic GPexp2 dep2 age2 sex MH ncLTC whiteornot if cancer==1
svy: logistic ERclose dep2 age2 sex MH ncLTC whiteornot if cancer==1
xi: svy: logistic ERclose i.deprive2 age2 sex MH ncLTC whiteornot if cancer==1

//table 4.4 strongest predictors
logistic exp2 dep2 age2 sex MH whiteornot ncLTC  if cancer==1 [iw=wt_new]
 logit exp2 dep2 age2 sex MH whiteornot ncLTC  if cancer==1 [iw=wt_new], nolog
xi: regress numberofLTC  dep2 age2 sex MH whiteornot if cancer==1 [iw=wt_new], beta
xi: regress numberofLTC  dep2 age2 sex MH whiteornot hosp exp2 time2 need2 GPexp2 noappt er ERclose if cancer==1 [iw=wt_new], beta

//table 4.4a most common comorbidities for most deprived cancer patients
//create frequency table
tab1 alzheimer arthritis blind copd deaf autism diabetes heart hbp kidney LD MH epi stroke other noLTC if cancer==1 & deprive==1 [iweight= wt_new]

//3.4.1.3.2	What is their average number of long-term conditions, including cancer?
svy: mean numberofLTC if cancer==1 & deprive==1

//3.4.1.3.3	What is the proportion of those with more than two long-term conditions?
//Frequency table of number of LTCs was created for the most deprived cancer patients. 
tab numberofLTC if cancer==1 & deprive==1 [iweight= wt_new]
tab ncLTC if cancer==1 & deprive==1 [iweight= wt_new]

//3.4.1.3.4	What are the most common conditions for those with more than two long-term conditions (LTCs
//Frequency table of all the LTCs was created for the most deprived cancer patients with more than two LTCs.
tab1 alzheimer arthritis blind copd deaf autism diabetes heart hbp kidney LD MH epi stroke other noLTC if cancer==1 & deprive==1 & ncLTC>2 [iweight= wt_new]

//for health inequality report: 
//do more deprived still have more unexpected hospital stays after adjusting for GPs time and accessing GP appointment, age, sex, ethnicity, and LTCs
svy: logistic hosp dep2 age2 sex MH ncLTC whiteornot exp2 time2 if cancer==1
