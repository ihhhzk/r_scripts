# 首次使用需要安装所需的包
# install.packages("stRoke")
# install.packages("readxl")
# install.packages("writexl")

library(stRoke)
library(readxl)
library(writexl)


# stRoke文档
# https://agdamsbo.github.io/stRoke/reference/pase_calc.html
# https://github.com/agdamsbo/stRoke/blob/main/R/pase_calc.R
pase_sample <- stRoke::pase

# 输入、输出文件路径，根据实际情况进行调整
base_dir <- "/DATA/PASE/"
input_file <- "sample.xlsx"
input_sheet <- "sampledata"

# 读取excel文件，里面有基础的问题结果
pase_data <- read_excel(paste0(base_dir, input_file), sheet = input_sheet)
# 抽取问题答案的21个列，作为计算分数函数的输入，也要根据实际情况调整
pase_q_data <- pase_data[c(seq(5, 25))]

# 计算得分，计算2个口径。adjwork=TRUE时，如果10b工作主要是坐着，则分数直接改成0
pase_score_adjwork <- stRoke::pase_calc(pase_q_data, adjust_work = TRUE)
pase_score <- stRoke::pase_calc(pase_q_data, adjust_work = FALSE)

# 合并得分结果，得到最终的文件
pase_data_result_adjwork <- cbind(pase_data, pase_score_adjwork)
pase_data_result <- cbind(pase_data, pase_score)

# 输出最终数据到文件中
write_xlsx(pase_data_result_adjwork, path = paste0(base_dir, "pase_data_result_adjwork.xlsx"))
write_xlsx(pase_data_result, path = paste0(base_dir, "pase_data_result.xlsx"))

