library(tidyverse)

setwd("~/Dropbox/RES-WC-Data/report/data-steffie")

# # HESA student data.
# student_data <- read_csv("~/Dropbox/RES-WC-Data/report/gender-report/0-data/149756_Item1_1213to1516_Data.csv") %>%
#   bind_rows(read_csv("~/Dropbox/RES-WC-Data/report/gender-report/0-data/149756_Item1_1617to1819_Data.csv"))
#
# econ_students <- student_data %>%
#   filter(F_XJACSA01=="L1") %>% # Include only students studying economics (L1).
#   filter(F_SEXID!=3) %>% # Exclude students whose gender is classified as "Other" (3).
#   filter(F_XLEV601!=3 & F_XLEV601!=5) %>% # Exclude students who are studying on a non-first-degree undergraduate programme or a non-Masters or non-PhD postgraduate programme.
#   filter(F_XMODE301==1) %>% # Include only full-time students (1).
#   mutate(
#     ACYEAR = as.numeric(str_sub(ACYEAR, 1, 4)),
#     F_XLEV601 = recode(F_XLEV601, `4`="First degree"),
#     F_SEXID = recode(F_SEXID, `1`="Male", `2`="Female"),
#     F_XDOMGR401 = recode(F_XDOMGR401, `1`="UK", `2`="EU", `3`="Other", `9`="Unknown"),
#     F_NATION = recode(F_NATION, "Other EU"="EU", "Non-EU"="Other"),
#     F_ZSTATE_MARKER = recode(F_ZSTATE_MARKER, `1`="State-funded", `0`="Privately funded", U="Unknown"),
#     ECONMKR = recode(ECONMKR, ECONALEV="Econ A-level", NOECONALEV="No econ A-level"),
#     Ethnicity = recode(Ethnicity, UNK="Unknown", `21`="Black", `22`="Black", `29`="Black", `31`="South Asia", `32`="South Asia", `33`="South Asia", `34`="Other Asia", `39`="Other Asia", Mixed="Other"),
#     BME_MKR = recode(BME_MKR, `Unknown/Not applicable`="Unknown")
#   ) %>%
#   mutate(
#     F_XLEV601 = factor(F_XLEV601, levels=c("First degree", "Masters", "Doctorate"), ordered=TRUE),
#     F_XDOMGR401 = factor(F_XDOMGR401, levels=c("UK", "EU", "Other"), ordered=TRUE),
#     F_NATION = factor(F_NATION, levels=c("UK", "EU", "Other"), ordered=TRUE),
#     Ethnicity = factor(Ethnicity, levels=c("White", "Black", "South Asia", "Other Asia", "Other"), ordered=TRUE)
#   )
#
# # Data for level of study graph
# levels_time <- econ_students %>%
#   group_by(ACYEAR, F_XLEV601, F_SEXID) %>%
#   count(wt=counter) %>%
#   group_by(ACYEAR, F_XLEV601) %>%
#   mutate(percent_fem=100*n/sum(n)) %>%
#   group_by(ACYEAR, F_SEXID) %>%
#   mutate(percent_dist=100*n/sum(n))
# write_csv(levels_time, "levels_time.csv")
#
# # Data for BME level of study graph
# bme_level <- econ_students %>%
#   filter(BME_MKR!="Unknown") %>%
#   group_by(ACYEAR, F_SEXID, F_XLEV601, BME_MKR) %>%
#   count(wt=counter) %>%
#   group_by(ACYEAR, F_XLEV601, BME_MKR) %>%
#   mutate(percent_fem=100*n/sum(n))
# write_csv(bme_level, "bme_level.csv")

# Level of study graph
levels_time <- read_csv("levels_time.csv") %>%
  mutate(F_XLEV601 = factor(F_XLEV601, levels=c("First degree", "Masters", "Doctorate"), ordered=TRUE))
levels_time.plot <- levels_time %>%
  filter(F_SEXID=="Female") %>%
  ggplot(., aes(x=ACYEAR, y=percent_fem, linetype=factor(F_XLEV601))) +
  geom_line() +
  labs(x=NULL, y="%", title="% women, by level of study") +
  scale_linetype_manual(values=c("solid", "dashed", "dotted"))

# BME level of study graph
bme_level <- read_csv("bme_level.csv") %>%
  mutate(F_XLEV601 = factor(F_XLEV601, levels=c("First degree", "Masters", "Doctorate"), ordered=TRUE))
bme_level.plot <- bme_level %>%
  filter(F_SEXID=="Female") %>%
  ggplot(., aes(x=ACYEAR, y=percent_fem, linetype=factor(BME_MKR))) +
  geom_line() +
  facet_wrap(vars(F_XLEV601)) +
  labs(x=NULL, y="%", title="% women, by BME and level of study") +
  ylim(24,40) +
  theme(panel.spacing.x=unit(4, "mm"))

# Combine graphs
ggarrange(levels_time.plot, bme_level.plot, legend="bottom")
ggsave("level_bme.png", width=8, height=3, dpi=600)
