################################################################################
# Packages #
################################################################################
library(haven)
library(survey)
library(dplyr)
library(readstata13)
library(tidyverse)
library(installr)
library(forcats)
library(data.table)
library(naniar)

################################################################################
# Load the dataset # 
################################################################################
list.files()
mydata <-fread(file="A:/NHS fake folder/Person Dataset weighted - No barcode CSV.csv", na.strings="")

############################
##### Data exploration #####
############################
View(mydata)
str(mydata) 
tail(mydata)

################################################################################
# Data Cleaning # 
################################################################################

#replace Q with q
names(mydata)[2:150] <- gsub(pattern = "Q",replacement = "q",names(mydata)[2:150])
view(mydata)

####################################
###REMOVING NON-SENSICAL DATA POINTS
####################################

#https://stackoverflow.com/questions/28696042/replace-negative-values-by-na-values
mydata3 <- mydata
mydata3[mydata3 < 0] <- NA
view(mydata3)

#################################
### ADJUSTING VALUES FOR ANALYSIS
#################################

#relabel variables 

mydata3$dep2 <- factor(mydata3$depriv, levels = c(sort(unique(mydata3$depriv)),NA),
                       labels = as.character(c(rep(-99,length(sort(unique(mydata3$depriv)))-3),1,1,0))) 
mydata3$age65over <- factor(mydata3$q48_Merged, levels = c(sort(unique(mydata3$q48_Merged)),NA),
                            labels = as.character(c(rep(-99,length(sort(unique(mydata3$q48_Merged)))-8),0,0,0,0,0,1,1,1)))
mydata3$male <- factor(mydata3$q47, levels = c(sort(unique(mydata3$q47)),NA),
                       labels = as.character(c(rep(-99,length(sort(unique(mydata3$q47)))-2),1,0))) 
mydata3$whiteornot <- factor(mydata3$q49, levels = c(sort(unique(mydata3$q49)),NA),
                             labels = as.character(c(rep(-99,length(sort(unique(mydata3$q49)))-18),rep(1,4),rep(0,14)))) 
mydata3$smoke <-factor(mydata3$q55, levels = c(sort(unique(mydata3$q55)),NA),
                       labels = as.character(c(rep(-99,length(sort(unique(mydata3$q55)))-4),0,0,1,1))) 
mydata3$reducedADL <- factor(mydata3$q93, levels = c(sort(unique(mydata3$q93)),NA),
                             labels = as.character(c(rep(-99,length(sort(unique(mydata3$q93)))-3),1,1,0))) 
mydata3$hosp <- factor(mydata3$q95, levels = c(sort(unique(mydata3$q95)),NA),
                       labels = as.character(c(rep(NA,length(sort(unique(mydata3$q95)))-2),1,0))) 
mydata3$Nohosp <- factor(mydata3$q95, levels = c(sort(unique(mydata3$q95)),NA),
                         labels = as.character(c(rep(NA,length(sort(unique(mydata3$q95)))-2),0,1))) 
mydata3$plan <- factor(mydata3$q99, levels = c(sort(unique(mydata3$q99)),NA),
                       labels = as.character(c(rep(-99,length(sort(unique(mydata3$q99)))-3),1,0,NA))) 
mydata3$noappt <- factor(mydata3$q79_4, levels = c(sort(unique(mydata3$q79_4)),NA),
                         labels = as.character(c(rep(-99,length(sort(unique(mydata3$q79_4)))-2),0,1))) 
mydata3$er <- mydata3$q82_3
mydata3$didNotgoToER <- factor(mydata3$q82_3, levels = c(sort(unique(mydata3$q82_3)),NA),
                               labels = as.character(c(rep(-99,length(sort(unique(mydata3$q82_3)))-2),1,0)))
mydata3$GoodExpMakingAppt <-factor(mydata3$q18, levels = c(sort(unique(mydata3$q18)),NA),
                                   labels = as.character(c(rep(-99,length(sort(unique(mydata3$q18)))-5),1,1,0,0,0)))
