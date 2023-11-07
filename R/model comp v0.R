
setwd("I:\\Il mio Drive\\Esperimenti\\01 math anxiety\\task\\data")

library("readxl")
library("dplyr")
library("ggplot2")
library("Pupilla")

files= list.files(path = paste0(getwd(), "\\pp_data"),
                  pattern = ".RDS")


ET= {}

for (i in files){
  temp= readRDS(paste0(getwd(), "\\pp_data\\", i))

  ET= rbind(ET, temp)
}

table(ET$Subject)

#pcs to divide in low/high anxiety
PCs= readRDS("Quest_pp.RData")

#omit outliers?
omit_outliers= FALSE


if(omit_outliers){

  omit_ids= PCs$ID[PCs$ACC<0.5]

  PCs= PCs[!PCs$ID %in% omit_ids,]
  ET= ET[!ET$Subject %in% omit_ids,]
  ET$Subject= as.factor(ET$Subject)
  #length(levels(ET$Subject))

}


ET=
  ET %>%
  #riallinea tempo
  #separatamente per prima e seconda fase???
  mutate(Part= ifelse(Event %in% c("feedback",
                                   "post_resp_fix",
                                   "Wait_Feedback"), 2, 1)) %>%
  group_by(Subject, Part, trial) %>%
  mutate(Time= ifelse(Part== 1,
                      Time - Time[Event== "cue"][1],
                      Time - Time[Event== "Wait_Feedback"][1] + 20000))

#realign second part, set to 20000
ET= ET %>%
  #sottrai baseline
  group_by(Subject, trial) %>%
  mutate(Pupil= Pupil - mean(Pupil[Event== "fixation"]))


#now polish
legit_time= c(seq(25, 18000, 25), seq(20025, 28000, 25))

ET= ET %>% filter(Time %in% legit_time)

# #resort!
ET= ET %>%
  arrange(Subject, trial, Time) %>%
  group_by(Subject, trial, Time, Cue, Accuracy) %>%
  summarise(Pupil= mean(Pupil))

# #resort!
ET= ET %>%
  arrange(Subject, trial, Time) %>%
  group_by(Subject, trial, Time, Cue, Accuracy) %>%
  summarise(Pupil= mean(Pupil))


ET$AMAS= NA
amas= c(scale(PCs$AMAS))
names(amas)= PCs$ID
ET$AMAS= amas[as.character(ET$Subject)]
summary(ET$AMAS)

acc= c(scale(PCs$ACC))
names(acc)= PCs$ID
ET$Accuracy= acc[as.character(ET$Subject)]

lat= c(scale(PCs$Latency))
names(lat)= PCs$ID
ET$Latency= lat[as.character(ET$Subject)]

stai= scale(PCs$STAI)
names(stai)= PCs$ID
ET$STAI= stai[as.character(ET$Subject)]

tai= scale(PCs$TAI)
names(tai)= PCs$ID
ET$TAI= tai[as.character(ET$Subject)]

pmp= scale(PCs$PMP)
names(pmp)= PCs$ID
ET$PMP= pmp[as.character(ET$Subject)]

library("lme4")

res= list()

for (i in legit_time){

  DFtemp= ET[ET$Time== i,]

  mod0= lme4::lmer(Pupil ~  Cue + AMAS + (1|Subject),
                   data= DFtemp, REML= F)

  mod1= lme4::lmer(Pupil ~  Cue*AMAS + (1|Subject),
                   data= DFtemp, REML= F)

  res[[i]]= anova(mod0, mod1)

}

AIC= unlist(sapply(res, function(x)c(diff(x$AIC)*-1)))


p= unlist(sapply(res, function(x)x$`Pr(>Chisq)`[2]))

legit_time[which.min(p)]

legit_time[which.max(abs(AIC))]

plot(x = legit_time, y= p)
