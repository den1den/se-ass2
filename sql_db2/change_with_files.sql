SELECT 
    'change_id',
    'ch_files_changed',
    'ch_total_lines_inserted',
    'ch_total_lines_deleted',
    'ch_last_revision_id',
    'ch_only_source',
    'ch_only_documentation',
    'ch_contains_source'
UNION ALL SELECT 
    c.id as ChangeId,
    COUNT(f.id) AS FilesChanged,
    SUM(f.f_linesInserted) AS TotalLinesInserted,
    SUM(f.f_linesDeleted) AS TotalLinesDeleted,
    MAX(f_revisionId) AS LastRevisionId,
    IFNULL(MAX(f.t_isSource), 0) > 0 as OnlySource,
    IFNULL(MIN(f.t_isSource), 1) = 0 as OnlyDocumentation,
    IFNULL(SUM(f.t_isSource), 0) > 0 AS ContainsSource
FROM
    gm_openstack.t_change AS c
        JOIN
    gm_openstack.t_file AS f ON f.f_revisionId = c.id
GROUP BY c.id
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/change_with_files.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
;