mydata3$GPGoodInGivingEnoughTime <- factor(mydata3$q21a, levels = c(sort(unique(mydata3$q21a)),NA),
                                           labels = as.character(c(rep(-99,length(sort(unique(mydata3$q21a)))-6),1,1,0,0,0,NA)))
mydata3$isolated <- mydata3$q91_3
mydata3$falls <- mydata3$q91_2
mydata3$needMet <- factor(mydata3$q90, levels = c(sort(unique(mydata3$q90)),NA),
                          labels = as.character(c(rep(-99,length(sort(unique(mydata3$q90)))-4),1,1,0,NA)))
mydata3$GoodOverallExpOfGPpractice <- factor(mydata3$q28, levels = c(sort(unique(mydata3$q28)),NA),
                                             labels = as.character(c(rep(-99,length(sort(unique(mydata3$q28)))-5),1,1,0,0,0)))
mydata3$ERwhenGPclosed <-mydata3$q67_4
mydata3$DidNotGoERwhenGPclosed <-factor(mydata3$q67_4, levels = c(sort(unique(mydata3$q67_4)),NA),
                                        labels = as.character(c(rep(-99,length(sort(unique(mydata3$q67_4)))-2),1,0)))
mydata3$GPrecognizedMHneeds <- factor(mydata3$q87, levels = c(sort(unique(mydata3$q87)),NA),
                                      labels = as.character(c(rep(-99,length(sort(unique(mydata3$q87)))-5),1,1,0,"no MH needs",NA)))
mydata3$preferredgp <- factor(mydata3$q8, levels = c(sort(unique(mydata3$q8)),NA),
                              labels = as.character(c(rep(-99,length(sort(unique(mydata3$q8)))-4),1,0,NA,1)))
mydata3$confidentmanagingIssuesfromConditions <- factor(mydata3$q94, levels = c(sort(unique(mydata3$q94)),NA),
                                                        labels = as.character(c(rep(-99,length(sort(unique(mydata3$q94)))-5),1,1,0,0,NA)))
mydata3$parentsOfKidsUnder16 <- factor(mydata3$q53, levels = c(sort(unique(mydata3$q53)),NA),
                                       labels = as.character(c(rep(NA,length(sort(unique(mydata3$q53)))-2),1,0)))
mydata3$carer <- factor(mydata3$q56, levels = c(sort(unique(mydata3$q56)),NA),
                        labels = as.character(c(rep(NA,length(sort(unique(mydata3$q56)))-6),0,1,1,1,1,1)))
mydata3$noLTC <- mydata3$q31_17
mydata3$LTC <-factor(mydata3$q30_recoded, levels = c(sort(unique(mydata3$q30_recoded)),NA),
                     labels = as.character(c(rep(-99,length(sort(unique(mydata3$q30_recoded)))-4),1,0, NA, NA)))
mydata3$FiveMeds <- factor(mydata3$q92, levels = c(sort(unique(mydata3$q92)),NA),
                           labels = as.character(c(rep(NA,length(sort(unique(mydata3$q92)))-2),1,0)))
mydata3$signLanguage <- factor(mydata3$q54, levels = c(sort(unique(mydata3$q54)),NA),
                               labels = as.character(c(rep(NA,length(sort(unique(mydata3$q54)))-2),1,0)))
mydata3$easyToPhone <- factor(mydata3$q3, levels = c(sort(unique(mydata3$q3)),NA),
                              labels = as.character(c(rep(NA,length(sort(unique(mydata3$q3)))-5),1,1,0,0,NA)))
mydata3$GPGoodInListening <- factor(mydata3$q21b, levels = c(sort(unique(mydata3$q21b)),NA),
                                    labels = as.character(c(rep(-99,length(sort(unique(mydata3$q21b)))-6),1,1,0,0,0,NA)))
mydata3$GPGoodInCaring <- factor(mydata3$q21e, levels = c(sort(unique(mydata3$q21e)),NA),
                                 labels = as.character(c(rep(-99,length(sort(unique(mydata3$q21e)))-6),1,1,0,0,0,NA)))
