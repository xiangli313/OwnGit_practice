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
    code$code_count[i] <- sum(grepl(code$code_short[i], dat$motherhood_definition_translation))
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

