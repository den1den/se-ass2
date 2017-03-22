SELECT
    COUNT(h.id),
    TIMESTAMPDIFF(SECOND,
        MIN(h.hist_createdTime),
        NOW()),
    TIMESTAMPDIFF(DAY,
        MIN(h.hist_createdTime),
        NOW()),
    p.*
FROM
    gm_libreoffice.t_people AS p
		LEFT JOIN
	gm_libreoffice.t_history AS h ON h.hist_authorAccountId = p.p_accountId AND (
		h.hist_message LIKE '%Looks good to me, approved%'
		OR h.hist_message LIKE '%Do not submit%'
		OR h.hist_message LIKE '%Code-Review%')
GROUP BY p.id;