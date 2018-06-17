rm(list=ls())
source("R/clean.R")
source("R/analysis.R")
## read data, data clearnning and sub-scale calculation
src <- "data/2157154_seg_1.csv" 
coding <- read.csv("data/survey_questions.csv", stringsAsFactors = FALSE)
dat0 <- read_dat(src, coding)
dat0 <- tran_age(dat0)
dat0 <- tran_other(dat0)
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


### .2.content analysis of motherhood perception
dat <- sub_scale(dat0, coding, remove = TRUE)
dat <- content_anlaysis(dat)

### .3. two-sample t tests
dat$high_edu <- dat$education > 2
dat$high_income <- dat$income > 1
groups <- c("only_child", "has_brothers","one_child", "young_mother", 
            "self_2_child", "high_edu", "high_income")

lapply(groups, function(group) unlist(lapply(names(dat)[-c(1:3)], function(i) two_sample_t(i, group, dat))))

# independency check for class
a = table(dat$status_current[dat$young_mother], dat$income[dat$young_mother] > 1)
summary(a)

## negative association between mother's birth order and education level
a = table(dat$education[is.finite(dat$mother_birth_order)], 
          dat$mother_birth_order[is.finite(dat$mother_birth_order)],
          dat$only_child[is.finite(dat$mother_birth_order)])
summary(a)
lm(education ~ only_child + mother_birth_order, data = dat)

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

[1] "rank_mother"
[1] "birth_order1"
[1] "birth_order2"
[1] "birth_order3"
[1] "birth_order4"
[1] "education"
[1] "motherhood_definition_translation"
[1] "only_child"
[1] "motherhood_type"

a = table(v$motherhood_type, 
          v$motherhood1)
summary(a)
a


## logistic regression
# summary(glm(formular, data, family = "binormial"))
## linear regression
# summary(glm(formular, data, family = "gaussian"))


