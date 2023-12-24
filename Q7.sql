-- 7. List the usernames of users who have posted photos along 
-- with the count of photos they have posted. Rank them by the number of photos in descending order.


USE ig_clone;
SELECT u.username, COUNT(p.id) AS photo_count
FROM users u
LEFT JOIN photos p 
	ON u.id = p.user_id
GROUP BY u.username
ORDER BY photo_count DESC;