mydata3$PatientWasInvolvedinDecisionsAboutCare <- factor(mydata3$q88, levels = c(sort(unique(mydata3$q88)),NA),
                                                         labels = as.character(c(rep(-99,length(sort(unique(mydata3$q88)))-4),1,1,0,NA)))
mydata3$PatientDiscussedWhatIsImportant <- factor(mydata3$q96, levels = c(sort(unique(mydata3$q96)),NA),
                                                  labels = as.character(c(rep(NA,length(sort(unique(mydata3$q96)))-3),1,0,NA)))
mydata3$DidnotTakeApptOfferedNoPreferredGP <- factor(mydata3$q81_7, levels = c(sort(unique(mydata3$q81_7)),NA),
                                                     labels = as.character(c(rep(NA,length(sort(unique(mydata3$q81_7)))-2),0,1)))

#relabel 16 LTCs
mydata3$alzheimer <- mydata3$q31_1 
mydata3$arthritis <-mydata3$q31_3
mydata3$blindness <-mydata3$q31_5
mydata3$cancer <- mydata3$q31_6
mydata3$copd <- mydata3$q31_4 
mydata3$deaf <- mydata3$q31_7
mydata3$autism <- mydata3$q31_18
mydata3$diabetes <- mydata3$q31_8
mydata3$heart <- mydata3$q31_2
mydata3$hbp <- mydata3$q31_10
mydata3$kidney <- mydata3$q31_11
mydata3$LD <- mydata3$q31_19
mydata3$MH <- mydata3$q31_14
mydata3$epilepsy <- mydata3$q31_15
mydata3$stroke <- mydata3$q31_20
mydata3$other <- mydata3$q31_16


#generate number of LTC including cancer
mydata3$num_LTC <- apply(mydata3[,c("alzheimer","arthritis","blindness","cancer", "copd","deaf","autism","diabetes","heart","hbp","kidney","LD","MH","epilepsy","stroke","other")],2,as.numeric) %>% apply(1,sum, na.rm=T)   
summary(mydata3$num_LTC)
view(head(mydata3[,c("alzheimer","arthritis","blindness","copd","cancer","deaf","autism","diabetes",
                     "heart","hbp","kidney","LD","MH","epilepsy","stroke","other")],n=60))

######################
### OTHER DATA CHECKS
######################

#double check variables are recoded correctly
unique(mydata3%>%select(dep2,depriv) ) %>% arrange(depriv)
unique(mydata3%>%select(age65over,q48_Merged) ) %>% arrange(q48_Merged)
unique(mydata3%>%select(male,q47) ) %>% arrange(q47)
unique(mydata3%>%select(whiteornot,q49) ) %>% arrange(q49)
unique(mydata3%>%select(smoke,q55) ) %>% arrange(q55)
unique(mydata3%>%select(reducedADL,q93) ) %>% arrange(q93)
unique(mydata3%>%select(hosp,q95) ) %>% arrange(q95)
unique(mydata3%>%select(Nohosp,q95) ) %>% arrange(q95)
unique(mydata3%>%select(plan,q99) ) %>% arrange(q99)
unique(mydata3%>%select(noappt,q79_4) ) %>% arrange(q79_4)
unique(mydata3%>%select(er,q82_3) ) %>% arrange(q82_3)
unique(mydata3%>%select(didNotgoToER,q82_3) ) %>% arrange(q82_3)
unique(mydata3%>%select(GoodExpMakingAppt,q18) ) %>% arrange(q18)
unique(mydata3%>%select(GPGoodInGivingEnoughTime,q21a) ) %>% arrange(q21a)
unique(mydata3%>%select(isolated,q91_3) ) %>% arrange(q91_3)
unique(mydata3%>%select(falls,q91_2) ) %>% arrange(q91_2)
unique(mydata3%>%select(needMet,q90) ) %>% arrange(q90)
unique(mydata3%>%select(GoodOverallExpOfGPpractice,q28) ) %>% arrange(q28)
unique(mydata3%>%select(ERwhenGPclosed,q67_4) ) %>% arrange(q67_4)
unique(mydata3%>%select(DidNotGoERwhenGPclosed,q67_4) ) %>% arrange(q67_4)
unique(mydata3%>%select(GPrecognizedMHneeds,q87) ) %>% arrange(q87)
unique(mydata3%>%select(preferredgp,q8) ) %>% arrange(q8)
unique(mydata3%>%select(confidentmanagingIssuesfromConditions,q94) ) %>% arrange(q94)
unique(mydata3%>%select(parentsOfKidsUnder16,q53) ) %>% arrange(q53)
unique(mydata3%>%select(carer,q56) ) %>% arrange(q56)
unique(mydata3%>%select(noLTC,q31_17) ) %>% arrange(q31_17)
unique(mydata3%>%select(LTC,q30_recoded) ) %>% arrange(q30_recoded)
unique(mydata3%>%select(FiveMeds,q92) ) %>% arrange(q92)
unique(mydata3%>%select(signLanguage,q54) ) %>% arrange(q54)
unique(mydata3%>%select(easyToPhone,q3) ) %>% arrange(q3)
unique(mydata3%>%select(GPGoodInListening,q21b) ) %>% arrange(q21b) 
unique(mydata3%>%select(GPGoodInCaring,q21e) ) %>% arrange(q21e)
unique(mydata3%>%select(PatientWasInvolvedinDecisionsAboutCare,q88) ) %>% arrange(q88)
unique(mydata3%>%select(PatientDiscussedWhatIsImportant,q96) ) %>% arrange(q96)
unique(mydata3%>%select(DidnotTakeApptOfferedNoPreferredGP,q81_7) ) %>% arrange(q81_7)

