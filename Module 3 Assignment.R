#install packages
install.packages ("tidyverse")

#load libraries
library(tidyverse)

#set working directory (adjust this for your own computer)
setwd("C:/Users/jazmi/OneDrive/1. DTSC-560-80 Data Science for Business/DTSC-560-80 Data Science for Business/Module 3")


#read dataset into R
creditdf <- read.csv("Credit.csv")
View(creditdf)

ccpredictiondf <- read.csv("credit_card_prediction.csv")
View(ccpredictiondf)


#1. Summary Statistics
summary(creditdf)

#Quiz question #1: How many cardholders in the full dataset are students?


table(creditdf$Student)
#no = 0 , yes = 1
#39 are students

#2. Partition the dataset into a training set and a validation set (following the method
#used in the lecture code car_regression_ex.R) 50, 50


#partition the data into a training set and a validation set
#set seed so the random sample is reproducible
set.seed(42)
sample <- sample(c(TRUE, FALSE), nrow(creditdf), replace=TRUE, prob=c(0.5,0.5))
traincredit  <- creditdf[sample, ]
validatecredit <- creditdf[!sample, ]

#Install package needed for best subsets procedure
install.packages("olsrr")

#Load olsrr library

library(olsrr)

#Create a correlation matrix with the quantitative variables in the training dataframe
view(traincredit)

cor(traincredit[c(1, 2, 3, 4, 5, 6, 7)])

## limit and rating.
#turn off scientific notation for all variables
options(scipen=999) 


summary(traincredit)


#load lm.beta
library(lm.beta)

#Extract standardized regression coefficients
lm.beta(credit_train)


credit_train.stats


#4) Conduct a multiple regression analysis using the training dataframe with Balance
#as the outcome variable and all the other variables in the dataset as predictor
#variables.

credit_train <- lm(Balance ~ Income + Limit + Rating + Age + Education + Student + Gender + Married, data = traincredit)
credit_train
#Quiz question #3: What is the slope coefficient for the Rating variable?  
##1.686428


#install packages
install.packages ("car")

#load libraries
library(car)


#5) Calculate the Variance Inflation Factor (VIF) for all predictor variables.
vif(credit_train)



#Quiz question #4: What is the VIF for the Limit variable?
#156.423468

#Quiz question #5: What problem does the VIF for Limit suggest that we have with the
#analysis? (MC)
# tells us that tge limit and rating are highly correlated

#6) Conduct a new multiple regression analysis using the training dataframe with
#Balance as the outcome variable and Income, Rating, Age, Education, Student,
#Gender, and Married as predictor variables.
new_traini_mc = lm(Balance ~ Income + Rating + Age + Education + Student + Gender + Married, data = traincredit)

#Quiz question #6: What is the new slope coefficient for the Rating variable?

new_traini_mc

# 4.765827


#create a residual plot and a normal probability plot using the results of the regression analysis in Step (6)

#residual plot

#Create a vector of predicted values generated from the multiple 
#regression above
credit_pred2 = predict(new_traini_mc)


#Create a vector of residuals generated from the multiple regression above
credit_res2 = resid(new_traini_mc)


#Create a data frame of the predicted values and the residuals
credit_pres_res <- data.frame(credit_pred2, credit_res2)

#create a scatterplot of the residuals versus the predicted values
ggplot(data = credit_pres_res, mapping = aes(x = credit_pred2, y = credit_res2)) +
  geom_point() +
  labs(title = "Plot of residuals vs. predicted values", x = "Predicted values",
       y = "Residuals")

#create a vector of standardized residuals generated from the multiple
#regression above
credit_std.res = rstandard(new_traini_mc)


#produce normal scores for the standardized residuals and create
#normal probability plot
qqnorm(credit_std.res, ylab = "Standardized residuals", xlab = "Normal scores")


#Quiz question #7: What pattern do you see in the residual plot? (MC)
#Quiz question #8: What does this pattern tell you? (MC)
#Quiz question #9: What pattern do you see in the normal probability plot? (MC)
#Quiz question #10: What does this pattern tell you? (MC)


#Examine the regression output from Step (6).
#Quiz question #11: Which predictor variables have statistically significant relationships
#with the outcome variable, Balance? (MC)
summary(new_traini_mc)
## statistically sign = income, rating, age, and student.

#Conduct a new multiple regression analysis using the training dataframe with
#Balance as the outcome variable and only the variables with statistically
#significant relationships with Balance (identified in Step (8)) as predictors.

newst_MC = lm(Balance ~ Income + Rating + Age + Student, data = traincredit)

newst_MC

summary(newst_MC)

#Quiz question #12: What is the slope coefficient for the Age variable?

#-1.1640174

#Quiz question #13: How would you interpret the slope coefficient for the Rating variable?
#(MC)
#4.7542606

#Quiz question #14: How would you interpret the slope coefficient for the Student
#variable? (MC)
#479.4184553

#Quiz question #15: What is the adjusted R2 for this regression analysis?

#0.9849
#Quiz question #16: How can this adjusted R2 value be interpreted? (MC)
#not too off and its very good predictor

#Quiz question #17: What is the standardized slope coefficient for the Income variable?
#load lm.beta
library(lm.beta)
lm.beta(newst_MC)
#-0.97173221

#Quiz question #18: Looking at the standardized slope coefficients, which variable makes
#the strongest unique contribution to predicting credit card balance? (MC)
#the rating


#10) Conduct a final multiple regression analysis using the validation dataframe with
#Balance as the outcome variable and only the variables with statistically
#significant relationships with Balance (the same variables as in Step (9) as predictors.
#Quiz question #19: What is the new slope coefficient for the Rating variable?

validat_MC = lm(Balance ~ Income + Rating + Age + Student, data = validatecredit)
summary(validat_MC)
##4.8063715

#1) Using the data contained in the csv file “credit_card_prediction.csv”, predict the
#credit card balances for three new cardholders, with 95% prediction intervals.
#Quiz question #20: What is the predicted balance for new cardholder #1?

-767.7113463 + (132557)*(-.0096652) + (523)*(4.7542606) + (43)*(-1.1640174) + (0)*(479.4184553)
#Quiz question #21: What is the 95% prediction interval for the predicted balance for new
#cardholder #2?
predict(validat_MC, ccpredictiondf, interval = "prediction", level = 0.95)
#1395.81,$1625.95