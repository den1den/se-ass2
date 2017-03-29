SELECT 
    'p_id',
    'p_accountId',
    'p_name',
    'p_email',
    'p_userName',
    'p_review_activity_2',
    'p_review_tenure_2'
UNION ALL SELECT
    p.*,
    COUNT(h.id),
    TIMESTAMPDIFF(SECOND,
        MIN(h.hist_createdTime),
        NOW())
FROM
    gm_openstack.t_people AS p
		JOIN
	gm_openstack.t_history AS h ON h.hist_authorAccountId = p.p_accountId AND (
		h.hist_message LIKE '%Code-Review-2%'
		OR h.hist_message LIKE '%Code-Review+2%')
GROUP BY p.id
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/people_with_history_review+-2.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
;