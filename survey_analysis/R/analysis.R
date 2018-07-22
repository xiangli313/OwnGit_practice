subscale_reliability <- function(dat0) {
  message("Internal consistency measures of reliability")
  ### .1. internal consistency measures of reliability
  ### cronbach's alpha from psych package
  dat <- sub_scale(dat0, coding, remove = FALSE)
  #status origin - 0.916 - excelllent
  cols <- grep("status_origin[0-9]{1}", names(dat))
  print(paste0("status_origin: ",
               round(psych::alpha(dat[cols])$total$std.alpha, 2)))
  #status current - 0.917 - excellent
  cols <- grep("status_current[0-9]{1}", names(dat))
  print(paste0("status_current: ",
               round(psych::alpha(dat[cols])$total$std.alpha, 2)))
  #con-2-child - can become a subscale
  print(paste0("con - 2nd child: ",
               round(psych::alpha(dat[29:34])$total$std.alpha, 2)))
  # pro-2-child - can become a subscale
  print(paste0("pro - 2nd chi: ",
               round(psych::alpha(dat[36:41])$total$std.alpha, 2)))
  #life satisfaction - 0.886 - great
  cols <- grep("life_satisfaction[0-9]{1}", names(dat))
  print(paste0("life_satisfaction :",
               round(psych::alpha(dat[cols])$total$std.alpha, 2)))
  # motherhood satisfaction - 0.835 - great
  cols <- grep("motherhood_satisfaction[0-9]{1}", names(dat))
  print(paste0("motherhood satisfaction :",
               round(psych::alpha(dat[cols])$total$std.alpha, 2)))
  # mother interferes work - 0.932 - excellent
  cols <- grep("mother_interferes_work[0-9]{1}", names(dat))
  print(paste0("mother_interferes_work :",
               round(psych::alpha(dat[cols])$total$std.alpha, 2)))
  # work interferes mother - 0.951 - excellent
  cols <- grep("work_interferes_mother[0-9]{1}", names(dat))
  print(paste0("work_interferes_mother :",
               round(psych::alpha(dat[cols])$total$std.alpha, 2)))
}

two_sample_t <- function(v, group, dat, alpha = 0.05, print_out = FALSE, ...) {
  s <- v
  if ((is.numeric(dat[[v]][1L]) |
       is.logical(dat[[v]][1L])) & v != group) {
    d <- t.test(dat[[v]] ~ dat[[group]],...)
    if(d$p.value >= alpha) {
      s= NULL
    } else {
      if(print_out) {
        print(paste("group by", group, "testing variable", v, sep = " "))
        print(d)
      }
    }
  } else { s = NULL }
  s
}

Chi_squared_test <- function(dat, v, v_other, alpha = 0.05) {
  message(paste("Chi-squared test for", v, ": alpha = ", alpha,sep=""))
  stopifnot(c(v, v_other) %in% names(dat))
  for(i in v_other) {
    d = table(dat[[v]], dat[[i]])
    e = summary(d)
    if(e$p.value < alpha) {
      print(i)
    }
  }
}

content_anlaysis <- function(dat) {
  ## content analysis
  ## read code book
  code <- read.csv("data/motherhood_code_book.csv", stringsAsFactors = FALSE)
  code$code <- tolower(code$code)
  code$code_short <- tolower(code$code_short)
  dat$motherhood_definition_translation <- tolower(dat$motherhood_definition_translation)
  
  code$code_count <- 0L
  # frequency of codes
  for(i in seq_along(code$code)) {
    code$code_count[i] <- sum(grepl(code$code_short[i], dat$motherhood_definition_translation, fixed = TRUE))
  }
  code <- code[order(code$code_type, -code$code_count), ]
  write.csv(code, "output/motherhood_code_book_with frequency.csv", row.names = FALSE)
  # motherhood types
  # modern, mix, traditional, unknown
  dat$motherhood_type <- NA
  for(i in seq_along(dat$motherhood_definition_translation)) {
    ## count trandtional 
    t <- 0L
    for(j in code$code_short[code$code_type == "traditional"]) {
      if(grepl(j, dat$motherhood_definition_translation[i])) {
        t <- t + 1
      }
    }
    ## count modern
    m <- 0L
    for(j in code$code_short[code$code_type == "modern"]) {
      if(grepl(j, dat$motherhood_definition_translation[i])) {
        m <- m + 1
      }
    }
    
    if( t * m > 0) {
      dat$motherhood_type[i] <- "mixed"
    } else if (t == 0 & m == 0) {
      dat$motherhood_type[i] <- "unknown"
    } else if (t == 0) {
      dat$motherhood_type[i] <- "modern"
    } else if (m == 0) {
      dat$motherhood_type[i] <- "traditional"
    }
  }
  dat
}

