
library(sqldf)
library(writexl)

ppmi_home <- "/Users/hanhui02/workspace/r_scripts/ppmi/"
original_data_dir <- paste0(ppmi_home, "ppmi_original_data/")
data_dir <- paste0(ppmi_home, "ppmi_data/")
data_version <- "-Archived_09Jan2025"

patient_event_file <- paste0(data_dir, "patient_event.xlsx")

code_list_file <- paste0(original_data_dir, "Code_List",data_version,".csv")
data_dictionary_file <- paste0(original_data_dir, "Data_Dictionary",data_version,".csv")
patient_status_file <- paste0(original_data_dir, "Patient_Status",data_version,".csv")
participant_status_file <- paste0(original_data_dir, "Participant_Status_09Jan2025.csv")
age_at_visit_file <- paste0(original_data_dir, "Age_at_visit_09Jan2025.csv")
demographics_file <- paste0(original_data_dir, "Demographics_09Jan2025.csv")

code_list <- read.csv(code_list_file)
data_dictionary <- read.csv(data_dictionary_file)
patient_status <- read.csv(patient_status_file)
participant_status <- read.csv(participant_status_file)
age_at_visit <- read.csv(age_at_visit_file)
demographics <- read.csv(demographics_file)


patient_event_sql <- "


SELECT ps.patno,
       cl.event_id,
       ps.cohort,
       ps.cohort_definition,
       cl.event_meaning,
       cl.visit_month,
       a.age_at_visit,
       d.sex
  FROM participant_status ps
  JOIN (SELECT DISTINCT c.code event_id,
                        c.decode event_meaning,
                        CAST(CASE
                               WHEN c.decode LIKE 'Visit%' THEN
                                substr(c.decode,
                                       instr(c.decode, 'Month') + 5,
                                       instr(c.decode, ')') -
                                       instr(c.decode, 'Month') - 5)
                             END AS INT) visit_month
          FROM code_list c
         WHERE c.itm_name = 'EVENT_ID') cl
    ON (1 = 1)
  LEFT JOIN (SELECT a.patno, a.event_id, MAX(a.age_at_visit) age_at_visit
               FROM age_at_visit a
              GROUP BY a.patno, a.event_id) a
    ON (ps.patno = a.patno AND cl.event_id = a.event_id)
  LEFT JOIN demographics d
    ON (ps.patno = d.patno)


"

patient_event <- sqldf(patient_event_sql)

write_xlsx(patient_event, path = patient_event_file)

