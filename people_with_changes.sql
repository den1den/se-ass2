SELECT 
    TIMESTAMPDIFF(SECOND,
        MIN(c.ch_createdTime),
        NOW()),
    TIMESTAMPDIFF(DAY,
        MIN(c.ch_createdTime),
        NOW()),
    COUNT(c.id),
    p.*
FROM
    gm_libreoffice.t_people AS p
        LEFT JOIN
    gm_libreoffice.t_change AS c ON c.ch_authorAccountId = p.p_accountId
GROUP BY p.id;