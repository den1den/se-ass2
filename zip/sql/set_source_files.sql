UPDATE `t_file` AS f 
SET 
    f.`t_isSource` = 1
WHERE
    SUBSTRING_INDEX(f.f_fileName, '.', - 1) IN ("ui", "xhp", "c", "xcu")
    #SUBSTRING_INDEX(f.f_fileName, '/', - 1) LIKE "%makefile%"
    # 1 ext = cxx hxx idl java ('h', 'src', 'hrc') cpp sdi hpp py "ui", "xhp", "c", "xcu"
    # 1 filename = makefile
    # 0 ext = png pptx svg docx txt gif "doc", "xls", "ppt", "xlsx", "docx", "pptx", "txt", "gif", "html"
    # 0 filename = changelog readme
    # NULL ext = xml
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