
library(sqldf)
library(writexl)

ppmi_home <- "/Users/hanhui02/workspace/r_scripts/ppmi/"
original_data_dir <- paste0(ppmi_home, "ppmi_original_data/")
data_dir <- paste0(ppmi_home, "ppmi_data/")
data_version <- "-Archived_09Jan2025"

ppmi_updrs_file <- paste0(data_dir, "ppmi_updrs.xlsx")

code_list_file <- paste0(original_data_dir, "Code_List",data_version,".csv")
data_dictionary_file <- paste0(original_data_dir, "Data_Dictionary",data_version,".csv")
patient_status_file <- paste0(original_data_dir, "Patient_Status",data_version,".csv")
participant_status_file <- paste0(original_data_dir, "Participant_Status_09Jan2025.csv")

updrs_part1_file <- paste0(original_data_dir, "MDS_UPDRS_Part_I",data_version,".csv")
updrs_part1_pq_file <- paste0(original_data_dir, "MDS_UPDRS_Part_I__Patient_Questionnaire",data_version,".csv")
updrs_part2_pq_file <- paste0(original_data_dir, "MDS_UPDRS_Part_II__Patient_Questionnaire",data_version,".csv")
updrs_part3_file <- paste0(original_data_dir, "MDS_UPDRS_Part_III",data_version,".csv")
updrs_part4_file <- paste0(original_data_dir, "MDS_UPDRS_Part_IV",data_version,".csv")

code_list <- read.csv(code_list_file)
data_dictionary <- read.csv(data_dictionary_file)
patient_status <- read.csv(patient_status_file)
participant_status <- read.csv(participant_status_file)
updrs_part1 <- read.csv(updrs_part1_file)
updrs_part1_pq <- read.csv(updrs_part1_pq_file)
updrs_part2_pq <- read.csv(updrs_part2_pq_file)
updrs_part3 <- read.csv(updrs_part3_file)
updrs_part4 <- read.csv(updrs_part4_file)

patient_event_sql <- "
SELECT ps.patno,
       cl.event_id,
       ps.cohort,
       ps.cohort_definition,
       cl.event_meaning
  FROM participant_status ps
 CROSS JOIN (SELECT DISTINCT c.code event_id, c.decode event_meaning
               FROM code_list c
              WHERE c.itm_name = 'EVENT_ID'
              ORDER BY c.code) cl
"

patient_event <- sqldf(patient_event_sql)

updrs_sql <- "

