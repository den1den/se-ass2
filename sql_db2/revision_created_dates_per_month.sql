select DATE_FORMAT(d.`date`, "%Y-%m"), count(r.createdtime)
from
dates as d
left join
(
SELECT DATE(rev_createdTime) as createdtime FROM t_revision order by DATE(rev_createdTime)
) as r
on d.date = createdtime
group by DATE_FORMAT(d.`date`, "%Y-%m")
