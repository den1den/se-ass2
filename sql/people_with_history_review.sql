SELECT 
    'p_id',
    'p_accountId',
    'p_name',
    'p_email',
    'p_userName',
    'p_review_activity',
    'p_review_tenure'
UNION ALL SELECT
    p.*,
    COUNT(h.id),
    TIMESTAMPDIFF(SECOND,
        MIN(h.hist_createdTime),
        NOW())
FROM
    gm_libreoffice.t_people AS p
		JOIN
	gm_libreoffice.t_history AS h ON h.hist_authorAccountId = p.p_accountId AND (
		h.hist_message LIKE '%Looks good to me, approved%'
		OR h.hist_message LIKE '%Do not submit%'
		OR h.hist_message LIKE '%Code-Review%')
GROUP BY p.id
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/people_with_history_review.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
;