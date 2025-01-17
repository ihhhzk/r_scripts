library(sqldf)
library(readxl)
library(writexl)


ppmi_home <- "/Users/hanhui02/workspace/r_scripts/ppmi/"
data_dir <- paste0(ppmi_home, "ppmi_data/")
ppmi_pase_file <- paste0(data_dir, "ppmi_pase.xlsx")
ppmi_updrs_file <- paste0(data_dir, "ppmi_updrs.xlsx")
patient_event_file <- paste0(data_dir, "patient_event.xlsx")
ppmi_basic_file <- paste0(data_dir, "ppmi_v20250109.xlsx")


ppmi_pase <- read_excel(ppmi_pase_file)
ppmi_updrs <- read_excel(ppmi_updrs_file)
patient_event <- read_excel(patient_event_file)

sql_basic <- "
SELECT pe.patno,
       pe.event_id,
       pe.cohort,
       pe.cohort_definition,
       pe.event_meaning,
       pe.visit_month,
       pe.age_at_visit,
       pe.sex,
       p.pase_score_02,
       p.pase_score_03,
       p.pase_score_04,
       p.pase_score_05,
       p.pase_score_06,
       p.pase_score_07,
       p.pase_score_08,
       p.pase_score_09a,
       p.pase_score_09b,
       p.pase_score_09c,
       p.pase_score_09d,
       p.pase_score_10,
       p.pase_score_sum,
       u.updrs_part1_nupsourc,
       u.updrs_part1_np1cog,
       u.updrs_part1_np1hall,
       u.updrs_part1_np1dprs,
       u.updrs_part1_np1anxs,
       u.updrs_part1_np1apat,
       u.updrs_part1_np1dds,
       u.updrs_part1_orig_entry,
       u.updrs_part1_last_update,
       u.updrs_part1_query,
       u.updrs_part1_site_aprv,
       u.updrs_part1_pq_nupsourc,
       u.updrs_part1_pq_np1slpn,
       u.updrs_part1_pq_np1slpd,
       u.updrs_part1_pq_np1pain,
       u.updrs_part1_pq_np1urin,
       u.updrs_part1_pq_np1cnst,
       u.updrs_part1_pq_np1lthd,
       u.updrs_part1_pq_np1fatg,
       u.updrs_part1_pq_orig_entry,
       u.updrs_part1_pq_last_update,
       u.updrs_part1_pq_query,
       u.updrs_part1_pq_site_aprv,
       u.updrs_part2_pq_nupsourc,
       u.updrs_part2_pq_np2spch,
       u.updrs_part2_pq_np2salv,
       u.updrs_part2_pq_np2swal,
       u.updrs_part2_pq_np2eat,
       u.updrs_part2_pq_np2dres,
       u.updrs_part2_pq_np2hygn,
       u.updrs_part2_pq_np2hwrt,
       u.updrs_part2_pq_np2hobb,
       u.updrs_part2_pq_np2turn,
       u.updrs_part2_pq_np2trmr,
       u.updrs_part2_pq_np2rise,
       u.updrs_part2_pq_np2walk,
       u.updrs_part2_pq_np2frez,
       u.updrs_part2_pq_orig_entry,
       u.updrs_part2_pq_last_update,
       u.updrs_part2_pq_query,
       u.updrs_part2_pq_site_aprv,
       u.updrs_part3_pdmeddt,
       u.updrs_part3_pdmedtm,
       u.updrs_part3_pdstate,
       u.updrs_part3_examtm,
       u.updrs_part3_dbs_status,
       u.updrs_part3_np3spch,
       u.updrs_part3_np3facxp,
       u.updrs_part3_np3rign,
       u.updrs_part3_np3rigru,
       u.updrs_part3_np3riglu,
       u.updrs_part3_pn3rigrl,
       u.updrs_part3_np3rigll,
       u.updrs_part3_np3ftapr,
       u.updrs_part3_np3ftapl,
       u.updrs_part3_np3hmovr,
       u.updrs_part3_np3hmovl,
       u.updrs_part3_np3prspr,
       u.updrs_part3_np3prspl,
       u.updrs_part3_np3ttapr,
       u.updrs_part3_np3ttapl,
       u.updrs_part3_np3lgagr,
       u.updrs_part3_np3lgagl,
       u.updrs_part3_np3risng,
       u.updrs_part3_np3gait,
       u.updrs_part3_np3frzgt,
       u.updrs_part3_np3pstbl,
       u.updrs_part3_np3postr,
       u.updrs_part3_np3brady,
       u.updrs_part3_np3ptrmr,
       u.updrs_part3_np3ptrml,
       u.updrs_part3_np3ktrmr,
       u.updrs_part3_np3ktrml,
       u.updrs_part3_np3rtaru,
       u.updrs_part3_np3rtalu,
       u.updrs_part3_np3rtarl,
       u.updrs_part3_np3rtall,
       u.updrs_part3_np3rtalj,
       u.updrs_part3_np3rtcon,
       u.updrs_part3_dyskpres,
       u.updrs_part3_dyskirat,
       u.updrs_part3_nhy,
       u.updrs_part3_annual_time_btw_dose_nupdrs,
       u.updrs_part3_on_off_dose,
       u.updrs_part3_pd_med_use,
       u.updrs_part3_orig_entry,
       u.updrs_part3_last_update,
       u.updrs_part3_query,
       u.updrs_part3_site_aprv,
       u.updrs_part3_a_pdmeddt,
       u.updrs_part3_a_pdmedtm,
       u.updrs_part3_a_pdstate,
       u.updrs_part3_a_examtm,
       u.updrs_part3_a_dbs_status,
       u.updrs_part3_a_np3spch,
       u.updrs_part3_a_np3facxp,
       u.updrs_part3_a_np3rign,
       u.updrs_part3_a_np3rigru,
       u.updrs_part3_a_np3riglu,
       u.updrs_part3_a_pn3rigrl,
       u.updrs_part3_a_np3rigll,
       u.updrs_part3_a_np3ftapr,
       u.updrs_part3_a_np3ftapl,
       u.updrs_part3_a_np3hmovr,
       u.updrs_part3_a_np3hmovl,
       u.updrs_part3_a_np3prspr,
       u.updrs_part3_a_np3prspl,
       u.updrs_part3_a_np3ttapr,
       u.updrs_part3_a_np3ttapl,
       u.updrs_part3_a_np3lgagr,
       u.updrs_part3_a_np3lgagl,
       u.updrs_part3_a_np3risng,
       u.updrs_part3_a_np3gait,
       u.updrs_part3_a_np3frzgt,
       u.updrs_part3_a_np3pstbl,
       u.updrs_part3_a_np3postr,
       u.updrs_part3_a_np3brady,
       u.updrs_part3_a_np3ptrmr,
       u.updrs_part3_a_np3ptrml,
       u.updrs_part3_a_np3ktrmr,
       u.updrs_part3_a_np3ktrml,
       u.updrs_part3_a_np3rtaru,
       u.updrs_part3_a_np3rtalu,
       u.updrs_part3_a_np3rtarl,
       u.updrs_part3_a_np3rtall,
       u.updrs_part3_a_np3rtalj,
       u.updrs_part3_a_np3rtcon,
       u.updrs_part3_a_dyskpres,
       u.updrs_part3_a_dyskirat,
       u.updrs_part3_a_nhy,
       u.updrs_part3_a_annual_time_btw_dose_nupdrs,
       u.updrs_part3_a_on_off_dose,
       u.updrs_part3_a_pd_med_use,
       u.updrs_part3_a_orig_entry,
       u.updrs_part3_a_last_update,
       u.updrs_part3_a_query,
       u.updrs_part3_a_site_aprv,
       u.updrs_part4_np4wdysk,
       u.updrs_part4_np4dyski,
       u.updrs_part4_np4off,
       u.updrs_part4_np4flcti,
       u.updrs_part4_np4flctx,
       u.updrs_part4_np4dystn,
       u.updrs_part4_orig_entry,
       u.updrs_part4_last_update,
       u.updrs_part4_query,
       u.updrs_part4_site_aprv
  FROM patient_event pe
  JOIN ppmi_pase p
    ON (pe.patno = p.patno AND pe.event_id = p.event_id)
  JOIN ppmi_updrs u
    ON (pe.patno = u.patno AND pe.event_id = u.event_id)
 WHERE 1 = 1
   AND pe.event_id IN ('V04',
                       'V06',
                       'V08',
                       'V10',
                       'V12',
                       'V13',
                       'V14',
                       'V15',
                       'V16',
                       'V17',
                       'V18',
                       'V19',
                       'V20')

