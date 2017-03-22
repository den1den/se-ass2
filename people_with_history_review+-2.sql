SELECT
	COUNT(hmp2.id),
    TIMESTAMPDIFF(SECOND,
        MIN(hmp2.hist_createdTime),
        NOW()),
    TIMESTAMPDIFF(DAY,
        MIN(hmp2.hist_createdTime),
        NOW()),
    p.*
FROM
    gm_libreoffice.t_people AS p
		LEFT JOIN
	gm_libreoffice.t_history AS hmp2 ON hmp2.hist_authorAccountId = p.p_accountId AND (
		hmp2.hist_message LIKE '%Code-Review-2%'
		OR hmp2.hist_message LIKE '%Code-Review+2%')
GROUP BY p.id;