SELECT contractGroup, avg(pointsReceivedLifetime) as avgPoints, count(*) as numStreamers
FROM
(
  SELECT name, t3.userID, contractGroup, sum(point) as pointsReceivedLifetime
  FROM
  (
    SELECT id, name, userID,   case when date(createdDate) >= "2019-11-01" then "new" else "old" end as contractGroup
    FROM
    (
      SELECT id, name, userID, min(timeCreated) as createdDate
      FROM
      (
        SELECT b.name as b, a.*, date(c.dateStart) a, date(c.dateEnd) c, DATE_DIFF(date(c.dateEnd), date(c.dateStart), MONTH)+1 as duration, c.others as oij
        FROM `media17-1119.mysql17admin.ContractedStreamer` a
          LEFT JOIN `media17-1119.mysql17admin.AdminUsers` b ON (a.agentID=b.id)
          LEFT JOIN `media17-1119.mysql17admin.Contract` c on (a.id = c.streamerID)
        WHERE b.region='US' and date(timeCreated) >= "2019-08-01"
      ) t1
      GROUP BY id, name, userID
    ) t2
    ORDER BY contractGroup ASC
  ) t3
  LEFT JOIN `media17-1119.mysql.PointUsageLog` t4 ON t3.userID=t4.receiverUserID
  WHERE (date(timestamp_seconds(timestamp)) >= "2019-11-01" AND contractGroup = "new")
   OR (date(timestamp_seconds(timestamp)) >= "2019-08-01" AND date(timestamp_seconds(timestamp)) < "2019-09-10" AND contractGroup = "old")
  GROUP BY name, t3.userID, contractGroup
)
GROUP BY contractGroup
