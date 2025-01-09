# library(dplyr)
library(sqldf)
library(stRoke)
library(writexl)

# 基础数据文件信息
ppmi_home <- "/Users/hanhui02/workspace/r_scripts/ppmi/"
original_data_dir <- paste0(ppmi_home, "ppmi_original_data/")
data_dir <- paste0(ppmi_home, "ppmi_data/")
pase_household_file <- paste0(original_data_dir, "PASE_-_Household_Activity-Archived_02Dec2024.csv")
pase_leisure_file <- paste0(original_data_dir, "PASE_-_Leisure_Time_Activity-Archived_02Dec2024.csv")

ppmi_pase_file <- paste0(data_dir, "ppmi_pase.xlsx")

# 加载数据
pase_household <- read.csv(pase_household_file)
pase_leisure <- read.csv(pase_leisure_file)

# 得分信息
sql_pase_leisure <- "
SELECT pl.patno,
       pl.event_id,
       SUM(CASE
             WHEN pl.questno = 1 THEN
              pl.actvoft
           END) pase01,
       SUM(CASE
             WHEN pl.questno = 1 THEN
              pl.hrdayfrq
           END) pase01b,
       SUM(CASE
             WHEN pl.questno = 2 THEN
              pl.actvoft
           END) pase02,
       SUM(CASE
             WHEN pl.questno = 2 THEN
              pl.hrdayfrq
           END) pase02b,
       SUM(CASE
             WHEN pl.questno = 3 THEN
              pl.actvoft
           END) pase03,
       SUM(CASE
             WHEN pl.questno = 3 THEN
              pl.hrdayfrq
           END) pase03b,
       SUM(CASE
             WHEN pl.questno = 4 THEN
              pl.actvoft
           END) pase04,
       SUM(CASE
             WHEN pl.questno = 4 THEN
              pl.hrdayfrq
           END) pase04b,
       SUM(CASE
             WHEN pl.questno = 5 THEN
              pl.actvoft
           END) pase05,
       SUM(CASE
             WHEN pl.questno = 5 THEN
              pl.hrdayfrq
           END) pase05b,
       SUM(CASE
             WHEN pl.questno = 6 THEN
              pl.actvoft
           END) pase06,
       SUM(CASE
             WHEN pl.questno = 6 THEN
              pl.hrdayfrq
           END) pase06b
  FROM pase_leisure pl
 WHERE pl.pag_name = 'PASE'
   AND pl.f_status = 'S'
 GROUP BY pl.patno, pl.event_id
"

pase_leisure_quest <-sqldf(sql_pase_leisure)

sql_ppmi <- "
SELECT h.patno,
       h.event_id,
       l.pase01,
       l.pase01b,
       l.pase02,
       l.pase02b,
       l.pase03,
       l.pase03b,
       l.pase04,
       l.pase04b,
       l.pase05,
       l.pase05b,
       l.pase06,
       l.pase06b,
       h.lthswrk  pase07,
       h.hvyhswrk pase08,
       h.hmrepr   pase09a,
       h.lawnwrk  pase09b,
       h.outgardn pase09c,
       h.caregvr  pase09d,
       h.wrkvl    pase10,
       h.wrkvlhr  pase10a,
       h.wrkvlact pase10b
  FROM pase_household h
  JOIN pase_leisure_quest l
    ON (h.patno = l.patno AND h.event_id = l.event_id)
 WHERE h.f_status = 'S'
   AND h.pag_name = 'PASE'

"
pase_quest <- sqldf(sql_ppmi)

pase_quest_data <- pase_quest[c(seq(3, 23))]

# 计算得分，计算2个口径。adjwork=TRUE时，如果10b工作主要是坐着，则分数直接改成0
pase_score_adjwork <- stRoke::pase_calc(pase_quest_data, adjust_work = TRUE)
pase_score <- stRoke::pase_calc(pase_quest_data, adjust_work = FALSE)

ppmi_pase <- cbind(pase_quest, pase_score_adjwork)

write_xlsx(ppmi_pase, path = ppmi_pase_file)

