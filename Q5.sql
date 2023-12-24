-- 5. List the comments made on photos with their comment texts, 
-- photo URLs, and usernames of users who posted the comments. Include the comment count for each photo
USE ig_clone;

SELECT c.comment_text, p.image_url, u.username,
	   (SELECT COUNT(*) 
        FROM comments c2 
        WHERE c2.photo_id = c.photo_id) count_of_comment
FROM comments c
INNER JOIN photos p 
	ON c.user_id = p.user_id
INNER JOIN users u 
	ON p.user_id = u.id


