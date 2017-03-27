SELECT 
    c.id as ChangeId,
    COUNT(f.id) AS FilesChanged,
    SUM(f.f_linesInserted) AS TotalLinesInserted,
    SUM(f.f_linesDeleted) AS TotalLinesDeleted,
    MAX(f_revisionId) AS LastRevisionId,
    f.f_fileName LIKE '%.%' AS HasExtension,
    IFNULL(MAX(f.t_isSource), 0) > 0 as OnlySource,
    IFNULL(MIN(f.t_isSource), 1) = 0 as OnlyDocumentation,
    IFNULL(SUM(f.t_isSource), 0) > 0 AS ContainsSource
FROM
    gm_libreoffice.t_change AS c
        JOIN
    gm_libreoffice.t_file AS f ON f.f_revisionId = c.id
GROUP BY c.id
;