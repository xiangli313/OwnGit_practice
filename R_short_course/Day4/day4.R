rm(list=ls())

https://www.jumpingrivers.training/rstudio/
username:user5
password:user5

## distinct <- sth similar to unique in R
sql <- "select distinct color,cut from diamonds"
sql <- "select distinct clarity from diamonds"
a = dbGetQuery(con, sql)

sql <- "select distinct mpaa from movies"
a = dbGetQuery(con, sql)

# diltering
I used 'where', 'and', 'or';
there is also 'not'.

# oattern matching - cool
select * from table
where column like 'pattern'

pattern% - all those start with pattern
%pattern - all those end with pattern

# ordering 
order by column desc # decreasing , default is increasing


########################################
rm(list = ls())
##### morning session
browseVignettes("jRsql")
vignette("practical1", package = "jRsql")

vignette("practical2", package = "jRsql")

library("RPostgreSQL")
library("DBI")

drv = dbDriver("PostgreSQL")
user = "user5"
pass = "user5"
dbname = "user5"
con = dbConnect(drv, dbname = dbname,
                #host = "localhost", port = 5432,
                user = user, password = pass)

dbListTables(con)
\dt # = dbListTables(con)
\ds # get an idea of what's in the database
ctrl + d -> quit psql

dbListFields(con, "diamonds")

#### read column(s) in a table
# 1
dbGetQuery(con, "select * from diamonds limit 3")
# 2
sql <- "select * from diamonds limit 3"
dbGetQuery(con, sql)
# 3 in psql - semi-column is needed indicating the end of a statement
select * from diamonds limit 3;


sql1<-"
select * from diamonds
"

sql2<-"
select * from movies
"
diamonds <- dbGetQuery(con, sql1)
head(diamonds)
movies <- dbGetQuery(con, sql2)
head(movies)


## distinct <- sth similar to unique in R
sql <- "select distinct color,cut from diamonds"
sql <- "select distinct clarity from diamonds"
a = dbGetQuery(con, sql)

sql <- "select distinct mpaa from movies"
a = dbGetQuery(con, sql)


sql <- "select * from movies
where rating > 9
and year = 1994"
a = dbGetQuery(con, sql)


# pattern matching - case sensitive
sql <- "select * from movies
where title like 'Se_en'"
a = dbGetQuery(con, sql)

sql <- "select * from movies
where title like 'green'"
a = dbGetQuery(con, sql)

sql <- "select * from movies
where title like '____'"
a = dbGetQuery(con, sql)


sql <- "select * from movies
order by rating desc, length limit 10" # order by rating descreasing and length increasing
dbGetQuery(con, sql)

sql <- "select * from movies
where year >1987
order by rating desc limit 3" 
a = dbGetQuery(con, sql)


sql <- "select * from diamonds
where carat > 1
and (color = 'D' or color = 'E' or color = 'F')
order by price limit 3" 
dbGetQuery(con, sql)

sql <- "select * from diamonds
where carat > 1
and color between 'D' and 'F'
order by price limit 3" 
dbGetQuery(con, sql)

# this one not finished yet
sql = "select * from diamonds
where carat > 1
and color in ('D','F')
order by price limit 3"
dbGetQuery(con, sql)


# delete table
dbExecute(con, "drop table xl")
dbListTables(con)

# create table
sql <- "
create table xl (id integer, name text, date_of_birth date)
"
dbExecute(con, sql)

dbListTables(con)

# populate table
sql <- " insert into 
xl (id, name, date_of_birth) 
values (1,'xl', '2000-01-01')"
dbExecute(con, sql)

dbReadTable(con, "xl")

sql <- " insert into 
xl (id, name, date_of_birth) 
values 
(2,'lc', '2000-01-02'),
(3,'mz', '2000-01-03')
"
dbExecute(con, sql)

dbReadTable(con, "xl")

# modify table
sql <- " update xl 
set name = 'Mz'
where id = 3
"
dbExecute(con, sql)

