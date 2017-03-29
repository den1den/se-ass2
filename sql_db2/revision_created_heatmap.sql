SELECT
DATE_FORMAT(t.`date`, "%Y-%m-01"),
sum(t.`count`)
FROM
(
SELECT 
    d.`date`
    , COUNT(s.id) as `count`
FROM
    dates AS d
        left JOIN
    (
    SELECT 
        DATE(rev_createdTime) AS createdDate,
            DATE(rev_committedTime) AS committedDate,
            r.id
    FROM
        gm_openstack.t_revision AS r
    #WHERE DATE(rev_createdTime) >= '2016-09-00'
	#limit 100
	) AS s ON s.createdDate <= d.`date`
        AND s.committedDate >= d.`date`
#where d.`date` >= '2016-09-05'
GROUP BY d.`date`
) as t
group by DATE_FORMAT(t.`date`, "%Y-%m")
order by t.`date`