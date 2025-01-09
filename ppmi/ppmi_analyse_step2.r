library(tidyverse)
library(plyr)
library(gtsummary)
library(lubridate)
library(lme4)
library(MatchIt)
library(tableone)
library(spearmanCI)
library(stringr)
library(Amelia)
library(readxl)
library(sqldf)

ppmi_home <- "/Users/hanhui02/workspace/r_scripts/ppmi/"
data_dir <- paste0(ppmi_home, "ppmi_data/")
ppmi_basic_file <- paste0(data_dir, "ppmi_v20250109.xlsx")


basic_data <- read_excel(ppmi_basic_file)

sql <- "
select b.diff_years,b.age_at_visit,b.sex,b.pase_score_sum
from basic_data b
where b.cohort = 1
"

basic_data <- sqldf(sql)


basic_data %>% tbl_summary(
  by = `diff_years`, 
  type = list(
    `pase_score_sum` ~ "continuous",
    `age_at_visit` ~ "continuous"
  )
) %>% add_p()