library(tidyverse)


##### MAKING A BLANK DATASET #######


# create patient characteristics
set.seed(007)
patient_characteristics <- data.frame(
  ID    = seq(1,900),
  DOSE  = c(rep(300,300),rep(600,300),rep(900,300)),
  BW    = rnorm(900, 60, 8),
  SEX   = sample(c(0,1),900,replace=T),
  HIV   = sample(c(0,1),900,prob=c(0.8,0.2),replace=T)
  )

# visualize patient characteristics
hist(patient_characteristics$BW)
hist(patient_characteristics$HIV)

table(patient_characteristics$SEX )
table(patient_characteristics$HIV )
table(patient_characteristics$DOSE, patient_characteristics$HIV)

# create blank observation rows (EVID==0) for each patient (6 obs per patient at 1,2,4,8,12,24 hours post-dose)
df <- data.frame(ID    = rep(seq(1,900),6),
                 TIME  = c(rep(1,900),rep(2,900),
                           rep(4,900),rep(8,900),
                           rep(12,900),rep(24,900)),
                 DV    = 0,
                 EVID  = 0,
                 MDV   = 0
                ) %>% 
      arrange(ID,TIME)

# create dosing rows (EVID==1) for each patient
dosing_df <- data.frame(ID    = seq(1,900),
                 TIME  = 0,
                 DV    = 0,
                 EVID  = 1,
                 MDV   = 1
) %>% 
  arrange(ID,TIME)

# rbind obs df and dosing df
blank_df <- rbind(dosing_df,df) %>% 
  arrange(ID,TIME)

# join with patient char data
joined_df <- left_join(blank_df,patient_characteristics, by="ID") %>%
  mutate(AMT = case_when(EVID == 0 ~ 0,
                         EVID == 1 ~ DOSE)
         )

# write-out 
# write.table(joined_df, "simulation_df.csv",
#            append =F, sep=",", na=".",row.names = F,col.names = T, quote = F)


