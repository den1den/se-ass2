SELECT 
    'p_id',
    'p_accountId',
    'p_name',
    'p_email',
    'p_userName',
    'p_change_activity',
    'p_ecosystem_tenure'
UNION ALL SELECT
    p.*,
    COUNT(c.id),
    TIMESTAMPDIFF(SECOND,
        MIN(c.ch_createdTime),
        NOW())
FROM
    gm_openstack.t_people AS p
        JOIN
    gm_openstack.t_change AS c ON c.ch_authorAccountId = p.p_accountId
GROUP BY p.id
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/people_with_changes.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
;