##Number of LTC to Numerical (If needed)
summary(mydata3$num_LTC)

######################################
############ Analysis ################
######################################

#CART regression tree.Didn't work bc IT doesn't allow installing tree package
install.packages("tree")
library(tree)

#CART rpart package 
install.packages("rpart")
library(rpart)
library(rpart.plot)

#tree 1a: overall GP exp

fit <- rpart(GoodOverallExpOfGPpractice ~ whiteornot + dep2 + age65over + num_LTC + reducedADL + male + 
               confidentmanagingIssuesfromConditions + plan + easyToPhone + preferredgp + GoodExpMakingAppt +
               GPGoodInGivingEnoughTime + GPGoodInListening + GPGoodInCaring + GPrecognizedMHneeds +
               PatientWasInvolvedinDecisionsAboutCare,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 200, minbucket = 180, cp=0.001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for Overall GP Practice Experience")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for Overall GP Practice Experience")


#tree 1a-exclude NA from tree
tree1a=subset(mydata3, cancer==1  & GPGoodInCaring!="NA" & easyToPhone!="NA" & GPGoodInGivingEnoughTime!="NA")
levels(tree1a$GPGoodInCaring)
tree1a$GPGoodInCaring <- factor(tree1a$GPGoodInCaring)
levels(tree1a$GPGoodInCaring)

tree1a$easyToPhone <- factor(tree1a$easyToPhone)
levels(tree1a$easyToPhone)

tree1a$GPGoodInGivingEnoughTime <- factor(tree1a$GPGoodInGivingEnoughTime)
levels(tree1a$GPGoodInGivingEnoughTime)


