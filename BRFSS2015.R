#Jazmin Aguilar

rm(list = ls())
suppressPackageStartupMessages(library(tidyverse))

brf <- read_csv("BRFSS2015_650.csv", show_col_types = FALSE)


# Q.1 How many people reported their general health is excellent?
# The answer should be assigned to Q1.
Q1 <- brf %>%
  select(GENHLTH) %>%
  filter(GENHLTH == 1) %>%
  count()

# Q.2 What is the highest value for the number of adult women in the household where someone has ever had a stroke?
# Summarise the value in a variable called max_num_women
# The output should be a dataframe assigned to !2 and look something like:

Q2 <- brf %>%
  filter(CVDSTRK3 ==1 | CVDSTRK3 > 1) %>%
  arrange(desc(NUMWOMEN)) %>%
  select(max_num_women = NUMWOMEN) %>%
  head(1) %>%
  data.frame()

#Q3: Compute the mean and standard deviation for MENTHLTH comparing 
#    caregivers who managed personal care such as giving medications, 
#    feeding, dressing, or bathing and those who did not. The summary 
#     variable names should be mean_mental and sd_mental. 
#    The output should be a dataframe assigned to Q3.

brf88 <- brf
brf88[brf88 == "88"] <- 0

Q3 <- brf88 %>%
  select(MENTHLTH, CRGVPERS) %>%
  filter(CRGVPERS == 1 | CRGVPERS == 2) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  group_by(CRGVPERS) %>%
  summarise(mean_mental = mean(MENTHLTH), sd_mental = sd(MENTHLTH))

# Q4: What is the median age when respondents were told they had diabetes 
#     for those living in Pennsylvania? Only calculate it for those who gave 
#     an age. The summary variable name should be med_diab_age.
#     The output should be a dataframe assigned to Q4.

Q4 <- brf %>%
  select(STATE = '_STATE', DIABAGE2) %>%
  filter(STATE == 42, DIABAGE2 >= 1 & DIABAGE2 <= 97) %>%
  group_by(STATE) %>%
  summarise(med_diab_age = median(DIABAGE2)) %>%
  select(med_diab_age) %>%
  data.frame()


# Q5: Predict the number of days in the past 30 days that mental health was 
#     not good from marital status. Keep in mind that one of the possible 
#     answers to “how many days” is 0, not just 1-30. Make sure you know what 
#     type of variable MARITAL is. You’ll need to consider this when 
#     determining how to do linear regression with it.
#     Assign the summary of the model to Q5. 
#     Note: The general instructions say to round all output but the summary()
#           of a model is not able to be rounded. 
# need to convert marital to factors of 1 to

brfMarital <- brf88 %>%
  select(MARITAL, MENTHLTH) %>%
  filter(MARITAL >= 1 & MARITAL <= 6) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  mutate(MARITAL = as.factor(MARITAL))

Q5 <- summary(lm(MENTHLTH ~ MARITAL, brfMarital))

# Q6: Use summarise to compare the mean number of days in the past 30 days 
#     that mental health was not good by marital status. The summary variable 
#     name should be mean_mental. The mean value for marital status 1 should 
#     help you to confirm the intercept value from Q5. 
#     The output should be a dataframe assigned to Q6.

brfMarital2 <- brf88 %>%
  select(MARITAL, MENTHLTH) %>%
  filter(MARITAL >= 1 & MARITAL <= 6) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  group_by(MARITAL) %>%
  summarise(mean_mental = mean(MENTHLTH))
Q6 <- brfMarital2

#Q7: Calculate the means and standard deviations of MENTHLTH for those who 
#     have ever been diagnosed with a stroke and those who have not had a 
#     stroke only for those who do not have any kind of healthcare coverage. 
#     The summary variable names should be mean_mental and sd_mental.
#     The output should be a data frame assigned to Q7.

#CVDSTRK3 , 1 = yes stroke 2 = no, HLTHPLN1 2 = no
Q7 <- brf88 %>%
  filter(CVDSTRK3 == 1 | CVDSTRK3 == 2) %>%
  filter(HLTHPLN1 == 2) %>%
  filter(MENTHLTH >= 0 & MENTHLTH <= 30) %>%
  group_by(CVDSTRK3) %>%
  summarise(mean_mental = round(mean(MENTHLTH), 2), sd_mental = round(sd(MENTHLTH), 2)) %>%
  data.frame()


# Q8: Each respondent was asked if they participated in any physical 
#     activities in the past month. They were then asked what physical 
#     activity they spent the most time doing (or did the most) in the past 
#     month. Next, they were asked how many times per week or per month they 
#     took part in that exercise/activity. Run an ANOVA comparing how many 
#     times per week they took part in that exercise/activity with marital 
#     status. You may need to do some research on how to do this in R. 
#     Assign the summary of the ANOVA to Q8. 
#     Note: the general instructions say to round all output but the summary 
#           of anE ANOVA  is not able to be rounded.

#asked if they participated in pa past month : EXERANY2 (1 = yes, 2 = no, only)
#what type pa :EXRACT11 (1 -76, 98=other, 77=dont know, 99=refused
#weeks per month : EXEROFT1 (101-199 = times per week, 201-299= times per month, 777= dontknpw, 999= refused)
#marital status: MARITAL (1-6, 9 = refused)

aov1 <- brf %>%
  select(EXRACT11, EXEROFT1, MARITAL) %>%
  filter(EXRACT11 >= 1 & EXRACT11 <= 76 | EXRACT11 == 98) %>%
  filter(EXEROFT1 >= 101 & EXEROFT1 <= 199) %>%
  filter(MARITAL >= 1 & MARITAL <= 6) %>%
  mutate(MARITAL = as.factor(MARITAL))

Q8 <- summary(aov(EXRACT11 ~ MARITAL, aov1))

# Q9: Consider only men for the following question. Each respondent was 
#     asked if they participated in any physical activities in the past month.
#     They were then asked what physical activity they spent the most time 
#     doing (or did the most) in the past month. Respondents were also asked 
#     to consider the past 30 days and answer either a) how many days per week
#     or b) how many days per month did they have at least one drink of any 
#     alcoholic beverage. For each type of physical activity or exercise, 
#     calculate the variance of the number of days per week a respondent 
#     drank alcohol. Note: pay careful attention to how values are coded in 
#     the Codebook. The summary variable name should be called var_drinks.
#     Arrange in descending order, and include only the six with the highest 
#     variance in drinks.
#     The output should be a dataframe assigned to Q9.
# SEX 1 = male
# #what type pa :EXRACT11 (1 -76, 98=other, 77=dont know, 99=refused
#ALCDAY5, 101- 199 

brf888 <- brf
brf888[brf888 == 888] <- 0

Q9 <- brf888 %>%
  filter(SEX == 1) %>%
  filter(EXRACT11 >= 1 & EXRACT11 <=76 | EXRACT11 == 98) %>%
  filter(ALCDAY5 >= 101 & ALCDAY5 <= 199 | ALCDAY5 == 0) %>%
  mutate(drinks = ifelse(ALCDAY5 >= 101 & ALCDAY5 <= 107, ALCDAY5 -100, ALCDAY5/4.34)) %>%
  group_by(EXRACT11) %>%
  summarise(var_drinks = round(var(drinks), 2)) %>%
  arrange(desc(var_drinks)) %>%
  head(6) %>%
  data.frame()
