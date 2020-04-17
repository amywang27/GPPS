//using raw data or
use "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\GPPS Y12 Person Dataset weighted raw data.dta", clear
//using revised data for faster processing (but some variables i need are inadvertently dropped)
use "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\GPPS Y12 Person Dataset weighted revised data.dta", clear
desc

//convert string to numeric
destring, replace
desc

 
//assumption check-missing data and outliers
misstable sum 
//18821 missing cancer info. No outliers.

//show % missing
sysdir set PLUS "\\tsclient\G\NHS CB\Analytical Services (Outcomes Analysis Team)\Domain 1\Cancer\10. SCISP\GPPS\plus"

findit mdesc_ado

mdesc
/*2.5% missing cancer info Try looking at cancer population
*/

tab q31_6 [iweight=wt_new], missing 
//19,232 (2.54%) out of 758,165 patients missing cancer info

//recode cancer
gen cancer =q31_6
label var cancer  "cancer status"
label define canlab 0 "no cancer" 1 "has cancer"
label val cancer canlab
tab cancer [iweight= wt_new], missing
//84,007 (11.08%) missing or answered in error

//exclude people w/o complete cancer info
keep if cancer>=0
drop if cancer==.

tab cancer [iweight=wt_new], missing
//674,157 with complete cancer information. 21,287 (3%) with cancer and 652,870 (96%) without cancer.

//there are no missing data in LTC after dropping missing cancer info in q31_6
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
//there is sig dif
/*no longer need association 
xi: logistic cancer i.deprive [iw=wt_new]
//less deprived are 1.24-1.37 times more likely to have cancer
xi: svy: logistic cancer i.deprive 
//shows same result
*/

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
//there is sig dif
//xi: logistic cancer i.age [iw=wt_new]
//xi: svy: logistic cancer i.age 

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
//svy: logistic cancer sex

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
//xi: svy: logistic cancer i.ethnicity
//xi: logistic cancer i.ethnicity [iw=wt_new]
//same OR results

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
//xi: svy: logistic cancer i.employment

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
//xi: svy: logistic cancer i.smoking

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

//svy: logistic cancer alzheimer arthritis blind copd deaf autism diabetes heart hbp kidney LD MH epi stroke other noLTC

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
//xi: svy: logistic cancer i.ADL

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
//svy: logistic cancer hosp

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
//xi: svy: logistic cancer i.plan


//making an appointment-not offered a choice of appointment by cancer
//tab ïq79_4
//if using revised data
//gen noappt =ïq79_4
//for raw data
gen noappt =q79_4
tab q79_4
label var noappt "not offered an appointment when making an appt"
label define noapptlab 0 "false" 1"true"
label val noappt noapptlab
drop if noappt<0
bysort cancer: tab noappt [iweight=wt_new]
//sig test
svy: tab cancer noappt
//svy: logistic cancer noappt

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
//svy: logistic cancer er

//Q82_3 (went to A&E when they didn't take offered appt) + Q80 (were not satisfied w/appt offered & didn't take appt)
tab q80
gen noPreferredAppt = q80
label var noPreferredAppt "were not satisfied w/appt offered & didn't take appt"
label define nolab 1 "Yes, and I accepted an appointment" 2 "No, but I still took an appointment" 3 "No, and I didn't take an appt"
label val noPreferredAppt nolab
drop if noPreferredAppt<0
//didn't work bysort cancer: tab noPreferredAppt==3 & er==1 [iweight=wt_new]





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
//xi: svy: logistic cancer i.exp


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
//xi: svy: logistic cancer i.time

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
//xi: svy: logistic cancer i.need

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

//for cancer patients only-deprivation x age
//tab deprive age if cancer==1 [iweight=wt_new],r
//looks like most fall in 65-74, for all
//bysort age: tab deprive if cancer==1 [iw=wt_new]
//older least deprived, younger most deprived
//there is sig difference bw age and deprivation
bysort deprive: tab age if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive age if cancer==1
//same as this svy: tab age  deprive if cancer==1

