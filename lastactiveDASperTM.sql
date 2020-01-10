SELECT *, case when maxDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY) then 1 else 0 end as recently3days
FROM
(
  SELECT c.name, d.openID, max(date(timestamp_seconds(beginTime), "America/Los_Angeles")) as maxDate
  FROM `media17-1119.mongodb.LiveStream` a
  LEFT JOIN `media17-1119.mysql17admin.ContractedStreamer` b ON a.userID = b.userID
  LEFT JOIN `media17-1119.mysql17admin.AdminUsers` c ON c.id=b.agentID
  LEFT JOIN `media17-1119.mongodb.User` d ON d.userID=b.userID
  LEFT JOIN `media17-1119.mysql17admin.Contract` e on e.userID = b.userID
  WHERE c.region="US" and DATE(e.dateStart, "America/Los_Angeles") <= CURRENT_DATE() AND DATE(e.dateEnd, "America/Los_Angeles") >= CURRENT_DATE() AND e.isDeleted=0
  GROUP BY c.name, d.openID
  ORDER BY maxDate DESC
)
ORDER BY name ASC, recently3days DESC, maxDate DESC
