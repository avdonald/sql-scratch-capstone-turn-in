--Quiz Funnel--

SELECT *
FROM survey
LIMIT 10;

SELECT question,
   COUNT(DISTINCT user_id)
FROM survey
GROUP BY question;

--Home Try-On Funnel--

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS q
LEFT JOIN home_try_on AS h
   ON q.user_id = h.user_id
LEFT JOIN purchase AS p
   ON p.user_id = q.user_id
LIMIT 10;

--With Funnel--

WITH funnel AS(
	SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz AS 'q'
	LEFT JOIN home_try_on AS 'h'
   ON q.user_id = h.user_id
	LEFT JOIN purchase AS 'p'
   ON p.user_id = q.user_id)
SELECT COUNT(*) AS 'num_users',
SUM(is_home_try_on) AS 'num_try_on',
SUM(is_purchase) AS 'num_purchase',
1.0 * SUM(is_home_try_on) / COUNT(user_id) AS 'per_user_try_on',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS 'per_purchase_try_on'
FROM funnel;