//xi: ologit deprive i.age [iw=wt_new] if cancer==1, or
//xi: mlogit deprive i.age [iw=wt_new] if cancer==1, rrr
//same result but should use mlogit as you can't do brant test, it reads older you are, more likely you're least deprived
//recode deprivation to interpret it easier
/*gen deprived = deprive
label var deprived "Deprivation"
label define deprivedlab  0 "least" 1"moderately" 2"most" 
label val deprived deprivedlab
recode deprived 3=0 2=1 1=2
tab deprived deprive

xi: ologit deprived i.age if cancer==1 [iw=wt_new],or
xi: mlogit deprived i.age if cancer==1 [iw=wt_new],rrr
//results same, older are less likely to be most deprived but p value results slightly differ from below
xi: svy, rrr: mlogit deprived i.age if cancer==1
xi: svy, or: ologit deprived i.age if cancer==1
//same results
*/
//if I ungroup age, results are the same and read older less likely deprived
//mlogit deprived age if cancer==1 [iw=wt_new],rrr
//svy, rrr: mlogit deprived age if cancer==1

//pick any code above for other vars

//for cancer patients only-deprivation x sex
//tab  sex deprive if cancer==1 [iweight=wt_new], r
bysort deprive: tab sex if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive sex if cancer==1
//n.s

//for cancer patients only-deprivation x eth
//tab deprive ethnicity if cancer==1 [iw=wt_new],r
bysort deprive: tab whiteornot if cancer==1 [iw=wt_new]
bysort ethnicity: tab deprive if cancer==1 [iw=wt_new]
/*British, Chinese, Arab and Eurasian least deprived. Afro, Caribbean, Bangladeshi, Pakistani, White/African, Gypsy/Irish traveler most deprived
Very few obs on minority so cannot generalize to minority. 
Won't separate race into diff ethnicity due to too few obs*/
//sig test
svy: tab deprive whiteornot if cancer==1
svy: tab deprive ethnicity if cancer==1
//there is sig difference bw eth and deprivation

//don't need to do regression modeling 
//xi: svy, rrr: mlogit deprived i.ethnicity if cancer==1
//most deprived compared to British are (p<0.05):Irish, *esp Gypsy,any white, White/Black African, Indian, Pakistani, Bangladeshi, AnyAsian, Afri, Carib ,other Ethnic

//for cancer patients only-deprivation x employment
bysort employment: tab deprive if cancer==1 [iw=wt_new]
//unemployed, sick/disabled, most deprived
//sig test
svy: tab deprive employment if cancer==1
//p<0.05

//this is also confirmed by regression modeling
//xi: svy, rrr: mlogit deprived i.employment if cancer==1

//for cancer patients only-deprivation x smoking
//bysort smoking: tab deprive if cancer==1 [iw=wt_new]
//most deprived tend to be regular, occasional smoker. Least most likely to have never smoked.
bysort deprive: tab smoking if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive smoking if cancer==1
//p<0.05
//svy: tab  smoking deprive if cancer==1
//p<0.05
//chi sq is ok to use for more than 2 categories: https://www.researchgate.net/post/How_to_calculate_chi_square_test_for_more_than_2_by_2_consistency_table_in_SPSS


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

//for cancer patients only-deprivation x number of LTC
//bysort numberofLTC: tab deprive if cancer==1 [iw=wt_new]
//least deprived have less LTC than those more deprived
//sig test
//svy: tab deprive numberofLTC if cancer==1 
//p<0.05
svy: mean numberofLTC if cancer==1, over(deprive)
//bysort deprive: tab numberofLTC if cancer==1 [iw=wt_new]
//sig test
//deprive is not binary svy: regress numberofLTC deprive if cancer==1 so use anova via regress https://www.stata.com/statalist/archive/2010-03/msg00684.html
xi: regress numberofLTC i.deprive if cancer==1 [iw=wt_new]
//svy: tab numberofLTC deprive if cancer==1

//for cancer patients only-deprivation x ADL
//bysort ADL: tab deprive if cancer==1 [iw=wt_new]
//Least deprived most likely not to have any reductions in carrying out ADL, whereas most deprived's LTC reduce their ability to carry out their ADL the most. 
bysort deprive: tab ADL if cancer==1 [iw=wt_new]
//sig test
svy: tab deprive ADL if cancer==1 
//p<0.05
//svy: tab ADL deprive if cancer==1 