y_motherhood_type <- function(dat, model_variable) {
  message("Analysing the association between motherhood_type and covariates... ...")
  d <- dat[model_variable]
  d <- d[!is.na(d$mother_birth_order) & d$other_household2 != "", ]
  d <- d[d$motherhood_type != "unknown",]
  d$mother_birth_order[d$mother_birth_order > 6] <- 6
  d$occupation_type <- d$occupation_type %in% c("white")
  d$other_household2 <- d$other_household2 == "no"
  d$motherhood_type[d$motherhood_type == "traditional"] <- 0
  d$motherhood_type[d$motherhood_type == "mixed"] <- 0.5
  d$motherhood_type[d$motherhood_type == "modern"] <- 1
  d$motherhood_type <- as.numeric(d$motherhood_type)
  for(v in names(d)) {
    if (all(is.logical(d[[v]]))) {
      d[[v]] <- as.integer(d[[v]])
    }
  }
  cor_matrix = cor(d)
  cor_matrix = as.data.frame(cor_matrix)
  for(i in seq_along(cor_matrix[[1]])) { 
    for(j in seq_along(cor_matrix[[1]])) {
      cor_matrix[i,j] = round(as.numeric(cor_matrix[i,j]), 2)
    }
  }
  for(i in seq_along(cor_matrix[[1]])) { 
    for(j in seq_along(cor_matrix[[1]])) {
      if(j > i) {cor_matrix[i,j] = "*"}
    }
  }
  print(cor_matrix)
  # find the following model
  message(paste("The model is:", 
                "motherhood_type ~ education + education * mother_birth_order 
                + has_son + other_household2",
                "WHERE motherhood_type = {0: traditional; 0.5: mixed; 1: modern}",
                "unknown motherhood is removed from data",
                "education = {1:high schoold or lower; 2: 3-year college; 3: 4-year uni or above}",
                "other_household2 = {1: no; 2: live with parents(inlaw) or other relatives}", sep="\n"))
  a = glm(motherhood_type ~  education / mother_birth_order + 
            has_son +
            other_household2 - 1,
          data = d, gaussian(link='identity'))
  print(summary(a))
  return(a)
}

con_pro_2nd_child <- function (dat0, model_variable) {
  ## mothers' concerns
  dat <- sub_scale(dat0, coding, remove = FALSE)
  Chi_squared_test(dat, "con_2nd_child", model_variable, alpha = 0.05)
  Chi_squared_test(dat, "pro_2nd_child", model_variable, alpha = 0.05)
  message("In con_2nd_child: No. of mothers who agree / No. of mothers who disagree")
  j <- c(29:34)
  for(i in j) {
    e <- sum(dat[[i]] > 3) / sum(dat[[i]] < 3)
    if(e >= 1) {
      print(names(dat)[i]);
      print(e)
    }
  }
  message("In pro_2nd_child: No. of mothers who agree / No. of mothers who disagree")
  j <- c(36:41)
  for(i in j) {
    e <- sum(dat[[i]] > 3) / sum(dat[[i]] < 3)
    if(e >= 1) {
      print(names(dat)[i]);
      print(e)
    }
  }
}