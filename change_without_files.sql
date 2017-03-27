SELECT 
	c.*
FROM
    gm_libreoffice.t_change AS c
WHERE
    c.id NOT IN (SELECT 
            c2.id
        FROM
            gm_libreoffice.t_change AS c2
                INNER JOIN
            gm_libreoffice.t_file AS f ON f.f_revisionId = c2.id)