-- All list of metrics events for visits that
--  1) ended with reactive engagement
--  2) did not end with reactive engagement

-- Bring the data from the DB
-- Sort by visitor & event time
-- Iterate over events and put them into a string
SELECT metrics_events.name, visits.visitor_id, metrics_events.created_at
FROM metrics_events
INNER JOIN visits ON visits.visitor_id = metrics_events.originator_id
INNER JOIN engagements ON engagements.visit_id = visits.visitor_id
WHERE metrics_events.originator_type = 'Salemove::Models::Visitor'
  AND engagements.initiator = 'visitor'
LIMIT 10


-- metrics_events.name veerule panin indeksi peale
SELECT COUNT(DISTINCT metrics_events.name) AS event_name, visits.id AS visit_id FROM metrics_events
JOIN visitors ON visitors.id = metrics_events.originator_id
JOIN visits ON visits.visitor_id = visitors.id
JOIN engagements ON engagements.visitor_id = visits.visitor_id
WHERE metrics_events.originator_type = 'Salemove::Models::Visitor'
  AND engagements.initiator = 'visitor'
GROUP BY metrics_events.name, visits.id
LIMIT 10

SELECT metrics_events.name,
      COUNT(*) AS count,
      visits.id AS visit_id
FROM metrics_events
JOIN visitors ON visitors.id = metrics_events.originator_id
JOIN visits ON visits.visitor_id = visitors.id
JOIN engagements ON engagements.visitor_id = visitors.id
WHERE metrics_events.originator_type = 'Salemove::Models::Visitor'
  AND engagements.initiator = 'visitor'
  AND metrics_events.created_at > date '2014-04-10'
  AND engagements.created_at > date '2014-04-10'
  AND visits.created_at > date '2014-04-10'
GROUP BY metrics_events.name, visits.id
LIMIT 10


SELECT * FROM metrics_events WHERE created_at > date '2014-04-10' LIMIT 10



SELECT metrics_events.name, COUNT(*) AS cnt, visitors.id AS visitor_id, visits.id AS visit_id
FROM metrics_events
LEFT JOIN visitors ON visitors.id = metrics_events.originator_id
LEFT JOIN engagements ON engagements.visitor_id = visitors.id AND engagements.initiator = 'visitor'
LEFT JOIN visits ON visits.id = engagements.visit_id
WHERE metrics_events.originator_type = 'Salemove::Models::Visitor'
  AND metrics_events.created_at > date '2014-04-10'
  AND engagements.created_at > date '2014-04-10'
  AND visits.created_at > date '2014-04-10'
GROUP BY metrics_events.name, visitors.id, visits.id
LIMIT 10;
