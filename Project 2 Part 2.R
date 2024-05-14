#Jazmin Aguilar

rm(list = ls())
suppressPackageStartupMessages(library(tidyverse))

brf <- read_csv("BRFSS2015_650.csv", show_col_types = FALSE)

## the four variables I will use: SEX, ASTHMA3, VETERAN3, EDUCA

#Q10 PHYSHLTH (PHYSICAL HEALTH NOT GOOD): 1-30 -> NUMBER OF DAYS, 88 -> NONE, 77 -> DONT KNOW, 99 -> REFUSED, BLANK->NOT ASKED/MISSING
##   ASTHMA3  (EVER TOLD HAD ASTHMA):  1-> YES, 2 -> NO, 7 -> DONT KNOW, 9-> REFUSED
##   VETERAN3 (ARE YOU A VET): 1 -> YES, 2 -> NO, 7 -> DONT KNOW, 9-> REFUSED , left blank
##   SMOKE100 (SMOKE AT LEAST 100 CIGS IN LIFE)    : 1 -> YES, 2 -> NO
##     7 -> DONT KNOW/NOT SURE
##     9 -> REFUSED
##     BLANK -> NOT ASKED OR MISSING
##  NO EXTRA DECIMALS APPLIED, 88 FOR THE PHYSHLTH IS EQUAL TO 0



#Q11 
brf88 <- brf
brf88[brf88 == "88"] <- 0
brffilter <- brf88 %>%
  select(PHYSHLTH, ASTHMA3, VETERAN3, SMOKE100) %>%
  filter(VETERAN3 == 1 | VETERAN3 == 2) %>%
  filter(PHYSHLTH >= 0 & PHYSHLTH <= 30) %>%
  filter(ASTHMA3 == 1 | ASTHMA3 == 2) %>%
  filter(SMOKE100 == 1 | SMOKE100 == 2)

Q11 <- brffilter #data set with no outliers
## for PHYSHLTH, converted 88 to 0 to have 88 represent 0 in days, and then removed those who put DONT KNOW/note sure(77), REFUSED(99) and blank (removed 77, 99 and blank with filter)
## removed those who put DONT KNOW/NOT SURE(7), REFUSED(9) and left blank answer if they were VETERAN(VETERAN3) (removed 7, 9 , and blank with filter)
## removed those who put DONT KNOW/NOT SURE(7) and REFUSED(9) if they had ASMTHA(ASTHMA3) (removed 7 and 9 with filter)
## removed those who put DONT KNOW/NOT SURE(7), REFUSED(9) and left blank answer if they had samoke at least 100 cigarettes in entire life(SMOKE100) (removed7, 9 and blank with filter) 


#Q12
ggplot(brffilter) + geom_boxplot(mapping = aes(PHYSHLTH)) # TO SEE OVERALL DISTRIBUTION OF Physical health was not good
ggplot(brffilter) + geom_histogram(mapping = aes(PHYSHLTH), binwidth = 0.75)   # to see distribution more concretely
ggplot(brffilter) + geom_histogram(mapping = aes(VETERAN3), binwidth = 0.75)  # see distribution of how many veterans and non veterans in survey
ggplot(brffilter) + geom_histogram(mapping = aes(SMOKE100), binwidth = 0.75)  # compare/see those who smoke 100 cigarettes in their life

#Q13 BASIC descriptive statistics

# FOR PHYSHLTH: (SUMMARY, MEAN, SD, frequency)
summary(brffilter$PHYSHLTH)
mean(brffilter$PHYSHLTH)
sd(brffilter$PHYSHLTH)
table(brffilter$PHYSHLTH)


# FOR ASTHMA3: (SUMMARY, MEAN, SD, frequency)
summary(brffilter$ASTHMA3)
mean(brffilter$ASTHMA3)
sd(brffilter$ASTHMA3)
table(brffilter$ASTHMA3)




# FOR VETERAN3: (SUMMARY, MEAN, SD, frequency)
summary(brffilter$VETERAN3)
mean(brffilter$VETERAN3)
sd(brffilter$VETERAN3)
table(brffilter$VETERAN3)


# FOR SMOKE100: (SUMMARY, MEAN, SD, frequency)
summary(brffilter$SMOKE100)
mean(brffilter$SMOKE100)
sd(brffilter$SMOKE100)
table(brffilter$SMOKE100)

#Q14 interested in PHYSHLTH
mod1 <-lm(PHYSHLTH ~ ASTHMA3, brffilter)
summary(mod1)
mod2 <-lm(PHYSHLTH ~ ASTHMA3 + VETERAN3, brffilter)
summary(mod2)
mod3 <-lm(PHYSHLTH ~ ASTHMA3 + VETERAN3 + SMOKE100, brffilter)
summary(mod3)
min(AIC(mod1, k = 2), AIC(mod2, k = 2), AIC(mod3, k = 2))
#Mod3 is the best -> lm(PHYSHLTH ~ ASTHMA3 + VETERAN3 + SMOKE100, brffilter), as it has a better R adjusted value and lower AIC value




