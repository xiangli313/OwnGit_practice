rm(list=ls())
source("R/clean.R")
source("R/analysis.R")
## read data, data clearnning and sub-scale calculation
src <- "data/2157154_seg_1.csv" 
coding <- read.csv("data/survey_questions.csv", stringsAsFactors = FALSE)
dat0 <- read_dat(src, coding)
dat0 <- tran_age(dat0)
dat0 <- tran_other(dat0)
dat0 <- content_anlaysis(dat0)
dat0$high_edu <- dat0$education > 2
dat0$high_income <- dat0$income > 2
dat0$first_son <- dat0$kid_birth_order1 == "M"
dat <- sub_scale(dat0, coding, remove = FALSE)

### .1. internal consistency measures of reliability
### cronbach's alpha from psych package
#status origin - 0.916 - excelllent
cols <- grep("status_origin[0-9]{1}", names(dat))
psych::alpha(dat[cols])$total$std.alpha

#status current - 0.917 - excellent
cols <- grep("status_current[0-9]{1}", names(dat))
psych::alpha(dat[cols])$total$std.alpha

# #con-2-child - can become a subscale
# psych::alpha(dat[29:34])$total$std.alpha
# # pro-2-child - can become a subscale
# psych::alpha(dat[36:41])$total$std.alpha
#motherhood experience - questionable, but this is not a subscale though
# cols <- grep("motherhood[0-9]{1}", names(dat))
# psych::alpha(dat[cols])$total$std.alpha
# life satisfaction - 0.886 - great
cols <- grep("life_satisfaction[0-9]{1}", names(dat))
psych::alpha(dat[cols])$total$std.alpha
# motherhood satisfaction - 0.835 - great
cols <- grep("motherhood_satisfaction[0-9]{1}", names(dat))
psych::alpha(dat[cols])$total$std.alpha
# mother interferes work - 0.932 - excellent
cols <- grep("mother_interferes_work[0-9]{1}", names(dat))
psych::alpha(dat[cols])$total$std.alpha
# work interferes mother - 0.951 - excellent
cols <- grep("work_interferes_mother[0-9]{1}", names(dat))
psych::alpha(dat[cols])$total$std.alpha

### .3. two-sample t tests
dat <- sub_scale(dat0, coding, remove = TRUE)
groups <- c("only_child", "has_brothers", "has_son", "first_son", "one_child", "young_mother", 
            "self_2_child", "high_edu", "high_income")

lapply(groups, function(group) unlist(lapply(names(dat)[-c(1:3)], function(i) two_sample_t(i, group, dat))))

# independency check for class - occupation/education/income
dat <- sub_scale(dat0, coding, remove = TRUE)
v <- dat[dat$occupation_type != "", ]
for(i in names(v[-c(1:3)])) {
  a = table(v$occupation_type, 
            v[[i]])
  a = summary(a)
  if(a$p.value < 0.05) {
    print(i)
  }
}

for(i in names(dat[-c(1:3)])) {
  a = table(dat$education, 
            dat[[i]])
  a = summary(a)
  if(a$p.value < 0.05) {
    print(i)
  }
}

for(i in names(dat[-c(1:3)])) {
  a = table(dat$income, 
            dat[[i]])
  a = summary(a)
  if(a$p.value < 0.05) {
    print(i)
  }
}

## motherhood type independency check
v <- dat[dat$motherhood_type != "unknown", ]
v$motherhood_type <- v$motherhood_type == "traditional"
for(i in names(dat[-c(1:3)])) {
  a = table(v$motherhood_type, 
            v[[i]])
  a = summary(a)
  if(a$p.value < 0.05) {
    print(i)
  }
}

#### linear regression
## education exploration - DONE
dat <- sub_scale(dat0, coding, remove = TRUE)
a = glm(education ~ young_mother + only_child, 
        data = dat, gaussian(link='identity'))
summary(a)
AIC(a)
a = glm(education ~ young_mother + has_brothers, 
        data = dat, gaussian(link='identity'))
summary(a)
AIC(a) #smaller AIC, so has brothers is better predictor than only_child
BIC(a)
a = glm(education ~ young_mother + has_brothers + mother_birth_order, 
        data = dat, gaussian(link='identity'))
summary(a)
AIC(a) # even better, so education is an outcome of age, has brothers and birth order effect
BIC(a)
#### original status exploration
# independency check for status
dat <- sub_scale(dat0, coding, remove = FALSE)
for(i in names(dat[-c(1:3)])) {
  a = table(dat$status_origin, 
            dat[[i]])
  a = summary(a)
  if(a$p.value < 0.05) {
    print(i)
  }
}

a = glm(status_origin ~ has_brothers, 
        data = dat, gaussian(link='identity'))
summary(a)


#### current status exploration
# independency check for status
dat <- sub_scale(dat0, coding, remove = TRUE)
for(i in names(dat[-c(1:3)])) {
  a = table(dat$status_current, 
            dat[[i]])
  a = summary(a)
  if(a$p.value < 0.05) {
    print(i)
  }
}

a = glm(status_current ~ status_origin + rank2_husband + has_brothers, 
        data = dat, gaussian(link='identity'))
summary(a)
BIC(a)
## has brothers is positively associated with current status, 
## but negatively associated wtih original status

## logistic regression
## motherhood_type = traditional
v <- dat[dat$motherhood_type != "unknown", ]
v$motherhood_type <- v$motherhood_type == "traditional"
# find the following model - any other variable is not significant
a = glm(motherhood_type ~ education + rank_self, 
        data = v, binomial(link='logit'))
AIC(a) 
BIC(a) 
summary(a)
## rank self: individualism v.s. holistic


a = glm(inlaws_2_child ~ first_son + young_mother, 
        data = v, binomial(link='logit'))
AIC(a) 
BIC(a) 
summary(a)