dbReadTable(con, "xl")

# add new column
sql <- " alter table xl 
add column gender text
"
dbExecute(con, sql)

dbReadTable(con, "xl")
####( delete is row-wise and drop is column-wise)


## task
#1 add new column
sql<-"
alter table movies
add column mpaa_new text"
dbExecute(con, sql)
#2.1 populate with mpaa
sql <- "
update movies 
set mpaa_new = mpaa
"
dbExecute(con, sql)
#2.2 modify column
sql <- "
update movies 
set mpaa_new = 'no label'
where mpaa = ''"
dbExecute(con, sql)
#3. delete mpaa
sql<-"
alter table movies
drop column mpaa "
dbExecute(con, sql)
dbGetQuery(con, "select distinct * from movies limit 3")
#4 rename newly created column to mpaa
sql<-"
alter table movies
rename mpaa_new to mpaa"
dbExecute(con, sql)

movies <- dbGetQuery(con, "select * from movies")


## pracrical 1
dbExecute(con, "drop table fuel_economy")
dbListTables(con)

sql<-"create table fuel_economy
(ID integer,
EngDispl double precision,
NumCyl integer,
Transmission char(2),
FE double precision)"
dbExecute(con, sql)
dbListTables(con)
dbListFields(con, "fuel_economy")

dbGetQuery(con, "select * from fuel_economy")
ID <- c(1381, 1499, 1722, 2091, 1310, 2079)
EngDispl <- c(2.0, 3.6, 2.5, 5.7, 1.8, 7.0)
Numcyl <- c(4, 6, 4, 8, 4, 6)
Transmission <- c("M5", "S6", "S4", "A5", "A4", "A6")
FE <- c(46.4387, 40.0000, 32.9103, 26.0000, 47.2000, 36.0000)
datain <- data.frame(id = ID, engdispl = EngDispl, numcyl = Numcyl, transmission = Transmission, fe=FE, row.names = NULL)
names(datain)
dbWriteTable(con, "fuel_economy", datain, append = TRUE , row.names=FALSE)

sql <- "
update fuel_economy
set engdispl = 3.5
where id = 2079"
dbExecute(con, sql)

sql<- "alter table fuel_economy
add column gearbox text"
dbExecute(con, sql)

dbReadTable(con, "fuel_economy")


drv = dbDriver("PostgreSQL")
#drv = RSQLite::SQLite()
user = "user5"
pass = "user5"
dbname = "user5"
con = dbConnect(drv, dbname = dbname,
                #host = "localhost", port = 5432,
                user = user, password = pass)
dbBegin(con)
dbRollback(con)
dbListTables(con)

dbWithTransaction(
  con, 
  {
    dbExecute(con, "UPDATE fuel_economy SET gearbox = 'manual' WHERE customer LIKE '%M';")
    dbExecute(con, "UPDATE fuel_economy SET gearbox = 'sequential' WHERE customer LIKE '%S';")
    dbExecute(con, "UPDATE fuel_economy SET gearbox = 'automatic' WHERE customer LIKE '%A';")
  }
)


#### afternoon session
library("dplyr")
data(movies, package = "ggplot2movies")
#movies = dbGetQuery(con, "select * from movies")

sub = filter(movies, rating > 9 )

sub = group_by(movies, mpaa)

summarise(movies, mean(rating))

summarise(movies, mean(rating), sd(rating))

## the piping operator %>% - pass to the next line as the first argument