//for cancer patients only-deprivation x unexpected hospital stays
bysort deprive: tab hosp if cancer==1 [iw=wt_new]
//greater proportion of most deprived patients had unexpected hospital stays
svy: tab deprive hosp if cancer==1 
//p<0.05


//for cancer patients only-deprivation x mgmt plan
bysort deprive: tab plan if cancer==1 [iw=wt_new]
svy: tab deprive plan if cancer==1 
//ns

//for cancer patients only-deprivation x no appt
bysort deprive: tab noappt if cancer==1 [iw=wt_new]
svy: tab deprive noappt if cancer==1 
//ns

//for cancer patients only-deprivation x went to AE when did not take appt
bysort deprive: tab er  if cancer==1 [iw=wt_new]
svy: tab deprive er if cancer==1 
//ns

//for cancer patients only-deprivation x appointment making experience
//bysort exp: tab deprive if cancer==1 [iw=wt_new]
bysort deprive: tab exp if cancer==1 [iw=wt_new]
svy: tab deprive exp if cancer==1 
//p<0.05, most deprived had very poor exp whereas least deprived had very good experience

//for cancer patients only-deprivation x GP giving enough time
//bysort time: tab deprive if cancer==1 [iw=wt_new]
bysort deprive: tab time if cancer==1 [iw=wt_new]
//svy: tab time deprive if cancer==1 
svy: tab deprive time if cancer==1
//p<0.05, most deprived had very poor whereas least deprived had very good


//for cancer patients only-deprivation x needs met at GP appt
//bysort need: tab deprive if cancer==1 [iw=wt_new]
svy: tab deprive need if cancer==1
//p<0.05, most deprived no whereas least deprived def yes
bysort deprive: tab need if cancer==1 [iw=wt_new]
//svy: tab need deprive if cancer==1 

//for cancer patients only-deprivation x overall experience of GP pracitce
//bysort GPexp: tab deprive if cancer==1 [iw=wt_new]
//svy: tab GPexp deprive if cancer==1 
//p<0.05, most and least deprived very poor whereas least deprived very good
//xi: svy, rrr: mlogit deprived i.GPexp if cancer==1
//xi: mlogit deprived i.GPexp if cancer==1 [iw=wt_new], rrr
//shows most deprived have poorer exp for both
bysort deprive: tab GPexp if cancer==1 [iw=wt_new]
svy: tab deprive GPexp if cancer==1


//for cancer patients only-deprivation x went to A&E when Gp closed
bysort deprive: tab ERclose if cancer==1 [iw=wt_new]
svy: tab deprive ERclose if cancer==1
//ns

//table 4.2 Age 
//group age into binary variable
tab age if cancer==1 [iweight= wt_new]
//44.79% for <65, 55.22% >=65
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
//bysort sex: tab age if cancer==1 [iw=wt_new]
//svy: tab age sex if cancer==1
//sig dif, with men mostly in 65 to 74 age group and women in 55 to 74
bysort age2: tab sex if cancer==1 [iw=wt_new]
//sig test
svy: tab age2 sex if cancer==1


//for cancer patients only-age x ethn
//bysort ethnicity: tab age if cancer==1 [iw=wt_new]
//svy: tab age ethnicity if cancer==1
//sig dif, with Brits/irish mostly in 65 to 74 age group, and other ethnic groups mostly in younger age groups
bysort age2: tab whiteornot if cancer==1 [iw=wt_new]
//white mostly 65 to 74 age group, non-white mostly below 65
svy: tab age2 whiteornot if cancer==1


//for cancer patients only-age x employment
//bysort age2: tab employment if cancer==1 [iw=wt_new]
//svy: tab age employment if cancer==1
//sig dif, retired older age group and other categories in younger age group

//for cancer patients only-age x smoking
//bysort smoking: tab age if cancer==1 [iw=wt_new]
bysort age2: tab smoking if cancer==1 [iw=wt_new]
svy: tab age2 smoking if cancer==1
//sig dif, non-smokers (former) older age group than smokers 

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

//for cancer patients only-age x number of LTC
//bysort numberofLTC: tab age if cancer==1 [iw=wt_new]
//svy: tab age numberofLTC if cancer==1 
//p<0.05 with greater number of LTC with increasing age
//can't do scatter or histogram with svy or iweight
svy: mean numberofLTC if cancer==1, over(age2)
//shows mean numberofLTC by age 
svy: regress numberofLTC age2 if cancer==1 
//differences ns for age groups 25 to 34 and 35 to 44 compared to age 16-24


