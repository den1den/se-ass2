SELECT 
c.id,
 ch_changeIdNum ,
 ch_project,
 ch_branch, 
 ch_authorAccountId,
 ch_createdTime,
 ch_status,
 ch_mergeable,
 TIMEDIFF(MAX(r.rev_committedTime),c.ch_createdTime),
 MAX(r.rev_committedTime) - c.ch_createdTime,
 r.rev_committedTime,
 r.rev_patchSetNum
FROM
    gm_libreoffice.t_change AS c
        LEFT JOIN
    gm_libreoffice.t_revision AS r ON c.id = r.rev_changeId
GROUP BY c.id
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/change_with_last_revision.csv'
FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';