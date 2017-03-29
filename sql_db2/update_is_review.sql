UPDATE `t_history` AS h 
SET 
    h.is_review = 0,
    h.is_review2 = 0
WHERE
    h.is_review = 2
        AND !(h.hist_message LIKE '%Looks good to me, approved%'
        OR h.hist_message LIKE '%Do not submit%'
        OR h.hist_message LIKE '%Code-Review%')
LIMIT 2000000;

UPDATE `t_history` AS h 
SET 
    h.is_review = 1
WHERE
    h.is_review = 2
        AND (h.hist_message LIKE '%Looks good to me, approved%'
        OR h.hist_message LIKE '%Do not submit%'
        OR h.hist_message LIKE '%Code-Review%')
LIMIT 2000000;

UPDATE `t_history` AS h 
SET 
    h.is_review2 = 0
WHERE
    h.is_review = 0
    and h.is_review2 = 2
LIMIT 2000000;

UPDATE `t_history` AS h 
SET 
    h.is_review2 = 1
WHERE
    h.is_review2 = 2 and h.is_review = 1
        AND (h.hist_message LIKE '%Code-Review-2%'
		OR h.hist_message LIKE '%Code-Review+2%')
LIMIT 2000000;

UPDATE `t_history` AS h 
SET 
    h.is_review2 = 0
WHERE
    h.is_review2 = 2 and h.is_review = 1
        AND !( h.hist_message LIKE '%Code-Review-2%'
        OR h.hist_message LIKE '%Code-Review+2%') LIMIT 2000000;

SELECT "missing_is_review", count(*) FROM (
select is_review from `t_history` where is_review = 2
) as t
union SELECT "missing_is_review2", count(*) FROM (
select is_review from `t_history` where is_review2 = 2
) as t;