//for cancer patients only-age x ADL
bysort age2: tab ADL if cancer==1 [iw=wt_new]
svy: tab age2 ADL if cancer==1 
//p<0.05 Older age group's LTC reduce their ability to carry out their ADL. 

//for cancer patients only-age x unexpected hospital stays
//bysort hosp: tab age if cancer==1 [iw=wt_new]
bysort age2: tab hosp if cancer==1 [iw=wt_new]
svy: tab age2 hosp if cancer==1 
//p<0.05//greater proportion of older patients had unexpected hospital stays

//for cancer patients only-age x mgmt plan
bysort age2: tab plan if cancer==1 [iw=wt_new]
svy: tab age2 plan if cancer==1 
//sig dif, with greater proportion of older patients given plan

//for cancer patients only-age x no appt
//bysort age2: tab noappt if cancer==1 [iw=wt_new]
//svy: tab age2 noappt if cancer==1 
//sig dif, with greater proportion of older paitents not offered a choice of an appt

//for cancer patients only-age x went to AE when did not take appt
//bysort er: tab age if cancer==1 [iw=wt_new]
//svy: tab age er if cancer==1 
//ns

//for cancer patients only-age x appointment making experience
bysort age2: tab exp if cancer==1 [iw=wt_new]
svy: tab age2 exp if cancer==1
//p<0.05, younger patients had very poor exp whereas older patients had very good experience

//for cancer patients only-age x GP giving enough time
bysort age2: tab time if cancer==1 [iw=wt_new]
svy: tab age2 time if cancer==1
//p<0.05, younger patients had very poor whereas older patients had very good

//for cancer patients only-age x needs met at GP appt
bysort age2: tab need if cancer==1 [iw=wt_new]
svy: tab age2 need if cancer==1
//p<0.05,  older def yes

//for cancer patients only-age x overall experience of GP pracitce
bysort GPexp: tab age if cancer==1 [iw=wt_new]
svy: tab age GPexp if cancer==1
//p<0.05, older very good

//for cancer patients only-age x went to A&E when Gp closed
bysort ERclose: tab age if cancer==1 [iw=wt_new]
svy: tab age ERclose if cancer==1
//ns

//table 4.3 age adj OR

//can age and deprive be binary?
xi: svy: regress numberofLTC i.deprive*i.age if cancer==1
//age*depr no interaction, so yes!
//group deprive into binary variable
tab deprive if cancer==1 [iweight= wt_new]
//25.47% for most, 35.64% for moderately, 38.9% for least deprived
gen dep2=deprive
label var dep2 "least vs most/mod deprived"
recode dep2 1=2 2=2 3=1
label define dep2lab 1 "least deprived" 2 "mod/most deprived"
label val dep2 dep2lab
tab dep2 deprive if cancer==1 [iweight= wt_new]

//LTC
//xi: svy: regress numberofLTC i.deprive if cancer==1
svy: regress numberofLTC dep2 if cancer==1
//xi: svy: regress numberofLTC i.deprive age2 if cancer==1
svy: regress numberofLTC dep2 age2 if cancer==1
// q30 is any LTC - recode it so 0 no LTC, 1 = yes
/*gen LTC=q30
label var LTC "Any LTC"
recode LTC 1=1 2=0 3=3
label define LTClab 1 "yes" 0 "no"
label val LTC LTClab
drop if LTC ==3
tab LTC q30
tab LTC q30 if cancer==1 [iweight= wt_new]
svy: regress numberofLTC dep2 LTC if cancer==1
 bysort cancer: tab LTC [iw=wt_new]*/
