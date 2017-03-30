UPDATE `t_file` AS f 
SET 
    f.`t_isSource` = 1
WHERE
    SUBSTRING_INDEX(f.f_fileName, '.', - 1) IN ("py", "json", "js", "sh", "yaml","pp", "rb", "yml")
;
UPDATE `t_file` AS f 
SET 
    f.`t_isSource` = 0
WHERE
    SUBSTRING_INDEX(f.f_fileName, '.', - 1) IN ("html", "rst", "md", "java", "markdown", "pdf")
;
SELECT
	count(f.id) as cnt, 
    f.*,
    SUBSTRING_INDEX(f.f_fileName, '.', - 1) AS ext,
    SUBSTRING_INDEX(f.f_fileName, '/', - 1) AS filename
FROM
    `t_file` AS f
WHERE
    f.t_isSource is null
GROUP BY ext
order by cnt DESC
;