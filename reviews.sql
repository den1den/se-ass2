SELECT * FROM gm_libreoffice.t_history WHERE
hist_message LIKE '%Looks good to me, approved%'
OR hist_message LIKE '%Do not submit%'
OR hist_message LIKE '%Code-Review%'
;