-- 1. How many times does the average user post?

WITH User_Post_Count AS (
	SELECT u.id, COUNT(p.id) Post_Count
    FROM users u 
    LEFT JOIN photos p 
    ON u.id = p.user_id
    GROUP BY u.id 
)

SELECT AVG(Post_Count) Avg_Posts_Per_User
FROM User_Post_Count

