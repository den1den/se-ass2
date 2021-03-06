SELECT 
    'change_id',
    'ch_changeIdNum',
    'ch_project',
    'ch_branch',
    'ch_authorAccountId',
    'ch_createdTime',
    'ch_status',
    'ch_mergeable',
    'ch_review_period',
    'ch_last_revision_time',
    'ch_revision_count'

UNION ALL SELECT 
    c.id,
    ch_changeIdNum,
    ch_project,
    ch_branch,
    ch_authorAccountId,
    ch_createdTime,
    ch_status,
    ch_mergeable,
    TIMESTAMPDIFF(SECOND, c.ch_createdTime, MAX(r.rev_committedTime)) AS review_period,
    MAX(r.rev_committedTime) AS last_revision_time,
    MAX(r.rev_patchSetNum) AS revision_count
FROM
    gm_openstack.t_change AS c
        JOIN
    gm_openstack.t_revision AS r ON c.id = r.rev_changeId
GROUP BY c.id
HAVING
    TIMESTAMPDIFF(SECOND, c.ch_createdTime, MAX(r.rev_committedTime)) > 0
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/change_with_last_revision.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
;