
select talentManager1, streamerOpenID1, 
    sum(case when day >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) then hours else 0 end) as hours7D,
    sum(case when day >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY) then 1 else 0 end) as days7D,
    sum(case when day >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY) then hours else 0 end) as hours30D,
    sum(case when day >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY) then 1 else 0 end) as days30D,
    sum(case when day >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) then hours else 0 end) as hours90D,
    sum(case when day >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) then 1 else 0 end) as days90D,
from
(
   SELECT c.name as talentManager1, d.openID as streamerOpenID1, sum(duration)/3600 as hours, date(timestamp_seconds(beginTime), "America/Los_Angeles") as day
   FROM `media17-1119.mongodb.LiveStream` a
    Left join `media17-1119.mysql17admin.ContractedStreamer` b on a.userID = b.userID
    left join `media17-1119.mysql17admin.AdminUsers` c on c.id = b.agentID
    left join `media17-1119.mongodb.User` d on d.userID = b.userID
    left join `media17-1119.mysql17admin.Contract` e on e.userID = b.userID
   where c.region = 'US' and date(e.dateStart, 'America/Los_Angeles') <= current_date() and date(e.dateEnd, 'America/Los_Angeles') >= current_date() AND e.isDeleted = 0
   AND date(timestamp_seconds(beginTime), "America/Los_Angeles") >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) 
   group by c.name, d.openID, date(timestamp_seconds(beginTime), "America/Los_Angeles")
)
group by talentManager1, streamerOpenID1