#eg:
  1:5 %>%
    sum(na.rm = TRUE)

  movies %>%
  filter(rating >9) %>%
    summarise(mean(rating), sd(rating))

  movies %>%
    group_by(mpaa) %>% ## can pass in multiple grouping criteria
      summarise(mean(rating), sd(rating)) %>%
    ungroup(mpaa)
  
  
  ### a tip
  package :: shows/uses packages in the package
    package ::: shows/uses also hidden functions in the package
    
    
    
    
    
    
    
    
    rm(list = ls())
    ##### morning session
    browseVignettes("jRsql")
    vignette("practical1", package = "jRsql")
    
    vignette("practical2", package = "jRsql")
    
    #### afternoon session -2 - interact dplyr with db
    library("dplyr")
    user = "user5"
    pass = "user5"
    dbname = "user5"
    dcon = src_postgres( dbname = dbname,
                         #host = "localhost", port = 5432,
                         user = user, password = pass)
    
    
    db_diamonds = tbl(dcon, "diamonds") # the actual data is not yet pulled into local memory
    # to pull the data into R
    db_diamonds %>%
      collect()
    ### the good thing here is that you can do all things before pull the data into R
    ### it is faster when data size is large
    ### because before collecting, only a few rows of your data are operated
    ### basiclly before collecting R was constructing a QUERY
    
    library(nycflights13)
    # airlines = nycflights13::airlines
    # airports = nycflights13::airports
    # flights = nycflights13::flights
    # planes = nycflights13::planes
    # weather = nycflights13::weather
    
    drv = dbDriver("PostgreSQL")
    user = "user5"
    pass = "user5"
    dbname = "user5"
    con = dbConnect(drv, dbname = dbname,
                    #host = "localhost", port = 5432,
                    user = user, password = pass)
    
    dbWriteTable(dcon, "airlines",airlines,overwrite = TRUE, row.names = FALSE)
    
    dbWriteTable(con,"airports",airports, overwrite = TRUE, row.names = FALSE)
    
    dbWriteTable(con, "flights", flights, overwrite = TRUE, row.names = FALSE)
    
    dbWriteTable(con, "planes", planes, overwrite = TRUE, row.names = FALSE)
    
    dbWriteTable(con, "weather", weather, overwrite = TRUE, row.names = FALSE)
    
    dbListTables(con)
    
    # equivelence between sql and dplyr
    a = dbGetQuery(con, "select * from flights 
                   left join airlines
                   using (carrier)") # with using, the sql only returns one column for carrier, rather than keep two columns
    
    a = dbGetQuery(con, "select * from flights 
                   full join airlines
                   on flights.carrier = airlines.carrier") # on is more capable when names of the joining column are different
    
    flights %>%
      left_join(airlines) %>%
      count()
    
    flights %>%
      full_join(airlines) %>%
      show_query()
    
    # practice
    #1.
    df <- flights %>%
      left_join(airports, by = c("dest" = "faa")) 
    #3.
    df2 <- df %>%
      group_by(lat, lon) %>%
      summarise(mean_arr_deley = mean(arr_delay, na.rm = TRUE))
    print(df2)
    
    #4.
    df3 <- df2 %>%
      filter(!is.na(mean_arr_deley))
    print(df3)
    #5.
    library(leaflet) # load mapping library
    pal = colorNumeric("YlOrRd",domain = df3$mean_arr_deley) # set up a colour palette
    df3 %>% 
      left_join(airports) %>% # join to get names again
      collect %>% # collect to pull all the data into R
      leaflet %>% # base map
      # add some markers for the airports
      addCircleMarkers(~lon,~lat,color = ~pal(mean_arr_deley),label = ~paste0(name," : ",mean_arr_deley), fillOpacity = 0.8) %>% 
      addTiles # add background map
    
    # 6.
    df <- flights %>%
      left_join(airlines) %>%
      group_by(name) %>%
      summarise(mean(dep_delay, na.rm = TRUE))
    print(df)
    
    # 7.
    df <- flights %>%
      left_join(planes) %>%
      group_by(manufacturer) 
    
    df2 <- df %>%
      summarise(sum(flight, na.rm = TRUE))
    #8. 
    df3 <- flights %>%
      left_join(planes) %>%
      group_by(year, month, day) %>%
      summarise(no_pass = sum(seats, na.rm = TRUE)) %>%
      filter( !is.na(no_pass))%>%
      arrange(desc(no_pass))
    print(df3[1,])
    
    # join (sql) = inner_join (dplyr)
    # left join
    # right join
    # full join