// why is cancer showing no ltc? try using q30_recoded as they convered 2 "no" into 1 "yes"
/*
-------------------------------------------------------------------------------------------------------------------------------
-> cancer = no cancer

    Any LTC |      Freq.     Percent        Cum.
------------+-----------------------------------
         no | 244,031.26       56.31       56.31
        yes | 189,314.72       43.69      100.00
------------+-----------------------------------
      Total | 433,345.98      100.00

--------------------------------------------------------------------------------------------------------------------------------
-> cancer = has cancer

    Any LTC |      Freq.     Percent        Cum.
------------+-----------------------------------
         no | 2,103.6187       16.27       16.27
        yes | 10,826.197       83.73      100.00
------------+-----------------------------------
      Total | 12,929.816      100.00
*/
/*tab q30_recoded
gen anyLTC=q30_recoded
label var anyLTC "Any LTC"
recode anyLTC 1=1 2=0 3=3
label define anyLTClab 1 "yes" 0 "no"
label val anyLTC anyLTClab
drop if anyLTC ==3
tab anyLTC 
tab anyLTC q30 if cancer==1 [iweight= wt_new]
 bysort cancer: tab anyLTC [iw=wt_new]

 //stata omits anyLTC in regression, and results are same as unadjusted-having LTC is directly related to deprivation
  svy: regress numberofLTC dep2 if cancer==1


svy: logistic noappt dep2 if cancer==1
svy: logistic noappt dep2 age2 if cancer==1


svy: logistic er dep2 if cancer==1
svy: logistic er dep2 age2 if cancer==1
*/

//xi: svy: logistic i.exp dep2 if cancer==1 doesn't work!
//need to turn exp into binary
//group exp into binary variable
tab exp if cancer==1 [iweight= wt_new]
//36.84% for very good, 38.2% for fairly good, 12.94% for neutral, 8.29% for fairly poor, 3.72% for very poor
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

//ER becomes sig so what if you ungroup dep
//reverse code deprive
gen deprive2=deprive
recode deprive2 1=3 2=2 3=1
label define d2lab 1 "least" 2"moderate" 3"most"
label val deprive2 d2lab
tab deprive2 deprive if cancer==1 [iw=wt_new]

xi: svy: logistic ERclose i.deprive2 if cancer==1
xi: svy: logistic ERclose i.deprive2 age2 if cancer==1

//need LRT to get overall p value for 3 category
estimates store a
svy: logistic ERclose age2 if cancer==1
est store b
//lrtest a b
//lrtest is not appropriate with survey estimation results


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
//fitstat
//listcoef, std help
//cannot use listcoef for models with iweights even after following this method: https://www3.nd.edu/~rwilliam/stats3/L04.pdf
//can it work with linear regression?
xi: regress numberofLTC  dep2 age2 sex MH whiteornot if cancer==1 [iw=wt_new], beta
xi: regress numberofLTC  dep2 age2 sex MH whiteornot hosp exp2 time2 need2 GPexp2 noappt er ERclose if cancer==1 [iw=wt_new], beta
//yes you could

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