SELECT pe.patno,
       pe.event_id,
       pe.cohort,
       pe.cohort_definition,
       pe.event_meaning,
       p1.rec_id                       updrs_part1_rec_id,
       p1.f_status                     updrs_part1_f_status,
       p1.patno                        updrs_part1_patno,
       p1.event_id                     updrs_part1_event_id,
       p1.pag_name                     updrs_part1_pag_name,
       p1.infodt                       updrs_part1_infodt,
       p1.nupsourc                     updrs_part1_nupsourc,
       p1.np1cog                       updrs_part1_np1cog,
       p1.np1hall                      updrs_part1_np1hall,
       p1.np1dprs                      updrs_part1_np1dprs,
       p1.np1anxs                      updrs_part1_np1anxs,
       p1.np1apat                      updrs_part1_np1apat,
       p1.np1dds                       updrs_part1_np1dds,
       p1.orig_entry                   updrs_part1_orig_entry,
       p1.last_update                  updrs_part1_last_update,
       p1.query                        updrs_part1_query,
       p1.site_aprv                    updrs_part1_site_aprv,
       pq1.rec_id                      updrs_part1_pq_rec_id,
       pq1.f_status                    updrs_part1_pq_f_status,
       pq1.patno                       updrs_part1_pq_patno,
       pq1.event_id                    updrs_part1_pq_event_id,
       pq1.pag_name                    updrs_part1_pq_pag_name,
       pq1.infodt                      updrs_part1_pq_infodt,
       pq1.nupsourc                    updrs_part1_pq_nupsourc,
       pq1.np1slpn                     updrs_part1_pq_np1slpn,
       pq1.np1slpd                     updrs_part1_pq_np1slpd,
       pq1.np1pain                     updrs_part1_pq_np1pain,
       pq1.np1urin                     updrs_part1_pq_np1urin,
       pq1.np1cnst                     updrs_part1_pq_np1cnst,
       pq1.np1lthd                     updrs_part1_pq_np1lthd,
       pq1.np1fatg                     updrs_part1_pq_np1fatg,
       pq1.orig_entry                  updrs_part1_pq_orig_entry,
       pq1.last_update                 updrs_part1_pq_last_update,
       pq1.query                       updrs_part1_pq_query,
       pq1.site_aprv                   updrs_part1_pq_site_aprv,
       pq2.rec_id                      updrs_part2_pq_rec_id,
       pq2.f_status                    updrs_part2_pq_f_status,
       pq2.patno                       updrs_part2_pq_patno,
       pq2.event_id                    updrs_part2_pq_event_id,
       pq2.pag_name                    updrs_part2_pq_pag_name,
       pq2.infodt                      updrs_part2_pq_infodt,
       pq2.nupsourc                    updrs_part2_pq_nupsourc,
       pq2.np2spch                     updrs_part2_pq_np2spch,
       pq2.np2salv                     updrs_part2_pq_np2salv,
       pq2.np2swal                     updrs_part2_pq_np2swal,
       pq2.np2eat                      updrs_part2_pq_np2eat,
       pq2.np2dres                     updrs_part2_pq_np2dres,
       pq2.np2hygn                     updrs_part2_pq_np2hygn,
       pq2.np2hwrt                     updrs_part2_pq_np2hwrt,
       pq2.np2hobb                     updrs_part2_pq_np2hobb,
       pq2.np2turn                     updrs_part2_pq_np2turn,
       pq2.np2trmr                     updrs_part2_pq_np2trmr,
       pq2.np2rise                     updrs_part2_pq_np2rise,
       pq2.np2walk                     updrs_part2_pq_np2walk,
       pq2.np2frez                     updrs_part2_pq_np2frez,
       pq2.orig_entry                  updrs_part2_pq_orig_entry,
       pq2.last_update                 updrs_part2_pq_last_update,
       pq2.query                       updrs_part2_pq_query,
       pq2.site_aprv                   updrs_part2_pq_site_aprv,
       p3.rec_id                       updrs_part3_rec_id,
       p3.f_status                     updrs_part3_f_status,
       p3.patno                        updrs_part3_patno,
       p3.event_id                     updrs_part3_event_id,
       p3.pag_name                     updrs_part3_pag_name,
       p3.infodt                       updrs_part3_infodt,
       p3.pdmeddt                      updrs_part3_pdmeddt,
       p3.pdmedtm                      updrs_part3_pdmedtm,
       p3.pdstate                      updrs_part3_pdstate,
       p3.examtm                       updrs_part3_examtm,
       p3.dbs_status                   updrs_part3_dbs_status,
       p3.np3spch                      updrs_part3_np3spch,
       p3.np3facxp                     updrs_part3_np3facxp,
       p3.np3rign                      updrs_part3_np3rign,
       p3.np3rigru                     updrs_part3_np3rigru,
       p3.np3riglu                     updrs_part3_np3riglu,
       p3.pn3rigrl                     updrs_part3_pn3rigrl,
       p3.np3rigll                     updrs_part3_np3rigll,
       p3.np3ftapr                     updrs_part3_np3ftapr,
       p3.np3ftapl                     updrs_part3_np3ftapl,
       p3.np3hmovr                     updrs_part3_np3hmovr,
       p3.np3hmovl                     updrs_part3_np3hmovl,
       p3.np3prspr                     updrs_part3_np3prspr,
       p3.np3prspl                     updrs_part3_np3prspl,
       p3.np3ttapr                     updrs_part3_np3ttapr,
       p3.np3ttapl                     updrs_part3_np3ttapl,
       p3.np3lgagr                     updrs_part3_np3lgagr,
       p3.np3lgagl                     updrs_part3_np3lgagl,
       p3.np3risng                     updrs_part3_np3risng,
       p3.np3gait                      updrs_part3_np3gait,
       p3.np3frzgt                     updrs_part3_np3frzgt,
       p3.np3pstbl                     updrs_part3_np3pstbl,
       p3.np3postr                     updrs_part3_np3postr,
       p3.np3brady                     updrs_part3_np3brady,
       p3.np3ptrmr                     updrs_part3_np3ptrmr,
       p3.np3ptrml                     updrs_part3_np3ptrml,
       p3.np3ktrmr                     updrs_part3_np3ktrmr,
       p3.np3ktrml                     updrs_part3_np3ktrml,
       p3.np3rtaru                     updrs_part3_np3rtaru,
       p3.np3rtalu                     updrs_part3_np3rtalu,
       p3.np3rtarl                     updrs_part3_np3rtarl,
       p3.np3rtall                     updrs_part3_np3rtall,
       p3.np3rtalj                     updrs_part3_np3rtalj,
       p3.np3rtcon                     updrs_part3_np3rtcon,
       p3.dyskpres                     updrs_part3_dyskpres,
       p3.dyskirat                     updrs_part3_dyskirat,
       p3.nhy                          updrs_part3_nhy,
       p3.annual_time_btw_dose_nupdrs  updrs_part3_annual_time_btw_dose_nupdrs,
       p3.on_off_dose                  updrs_part3_on_off_dose,
       p3.pd_med_use                   updrs_part3_pd_med_use,
       p3.orig_entry                   updrs_part3_orig_entry,
       p3.last_update                  updrs_part3_last_update,
       p3.query                        updrs_part3_query,
       p3.site_aprv                    updrs_part3_site_aprv,
       p3a.rec_id                      updrs_part3_a_rec_id,
       p3a.f_status                    updrs_part3_a_f_status,
       p3a.patno                       updrs_part3_a_patno,
       p3a.event_id                    updrs_part3_a_event_id,
       p3a.pag_name                    updrs_part3_a_pag_name,
       p3a.infodt                      updrs_part3_a_infodt,
       p3a.pdmeddt                     updrs_part3_a_pdmeddt,
       p3a.pdmedtm                     updrs_part3_a_pdmedtm,
       p3a.pdstate                     updrs_part3_a_pdstate,
       p3a.examtm                      updrs_part3_a_examtm,
       p3a.dbs_status                  updrs_part3_a_dbs_status,
       p3a.np3spch                     updrs_part3_a_np3spch,
       p3a.np3facxp                    updrs_part3_a_np3facxp,
       p3a.np3rign                     updrs_part3_a_np3rign,
       p3a.np3rigru                    updrs_part3_a_np3rigru,
       p3a.np3riglu                    updrs_part3_a_np3riglu,
       p3a.pn3rigrl                    updrs_part3_a_pn3rigrl,
       p3a.np3rigll                    updrs_part3_a_np3rigll,
       p3a.np3ftapr                    updrs_part3_a_np3ftapr,
       p3a.np3ftapl                    updrs_part3_a_np3ftapl,
       p3a.np3hmovr                    updrs_part3_a_np3hmovr,
       p3a.np3hmovl                    updrs_part3_a_np3hmovl,
       p3a.np3prspr                    updrs_part3_a_np3prspr,
       p3a.np3prspl                    updrs_part3_a_np3prspl,
       p3a.np3ttapr                    updrs_part3_a_np3ttapr,
       p3a.np3ttapl                    updrs_part3_a_np3ttapl,
       p3a.np3lgagr                    updrs_part3_a_np3lgagr,
       p3a.np3lgagl                    updrs_part3_a_np3lgagl,
       p3a.np3risng                    updrs_part3_a_np3risng,
       p3a.np3gait                     updrs_part3_a_np3gait,
       p3a.np3frzgt                    updrs_part3_a_np3frzgt,
       p3a.np3pstbl                    updrs_part3_a_np3pstbl,
       p3a.np3postr                    updrs_part3_a_np3postr,
       p3a.np3brady                    updrs_part3_a_np3brady,
       p3a.np3ptrmr                    updrs_part3_a_np3ptrmr,
       p3a.np3ptrml                    updrs_part3_a_np3ptrml,
       p3a.np3ktrmr                    updrs_part3_a_np3ktrmr,
       p3a.np3ktrml                    updrs_part3_a_np3ktrml,
       p3a.np3rtaru                    updrs_part3_a_np3rtaru,
       p3a.np3rtalu                    updrs_part3_a_np3rtalu,
       p3a.np3rtarl                    updrs_part3_a_np3rtarl,
       p3a.np3rtall                    updrs_part3_a_np3rtall,
       p3a.np3rtalj                    updrs_part3_a_np3rtalj,
       p3a.np3rtcon                    updrs_part3_a_np3rtcon,
       p3a.dyskpres                    updrs_part3_a_dyskpres,
       p3a.dyskirat                    updrs_part3_a_dyskirat,
       p3a.nhy                         updrs_part3_a_nhy,
       p3a.annual_time_btw_dose_nupdrs updrs_part3_a_annual_time_btw_dose_nupdrs,
       p3a.on_off_dose                 updrs_part3_a_on_off_dose,
       p3a.pd_med_use                  updrs_part3_a_pd_med_use,
       p3a.orig_entry                  updrs_part3_a_orig_entry,
       p3a.last_update                 updrs_part3_a_last_update,
       p3a.query                       updrs_part3_a_query,
       p3a.site_aprv                   updrs_part3_a_site_aprv,
       p4.rec_id                       updrs_part4_rec_id,
       p4.f_status                     updrs_part4_f_status,
       p4.patno                        updrs_part4_patno,
       p4.event_id                     updrs_part4_event_id,
       p4.pag_name                     updrs_part4_pag_name,
       p4.infodt                       updrs_part4_infodt,
       p4.np4wdysk                     updrs_part4_np4wdysk,
       p4.np4dyski                     updrs_part4_np4dyski,
       p4.np4off                       updrs_part4_np4off,
       p4.np4flcti                     updrs_part4_np4flcti,
       p4.np4flctx                     updrs_part4_np4flctx,
       p4.np4dystn                     updrs_part4_np4dystn,
       p4.orig_entry                   updrs_part4_orig_entry,
       p4.last_update                  updrs_part4_last_update,
       p4.query                        updrs_part4_query,
       p4.site_aprv                    updrs_part4_site_aprv
  FROM patient_event pe
  LEFT JOIN updrs_part1 p1
    ON (pe.patno = p1.patno AND pe.event_id = p1.event_id AND
       p1.f_status = 'S')
  LEFT JOIN updrs_part1_pq pq1
    ON (pe.patno = pq1.patno AND pe.event_id = pq1.event_id AND
       pq1.f_status = 'S')
  LEFT JOIN updrs_part2_pq pq2
    ON (pe.patno = pq2.patno AND pe.event_id = pq2.event_id AND
       pq2.f_status = 'S')
  LEFT JOIN updrs_part3 p3
    ON (pe.patno = p3.patno AND pe.event_id = p3.event_id AND
       p3.f_status = 'S' AND p3.pag_name = 'NUPDRS3')
  LEFT JOIN updrs_part3 p3a
    ON (pe.patno = p3a.patno AND pe.event_id = p3a.event_id AND
       p3a.f_status = 'S' AND p3a.pag_name = 'NUPDRS3A')
  LEFT JOIN updrs_part4 p4
    ON (pe.patno = p4.patno AND pe.event_id = p4.event_id AND
       p4.f_status = 'S')
 WHERE 1 = 1
   AND ifnull(ifnull(ifnull(ifnull(ifnull(p1.patno, pq1.patno), pq2.patno),
                            p3.patno),
                     p3a.patno),
              p4.patno) IS NOT NULL

"

updrs_result <- sqldf(updrs_sql)


write_xlsx(updrs_result, path = ppmi_updrs_file)

