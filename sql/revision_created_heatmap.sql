SELECT 
    d.`date`
    , COUNT(s.id) as `count`
FROM
    dates AS d
        LEFT JOIN
    (
    SELECT 
        DATE(rev_createdTime) AS createdDate,
            DATE(rev_committedTime) AS committedDate,
            r.id
    FROM
        gm_libreoffice.t_revision AS r
    #WHERE DATE(rev_createdTime) >= '2016-09-00'
	#limit 10000
	) AS s ON s.createdDate <= d.`date`
        AND s.committedDate >= d.`date`
#where d.`date` >= '2016-09-05'
GROUP BY d.`date`
order by d.`date`