//STOP 
//do cluster analysis-can we use a cluster method to group cancer patients in groups of similar characteristics (e.g. age and number of LTC, and deprivation) and  then test whether these groups have significantly different experience / outcomes. 
//which clusters/groups have smiliar characteristics using cluster? then compare their outcomes to each other
svy: cluster kmeans dep2 age2 sex whiteornot smoking numberofLTC hosp plan if cancer==1, k(9)
cluster kmeans dep2 age2 sex whiteornot smoking numberofLTC hosp plan if cancer==1, k(9)
//weighting not allowed in cluster analysis in Stata. Stata can't deal with weights in any cluster procedure and Google confirmed it (https://www.stata.com/statalist/archive/2012-02/msg00851.html).
/*If your weighting variable has a large range, this may be a problem (i.e., if some cases have many times the weight of others).
If I understand k-means correctly, weighting would affect the centroid of each cluster and therefore the solution. 
On the other hand, cluster analysis is mainly a descriptive and exploratory device, and therefore the importance of weighting may be less (depending on the analyst's concerns).
 Tried it without weighting, and Stata shows nothing except generating new clust_1 VAR..
//shouldn't it show graphs of clusters?
//try this https://stats.stackexchange.com/questions/77850/assign-weights-to-variables-in-cluster-analysis 
and https://www.reed.edu/psychology/stata/analyses/advanced/agglomerative.html
The clustering algorithms (I try 3 different) I wish to use are k-means, weighted-average linkage and average-linkage. None worked.
*/
//k means does not work as not all variables are continuous!
set seed 12345
cluster kmeans numberofLTC if cancer==1, k(3) name(myclus1)
bysort myclus1: summarize numberofLTC if cancer==1 [iw=wt_new]
twoway dot numberofLTC myclus1
cluster stop
//shows graph of 3 lines of dots, and this useless table I cant intepret: 
/*+---------------------------+
|             |  Calinski/  |
|  Number of  |  Harabasz   |
|  clusters   |  pseudo-F   |
|-------------+-------------|
|      3      |  22517.82   |
+---------------------------+
K-means clustering requires all variables to be continuous. 
Other methods that do not require all variables to be continuous, including some heirarchical clustering methods, have different assumptions
Hierachical clustering weighted average and average clustering for mixed variables don't work due to insufficient memory*/
cluster waveragelinkage age2 dep2 sex whiteornot numberofLTC if cancer==1, measure(Gower) name(myclus)
cluster waveragelinkage age2 dep2 sex  if cancer==1
cluster averagelinkage age2 dep2 sex whiteornot numberofLTC if cancer==1
//error msg: insufficient memory for ClusterMatrix so I reduced number of var's and still received same error msg. 
//I tried other clustering methods.
cluster s dep2 MH age2, measure(matching) gen (zstub)
cluster list
cluster tree
//too many leaves; consider using the cutvalue() or cutnumber() options. I dropped several var's and still got same error message
//clustering took even longer after dropping more var's -and wouldn't stop executing for more than 50 minutes, forget it!
cluster singlelinkage dep2 MH age2, name(sngeuc)
cluster list sngeuc
cluster dendrogram sngeuc, xlabel(, angle(90) labsize(*.75))
graph matrix xdep2 MH age2
cluster dendrogram sngeuc, labels(numberofLTC) xlabel(, angle(90) labsize(*.75))
//assume this will take a long time too as it's same code as previous, so stopped the execution

//so cluster single linkage didn't work. I tried cluster median then ward, and Stata ran out of memory for both techniques. 
//I tried matrix dissimilarity and it wiped out all my data!
//cluster commands require a significant amount of memory and execution time. With many observations, the execution time is significant.

//try CART-chaid method
ssc install chaid
set seed 1234567
ssc install moremata

//which clusters fall under GP time///////////////////////////////////////////////////////////////
//chaid time2 if cancer==1, dvordered unordered(dep2 MH) ordered(age2 ncLTC) svy exhaust
//try it without dvordered (dvordered treats the response variable as being ordered.)
//chaid time2 if cancer==1, unordered(dep2 MH age2 ncLTC) svy 
//No clusters uncovered.  Cluster #1 is null.
//takes long time to process each time I experiment with the codes-16:40 to 16:48

chaid time2 if cancer==1, minnode(20) minsplit(50) xtile(dep2 MH age2 ncLTC ,n(2)) svy
chaid time2 if cancer==1, minnode(20) minsplit(50) xtile(dep2 MH ncLTC ,n(2)) svy
//No clusters uncovered.  Cluster #1 is null.
chaid time2 if cancer==1, minnode(20) minsplit(50) xtile(dep2 MH age2 ,n(2)) svy
chaid time2 if cancer==1, minnode(20) minsplit(50) xtile(dep2 MH age2 ncLTC whiteornot sex,n(2)) svy
chaid time2 if cancer==1, minnode(20) minsplit(50) xtile(dep2 MH age2  whiteornot sex,n(2)) svy

//identify clusters for GP appt making
chaid exp2 if cancer==1, minnode(20) minsplit(50) xtile(dep2 MH age2 ncLTC whiteornot sex,n(2)) svy
//xi: svy, rrr: mlogit GPexp i.deprive age2 if cancer==1
//when age adj, relationship is n.s for most deprived so age is a confounder for very poor exp
/*Most deprived folks has an increased risk of very poor GP experience relative to very good experience, controlling for age 
but the relationship is not significant (Relative risk ratio or multinomial odds ratio =1.41, p>0.05)
However, most deprived patients have an increased risk of good gp experience relative to very good experience, age adj, and the relationship is significant
*/

//older age is less likely to have poorer GP exp relative to very good experience, controlling for deprivation 
//xi: mlogit deprived i.GPexp age if cancer==1 [iw=wt_new], rrr


