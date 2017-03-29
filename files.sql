select t.*
from
(
SELECT 
    f.*,
    f.f_fileName LIKE "%.%" as HasExtension,
	SUBSTRING_INDEX(f.f_fileName,'.',-1) as FileExntension,
    COUNT(f.id) as cnt
FROM
    t_file as f
where t_isSource is NULL
group by SUBSTRING_INDEX(f.f_fileName,'.', -1)
) as t
order by t.cnt DESC
    #join
    #gm_libreoffice.t_change as c
    #on f.f_revisionId=c.id
    #group by c.id;