"
basic_data <- sqldf(sql_basic)

sql_group <- "

SELECT b.patno,
       b.cohort,
       b.cohort_definition,
       MIN(b.event_id) baseline_event_id,
       MIN(b.visit_month) baseline_month,
       COUNT(*) row_count
  FROM basic_data b
 WHERE b.cohort IN (1,2)
 GROUP BY b.patno, b.cohort, b.cohort_definition
HAVING COUNT(*) >= 3

"
group_data <- sqldf(sql_group)

sql_result <- "

SELECT b.patno,
       b.event_id,
       b.cohort,
       b.cohort_definition,
       b.event_meaning,
       b.visit_month,
       b.age_at_visit,
       b.sex,
       g.baseline_event_id,
       g.baseline_month,
       g.row_count,
       b.visit_month - g.baseline_month diff_months,
       (b.visit_month - g.baseline_month) / 12 diff_years,
       b.pase_score_02,
       b.pase_score_03,
       b.pase_score_04,
       b.pase_score_05,
       b.pase_score_06,
       b.pase_score_07,
       b.pase_score_08,
       b.pase_score_09a,
       b.pase_score_09b,
       b.pase_score_09c,
       b.pase_score_09d,
       b.pase_score_10,
       b.pase_score_sum,
       b.updrs_part1_nupsourc,
       b.updrs_part1_np1cog,
       b.updrs_part1_np1hall,
       b.updrs_part1_np1dprs,
       b.updrs_part1_np1anxs,
       b.updrs_part1_np1apat,
       b.updrs_part1_np1dds,
       b.updrs_part1_orig_entry,
       b.updrs_part1_last_update,
       b.updrs_part1_query,
       b.updrs_part1_site_aprv,
       b.updrs_part1_pq_nupsourc,
       b.updrs_part1_pq_np1slpn,
       b.updrs_part1_pq_np1slpd,
       b.updrs_part1_pq_np1pain,
       b.updrs_part1_pq_np1urin,
       b.updrs_part1_pq_np1cnst,
       b.updrs_part1_pq_np1lthd,
       b.updrs_part1_pq_np1fatg,
       b.updrs_part1_pq_orig_entry,
       b.updrs_part1_pq_last_update,
       b.updrs_part1_pq_query,
       b.updrs_part1_pq_site_aprv,
       b.updrs_part2_pq_nupsourc,
       b.updrs_part2_pq_np2spch,
       b.updrs_part2_pq_np2salv,
       b.updrs_part2_pq_np2swal,
       b.updrs_part2_pq_np2eat,
       b.updrs_part2_pq_np2dres,
       b.updrs_part2_pq_np2hygn,
       b.updrs_part2_pq_np2hwrt,
       b.updrs_part2_pq_np2hobb,
       b.updrs_part2_pq_np2turn,
       b.updrs_part2_pq_np2trmr,
       b.updrs_part2_pq_np2rise,
       b.updrs_part2_pq_np2walk,
       b.updrs_part2_pq_np2frez,
       b.updrs_part2_pq_orig_entry,
       b.updrs_part2_pq_last_update,
       b.updrs_part2_pq_query,
       b.updrs_part2_pq_site_aprv,
       b.updrs_part3_pdmeddt,
       b.updrs_part3_pdmedtm,
       b.updrs_part3_pdstate,
       b.updrs_part3_examtm,
       b.updrs_part3_dbs_status,
       b.updrs_part3_np3spch,
       b.updrs_part3_np3facxp,
       b.updrs_part3_np3rign,
       b.updrs_part3_np3rigru,
       b.updrs_part3_np3riglu,
       b.updrs_part3_pn3rigrl,
       b.updrs_part3_np3rigll,
       b.updrs_part3_np3ftapr,
       b.updrs_part3_np3ftapl,
       b.updrs_part3_np3hmovr,
       b.updrs_part3_np3hmovl,
       b.updrs_part3_np3prspr,
       b.updrs_part3_np3prspl,
       b.updrs_part3_np3ttapr,
       b.updrs_part3_np3ttapl,
       b.updrs_part3_np3lgagr,
       b.updrs_part3_np3lgagl,
       b.updrs_part3_np3risng,
       b.updrs_part3_np3gait,
       b.updrs_part3_np3frzgt,
       b.updrs_part3_np3pstbl,
       b.updrs_part3_np3postr,
       b.updrs_part3_np3brady,
       b.updrs_part3_np3ptrmr,
       b.updrs_part3_np3ptrml,
       b.updrs_part3_np3ktrmr,
       b.updrs_part3_np3ktrml,
       b.updrs_part3_np3rtaru,
       b.updrs_part3_np3rtalu,
       b.updrs_part3_np3rtarl,
       b.updrs_part3_np3rtall,
       b.updrs_part3_np3rtalj,
       b.updrs_part3_np3rtcon,
       b.updrs_part3_dyskpres,
       b.updrs_part3_dyskirat,
       b.updrs_part3_nhy,
       b.updrs_part3_annual_time_btw_dose_nupdrs,
       b.updrs_part3_on_off_dose,
       b.updrs_part3_pd_med_use,
       b.updrs_part3_orig_entry,
       b.updrs_part3_last_update,
       b.updrs_part3_query,
       b.updrs_part3_site_aprv,
       b.updrs_part3_a_pdmeddt,
       b.updrs_part3_a_pdmedtm,
       b.updrs_part3_a_pdstate,
       b.updrs_part3_a_examtm,
       b.updrs_part3_a_dbs_status,
       b.updrs_part3_a_np3spch,
       b.updrs_part3_a_np3facxp,
       b.updrs_part3_a_np3rign,
       b.updrs_part3_a_np3rigru,
       b.updrs_part3_a_np3riglu,
       b.updrs_part3_a_pn3rigrl,
       b.updrs_part3_a_np3rigll,
       b.updrs_part3_a_np3ftapr,
       b.updrs_part3_a_np3ftapl,
       b.updrs_part3_a_np3hmovr,
       b.updrs_part3_a_np3hmovl,
       b.updrs_part3_a_np3prspr,
       b.updrs_part3_a_np3prspl,
       b.updrs_part3_a_np3ttapr,
       b.updrs_part3_a_np3ttapl,
       b.updrs_part3_a_np3lgagr,
       b.updrs_part3_a_np3lgagl,
       b.updrs_part3_a_np3risng,
       b.updrs_part3_a_np3gait,
       b.updrs_part3_a_np3frzgt,
       b.updrs_part3_a_np3pstbl,
       b.updrs_part3_a_np3postr,
       b.updrs_part3_a_np3brady,
       b.updrs_part3_a_np3ptrmr,
       b.updrs_part3_a_np3ptrml,
       b.updrs_part3_a_np3ktrmr,
       b.updrs_part3_a_np3ktrml,
       b.updrs_part3_a_np3rtaru,
       b.updrs_part3_a_np3rtalu,
       b.updrs_part3_a_np3rtarl,
       b.updrs_part3_a_np3rtall,
       b.updrs_part3_a_np3rtalj,
       b.updrs_part3_a_np3rtcon,
       b.updrs_part3_a_dyskpres,
       b.updrs_part3_a_dyskirat,
       b.updrs_part3_a_nhy,
       b.updrs_part3_a_annual_time_btw_dose_nupdrs,
       b.updrs_part3_a_on_off_dose,
       b.updrs_part3_a_pd_med_use,
       b.updrs_part3_a_orig_entry,
       b.updrs_part3_a_last_update,
       b.updrs_part3_a_query,
       b.updrs_part3_a_site_aprv,
       b.updrs_part4_np4wdysk,
       b.updrs_part4_np4dyski,
       b.updrs_part4_np4off,
       b.updrs_part4_np4flcti,
       b.updrs_part4_np4flctx,
       b.updrs_part4_np4dystn,
       b.updrs_part4_orig_entry,
       b.updrs_part4_last_update,
       b.updrs_part4_query,
       b.updrs_part4_site_aprv
  FROM group_data g
  JOIN basic_data b
    ON (g.patno = b.patno)


"
result_data <- sqldf(sql_result)

write_xlsx(result_data, path = ppmi_basic_file)


