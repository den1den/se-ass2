select DATE_FORMAT(d.`date`, "%a") as `Day`, count(r.createdtime) as `Created`, DATE_FORMAT(d.`date`, "%u") as `weeknumber`, DATE_FORMAT(d.`date`, "%w") as `day_of_week`
from
dates as d
LEFT join
(
SELECT DATE(rev_createdTime) as createdtime FROM t_revision order by DATE(rev_createdTime)
) as r
on d.date = createdtime
group by DATE_FORMAT(d.`date`, "%u"), DATE_FORMAT(d.`date`, "%w")
order by r.createdtime