fit <- rpart(GoodOverallExpOfGPpractice ~ whiteornot + dep2 + age65over + num_LTC + reducedADL + male + 
               confidentmanagingIssuesfromConditions + plan + easyToPhone + preferredgp + GoodExpMakingAppt +
               GPGoodInGivingEnoughTime + GPGoodInListening + GPGoodInCaring + GPrecognizedMHneeds +
               PatientWasInvolvedinDecisionsAboutCare,
             method="class", data=tree1a, model=TRUE, weights = wt_new, control = rpart.control (minsplit= 200, minbucket = 180, cp=0.001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for Overall GP Practice Experience")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for Overall GP Practice Experience")

#tree 1b: Needs not met at last GP appt

fit <- rpart(needMet ~ male + dep2  + whiteornot+ age65over + num_LTC + reducedADL + plan + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + 
               GPrecognizedMHneeds + preferredgp + GPGoodInGivingEnoughTime + GPGoodInListening,
             method="class", data=subset(mydata3, cancer==1), weights = wt_new, control = rpart.control (minsplit= 180, minbucket = 180, cp=0.001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101)
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104)

#tree 1b: exclude NA from tree
tree1b=subset(mydata3, cancer==1 & GPGoodInListening!="NA"  & GPGoodInGivingEnoughTime!="NA" & GPrecognizedMHneeds!="NA" & confidentmanagingIssuesfromConditions!="NA")
levels(tree1b$GPGoodInListening)
tree1b$GPGoodInListening <- factor(tree1b$GPGoodInListening)
levels(tree1b$GPGoodInListening)

tree1b$GPGoodInGivingEnoughTime <-factor(tree1b$GPGoodInGivingEnoughTime)
levels(tree1b$GPGoodInGivingEnoughTime)

levels(tree1b$GPrecognizedMHneeds)
tree1b$GPrecognizedMHneeds <- factor(tree1b$GPrecognizedMHneeds)
levels(tree1b$GPrecognizedMHneeds)

levels(tree1b$confidentmanagingIssuesfromConditions)
tree1b$confidentmanagingIssuesfromConditions <- factor(tree1b$confidentmanagingIssuesfromConditions)

fit <- rpart(needMet ~ male + dep2  + whiteornot+ age65over + num_LTC + reducedADL + plan + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + 
               GPrecognizedMHneeds + preferredgp + GPGoodInGivingEnoughTime + GPGoodInListening,
             method="class", data=tree1b, weights = wt_new, control = rpart.control (minsplit= 180, minbucket = 120, cp=0.001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for Needs Met at Last GP appointment")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for Needs Met at Last GP appointment")

#tree1b: excuding good in listening=0
tree1b=subset(mydata3, cancer==1 & GPGoodInListening!="NA"  & GPGoodInListening!=0 & GPGoodInGivingEnoughTime!="NA" & GPrecognizedMHneeds!="NA" & confidentmanagingIssuesfromConditions!="NA")
levels(tree1b$GPGoodInListening)
tree1b$GPGoodInListening <- factor(tree1b$GPGoodInListening)
levels(tree1b$GPGoodInListening)

tree1b$GPGoodInGivingEnoughTime <-factor(tree1b$GPGoodInGivingEnoughTime)
levels(tree1b$GPGoodInGivingEnoughTime)

levels(tree1b$GPrecognizedMHneeds)
tree1b$GPrecognizedMHneeds <- factor(tree1b$GPrecognizedMHneeds)
levels(tree1b$GPrecognizedMHneeds)

levels(tree1b$confidentmanagingIssuesfromConditions)
tree1b$confidentmanagingIssuesfromConditions <- factor(tree1b$confidentmanagingIssuesfromConditions)

fit <- rpart(needMet ~ male + dep2  + whiteornot+ age65over + num_LTC + reducedADL + plan + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + 
               GPrecognizedMHneeds + preferredgp + GPGoodInGivingEnoughTime + GPGoodInListening,
             method="class", data=tree1b, weights = wt_new, control = rpart.control (minsplit= 15, minbucket = 8, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for Needs Met at Last GP appointment")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for Needs Met at Last GP appointment")


#tree 2a:  GP was good in giving enough time 
fit <- rpart(GPGoodInGivingEnoughTime ~ num_LTC + MH  + GPrecognizedMHneeds +  age65over + whiteornot + plan + dep2 + smoke + reducedADL + 
               + falls + male +isolated + FiveMeds + confidentmanagingIssuesfromConditions + signLanguage,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 75, minbucket = 38, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for GP giving enough time")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for GP giving enough time")

#tree 2a: exclude NA from GP recognized MH needs
tree2a=subset(mydata3, cancer==1  & GPrecognizedMHneeds!="NA")
levels(tree2a$GPrecognizedMHneeds)
tree2a$GPrecognizedMHneeds <- factor(tree2a$GPrecognizedMHneeds)
levels(tree2a$GPrecognizedMHneeds)

fit <- rpart(GPGoodInGivingEnoughTime ~ num_LTC + MH  + GPrecognizedMHneeds +  age65over + whiteornot + plan + dep2 + smoke + reducedADL + 
               + falls + male +isolated + FiveMeds + confidentmanagingIssuesfromConditions + signLanguage,
             method="class", data=tree2a, model=TRUE, weights = wt_new, control = rpart.control (minsplit= 75, minbucket = 80, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101)
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104)


#tree 2a: what happens when you exclude also GP recognized MH needs==0? 
b2=subset(mydata3, cancer==1  & GPrecognizedMHneeds!="NA" & GPrecognizedMHneeds!=0)
levels(b2$GPrecognizedMHneeds)
b2$GPrecognizedMHneeds <- factor(b2$GPrecognizedMHneeds)
levels(b2$GPrecognizedMHneeds)

fit <- rpart(GPGoodInGivingEnoughTime ~ num_LTC + MH  + GPrecognizedMHneeds +  age65over + whiteornot + plan + dep2 + smoke + reducedADL + 
               + falls + male +isolated + FiveMeds + confidentmanagingIssuesfromConditions + signLanguage,
             method="class", data=b2, model=TRUE, weights = wt_new, control = rpart.control (minsplit= 40, minbucket = 12, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101)
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104)

#tree3a: What did you do when you did not take the appointment you were offered? Went to A&E
fit <- rpart(er ~ dep2 + male + whiteornot +  age65over +  plan + DidnotTakeApptOfferedNoPreferredGP + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + isolated + GPrecognizedMHneeds,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 10, minbucket = 7, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101)
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104)

#tree 3a: reverse coded A&E where 1=did not go to A&E
fit <- rpart(didNotgoToER ~ dep2 + male + whiteornot +  age65over +  plan + DidnotTakeApptOfferedNoPreferredGP + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + isolated + GPrecognizedMHneeds,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 10, minbucket = 7, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for A&E after rejecting appt")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for A&E after rejecting appt")

#tree3b: A&E when GP is closed
fit <- rpart(ERwhenGPclosed ~ dep2 + male + whiteornot +  age65over + parentsOfKidsUnder16 + plan + preferredgp + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + isolated + GPrecognizedMHneeds,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 100, minbucket = 400, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for A&E when GP is closed")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for A&E when GP is closed")

#tree 3b: reverse coded A&E when GP is closed where 1=did not go to A&E
fit <- rpart(DidNotGoERwhenGPclosed ~ dep2 + male + whiteornot +  age65over + parentsOfKidsUnder16 + plan + preferredgp + 
               PatientDiscussedWhatIsImportant + confidentmanagingIssuesfromConditions + isolated + GPrecognizedMHneeds,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 100, minbucket = 400, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for A&E when GP is closed")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for A&E when GP is closed")


#tree3c: unexpected hospitalisation due to LTC
fit <- rpart(hosp ~ num_LTC + reducedADL + GPGoodInGivingEnoughTime + GPrecognizedMHneeds + confidentmanagingIssuesfromConditions + 
               PatientDiscussedWhatIsImportant + plan + preferredgp + dep2 + whiteornot +  age65over +male +  easyToPhone  + GoodExpMakingAppt,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 300, minbucket = 300, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for unexpected hospitalisation due to LTC")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for unexpected hospitalisation due to LTC")

#tree 4a: Exp making GP appt
fit <- rpart(GoodExpMakingAppt ~ blindness + alzheimer + arthritis + deaf + autism + LD + MH + num_LTC + reducedADL 
             + male  +  age65over+ whiteornot + parentsOfKidsUnder16 +  carer  + dep2 + smoke + isolated + FiveMeds,
             method="class", data=subset(mydata3, cancer==1), model=TRUE, weights = wt_new, control = rpart.control (minsplit= 120, minbucket = 150, cp=0.0001))
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 101, main="Classification Tree for Appt Making Experience")
rpart.plot(fit,type=3, branch=.3, clip.right.labs=FALSE, extra = 104, main="Classification Tree for Appt Making Experience")

