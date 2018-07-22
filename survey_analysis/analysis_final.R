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
dat0$first_son <- dat0$kid_birth_order1 == "M"
# ## factor analysis
# d.fac <- factanal(d, factors = 8, rotation = "varimax", scores=c("regression"))
# d.fac
# print(d.fac, digits = 2, cutoff = .2, sort = TRUE)
## sub scale reliability
subscale_reliability(dat0)
## prepare data to work
model_variable <- c("fertility_preference", "rank_self", "rank_mother",
                    "mother_birth_order", "other_household2", 
                    "education", "occupation_type", "income", 
                    "age", "has_brothers", "has_son", "only_child",
                    "motherhood_type", "one_child", 
                    "childhood", "status_origin", "status_current", 
                    "life_satisfaction", "motherhood_satisfaction", 
                    "mother_interferes_work", "work_interferes_mother")
## con and pro having 2nd child
## might also do a content analysis of mothers' other concerns
con_2nd_child <- c("economy", "material_1_child", "emotion_1_child", 
                   "career", "health", "rejection_1_child")
pro_2nd_child <- c("good", "reduce_lonely_1_child", "reduce_obligation_1_child", 
                   "better_aging", "pressure_parents", "pressure_inlaws")

d <- aggregate(cbind(economy, material_1_child, emotion_1_child, career, health, rejection_1_child) ~ motherhood_type,
               data = dat0[dat0$motherhood_type != "unknown",], mean, na.rm=T)

d <- aggregate(cbind(good, reduce_lonely_1_child, reduce_obligation_1_child, better_aging, pressure_parents, pressure_inlaws) ~ motherhood_type,
               data = dat0[dat0$motherhood_type != "unknown",], mean, na.rm=T)

Chi_squared_test(dat0[dat0$motherhood_type %in% c("modern", "mixed","traditional"), ], 
                 "motherhood_type", con_2nd_child)

Chi_squared_test(dat0[dat0$motherhood_type %in% c("modern", "mixed","traditional"), ],
                 "motherhood_type", pro_2nd_child)

con_pro_2nd_child(dat0, model_variable)

## motherhood experience
mothering_experience <- c("motherhood1", "motherhood2", "motherhood3", "motherhood4", "motherhood5", "motherhood6")
j<-grep("motherhood[0-9]{1}",names(dat0))
for(i in j) {
  print(coding$chinese[coding$q_sub_id == names(dat0)[i]])
  print(summary(dat0[[i]]))
  print(paste(round(sum(dat0[i] > 3) / sum(dat0[i] < 3),2), 
              round(sum(dat0[i] == 3)/nrow(dat0),2), sep = "***"))
}

summary(glm(motherhood6 ~ education, data = dat0[dat0$motherhood_type != "unknown", ], 
            gaussian(link='identity')))
# so the way of childrearing is differnt from traditional;
# do not depend on older generation
# not that much argument
# health is very much the most important task of mothers, eudcation is also very important
# child-centered mothers are 1.2 time who say they are not

## regression anlaysis froom here
dat <- sub_scale(dat0, coding, remove = TRUE)
## motherhood type as response variable
d <- y_motherhood_type(dat, model_variable)
