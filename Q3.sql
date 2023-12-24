-- 3. Find users who have liked every single photo on the site.

USE ig_clone;
SELECT u.id, u.username
FROM users u 
INNER JOIN photos p 
	ON u.id = p.user_id
LEFT JOIN likes l 
	ON p.id = l.photo_id
GROUP BY u.id, u.username
HAVING COUNT(DISTINCT p.id) = COUNT(l.photo_id)
ORDER BY u.id
