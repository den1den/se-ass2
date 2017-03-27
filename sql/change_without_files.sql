SELECT 
    'change_id'
UNION ALL SELECT 
	c.id
FROM
    gm_libreoffice.t_change AS c
WHERE
    c.id NOT IN (SELECT 
            c2.id
        FROM
            gm_libreoffice.t_change AS c2
                INNER JOIN
            gm_libreoffice.t_file AS f ON f.f_revisionId = c2.id)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/change_without_files.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
;