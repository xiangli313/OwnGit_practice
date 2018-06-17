read_dat <- function(src, coding) {
  dat <- read.csv(src, stringsAsFactors = FALSE, header = FALSE)
  names(dat) <- dat[1, ]
  dat <- dat[-1, ]
  
  invisible(
    for (i in names(dat)) { 
      j <- grepl("^[0-9]${1}", dat[[paste0(i)]])
      if(all(j)) {
        dat[[paste0(i)]] <- as.integer(dat[[paste0(i)]])
      }
    })
  
  # rename column
  #dat <- dat[, -which(names(dat) == "NA")]
  i <- match(names(dat), coding$chinese) 
  if(any(is.na(i))) {
    stop("Have you modified your survey questions?")
  }
  names(dat) <- coding$q_sub_id
  dat$id <- as.integer(dat$id)
  dat
}

tran_other <- function(dat) {
  ## q1
  i <- dat$join == "A.愿意"
  dat$join <- i
  
  ## q2
  i <- dat$gender == "A.女性"
  dat$gender[i] <- "F"
  dat$gender[!i] <- "M"
  
  # q4 and q21
  q <- grep("birth_order[0-9]{1}", names(dat))
  for(i in q) {
    j <- grepl("^A.男$", dat[, i])
    dat[j, i] <- "M"
    j <- grepl("^B.女$", dat[, i])
    dat[j, i] <- "F"
  }
  ## correct first two sample
  j <- dat$id %in% 1:2
  dat$kid_birth_order2[j] <- ""
  dat$kid_birth_order3[j] <- ""
  dat$kid_birth_order4[j] <- ""
  dat$kid_birth_order5[j] <- ""
  # q8, 24, 26
  q <- c(grep("_2_child", names(dat)),
         grep("education", names(dat)),
         grep("income", names(dat)))
  for(i in q) {
    j <- grepl("^[A-Z]{1}.", dat[, i])
    dat[j, i] <- substr(dat[j, i], 1, 1)
  }
  
  # 22 birth order of mother
  i <- grepl("^[1-9]{1}", dat$mother_birth_order)
  dat$mother_birth_order[i] <- substr(dat$mother_birth_order[i], 1, 1)
  i <- grepl("^，，[1-9]{1}", dat$mother_birth_order)
  dat$mother_birth_order[i] <- substr(dat$mother_birth_order[i], 3, 3)
  i <- grepl("三$", dat$mother_birth_order)
  dat$mother_birth_order[i] <- 3L
  i <- is.na(dat$mother_birth_order) & is.na(dat$birth_order2)
  dat$mother_birth_order[i] <- 1L
  dat$mother_birth_order <- as.integer(dat$mother_birth_order)
  
  ## mother has brothers
  i <- grep("^birth_order[0-9]{1}", names(dat))
  for(j in i) {
    k <- dat[[j]] == "M"
    dat$has_brothers[k] <- TRUE
  }
  dat$has_brothers[is.na(dat$has_brothers)] <- FALSE
  ## mother as the only child
  dat$only_child <- !(dat$birth_order2 %in% c("M", "F"))
  
  ### remove duplications
  i <- duplicated(dat$contact[dat$contact != ""])
  dat <- rbind(dat[dat$contact != "", ][!i, ],
               dat[dat$contact == "", ])
  message(sum(i), " people participated more than once. Removed")
  
  ### remove Male and disagree samples
  dat <- dat[dat$join & dat$gender == "F", ]
  ##
  dat$one_child <- dat$kid_birth_order2 == ""
  dat$self_2_child <- dat$self_2_child != ""
  dat$husband_2_child <- dat$husband_2_child != ""
  dat$parents_2_child <- dat$parents_2_child != ""
  dat$inlaws_2_child <- dat$inlaws_2_child != ""
  dat$child_2_child <- dat$child_2_child != ""
  
  dat$young_mother <- is.finite(dat$age) & dat$age <= 36
  dat$education[dat$education == "A"] <- 1L
  dat$education[dat$education == "B"] <- 2L
  dat$education[dat$education %in% c("C","D")] <- 3L
  dat$education <- as.integer(dat$education)
  
  dat$income[dat$income == "A"] <- 1L
  dat$income[dat$income == "B"] <- 2L
  dat$income[dat$income %in% c("C","D")] <- 3L
  dat$income <- as.integer(dat$income)
  
  dat$start_time <- NULL
  dat$end_time <- NULL
  dat$research_note <- NULL
  dat$dob <- NULL
  dat$year <- NULL
  dat$month <- NULL
  dat$age <-NULL
  
  dat
}

tran_age <- function(dat) {
  ## q3
  dat$year <- NA
  i <- grepl("^19[0-9]{2}", dat$dob) # year
  dat$year[i] <- substr(dat$dob[i], 1, 4)
  i <- grepl("^13[0-9]{2}", dat$dob) # year
  dat$year[i] <- paste0(19,substr(dat$dob[i], 3, 4))
  i <- grepl("^[0-9]{3}o", dat$dob) # year
  dat$year[i] <- paste0(substr(dat$dob[i], 1, 3), 0)
  dat$year <- as.integer(dat$year)
  if(any(is.na(dat$year) & dat$dob != "")) {
    stop("still types of year not identified")
  }
  
  dat$month <- NA
  i <- grepl("^[0-9]{4}年[0-9]{1}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 6, 6)
  i <- grepl("^[0-9]{4}年[0-9]{2}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 6, 7)
  i <- grepl("^[0-9]{3}o年[0-9]{2}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 6, 7)
  i <- grepl("^[0-9]{4}.[0-9]{1}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 6, 6)
  i <- grepl("^[0-9]{4}.[0-9]{2}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 6, 7)
  i <- grepl("^[0-9]{5}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 5, 5)
  i <- grepl("^[0-9]{6}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 5, 6)
  ## specials cases
  i <- grepl("^[0-9]{4} 年[0-9]{1}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 7, 7)
  i <- grepl("^[0-9]{4}年了[0-9]{1}", dat$dob) # year
  dat$month[i] <- substr(dat$dob[i], 7, 7)
  
  dat$month <- as.integer(dat$month)
  i <- is.finite(dat$month) & dat$month > 12
  dat$month[i] <- as.integer(dat$month[i]/10)
  
  # age
  dat$age <- 2018 - dat$year
  i <- is.finite(dat$month) & dat$month < 6
  dat$age[i] <- dat$age[i] - 1
  
  ##
  dat
}

sub_scale <- function(dat, coding, remove = TRUE) {
  ### sub-scale
  sub_scales <- coding[coding$is_subscalse, ]
  scl <- unique(sub_scales$q_id)
  for(i in scl) {
    v <- sub_scales[sub_scales$q_id == i, ]
    cols <- v$q_sub_id
    s <- dat[cols]
    dat[[paste0(i)]] <- rowMeans(s)
    j <- match(cols, names(dat))
    if (remove) {
      dat <- dat[-j]
    }
  }
  dat
}