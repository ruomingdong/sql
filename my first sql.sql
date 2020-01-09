SELECT *, totalTime / c as avgTIme
FROM
(
SELECT date_trunc(date(timestamp_seconds(beginTime)), month) month, count(*) c, sum(duration)/3600 as totalTime
FROM `media17-1119.mongodb.LiveStream` a
where userID NOt In (select userID from `media17-1119.mysql17admin.ContractedStreamer` ) and region="US"
group by date_trunc(date(timestamp_seconds(beginTime)), month)
LIMIT 1000
) t1
order by month desc
