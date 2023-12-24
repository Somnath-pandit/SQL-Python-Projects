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
	

-- 2. Find the top 5 most used hashtags.
USE ig_clone;
SELECT tag_name, COUNT(*) tags_count
FROM tags
GROUP BY tag_name
ORDER BY tags_count
LIMIT 5


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


-- 4. Retrieve a list of users along with their usernames and the 
-- rank of their account creation, ordered by the creation date in ascending order.

SELECT *,
		RANK() OVER (ORDER BY created_at) ac_creation_rank
FROM users
ORDER BY created_at



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




-- 6. For each tag, show the tag name and the number of 
-- photos associated with that tag. Rank the tags by the number of photos in descending order.
USE ig_clone;

SELECT t.tag_name, COUNT(pt.photo_id) count_of_photo
FROM tags t 
LEFT JOIN photo_tags pt 
	ON t.id = pt.tag_id 
GROUP BY t.tag_name
ORDER BY count_of_photo



-- 7. List the usernames of users who have posted photos along 
-- with the count of photos they have posted. Rank them by the number of photos in descending order.


USE ig_clone;
SELECT u.username, COUNT(p.id) AS photo_count
FROM users u
LEFT JOIN photos p 
	ON u.id = p.user_id
GROUP BY u.username
ORDER BY photo_count DESC;



-- 8. Display the username of each user along with the
-- creation date of their first posted photo and the creation date of their next posted photo.

USE ig_clone;

WITH UserPhotoDates AS (
    SELECT
        p.user_id,
        MIN(p.created_at)  first_photo_date,
        LEAD(MIN(p.created_at)) OVER (PARTITION BY p.user_id ORDER BY MIN(p.created_at))  next_photo_date
    FROM photos p
    GROUP BY p.user_id
)

SELECT
    u.username,
    upd.first_photo_date,
    upd.next_photo_date
FROM users u
INNER JOIN UserPhotoDates upd
	ON u.id = upd.user_id;



-- 9. For each comment, show the comment text, the username of the commenter, 
-- and the comment text of the previous comment made on the same photo.

WITH CommentWithPrevious AS (
    SELECT
		u.username AS commenter_username,
        c1.comment_text AS current_comment_text,
			LAG(c1.comment_text) OVER (PARTITION BY c1.photo_id ORDER BY c1.created_at) AS previous_comment_text
    FROM comments c1
    INNER JOIN users u 
		ON c1.user_id = u.id
)

SELECT
    current_comment_text,
    commenter_username,
    previous_comment_text
FROM
    CommentWithPrevious;



 -- 10.Show the username of each user along with the number 
 -- of photos they have posted and the number of photos posted by the user
 -- before them and after them, based on the creation date.

USE ig_clone;
WITH UserPhotoCounts AS (
    SELECT
        u.id,
        u.username,
        COUNT(p.id)  photo_count,
        MIN(p.created_at) first_photo_date
        
    FROM users u
    LEFT JOIN photos p ON u.id = p.user_id
    GROUP BY u.id, u.username
),
UserPhotoCountsPrevNext AS (
    SELECT
        upc.*,
        ROW_NUMBER() OVER (ORDER BY upc.first_photo_date) AS rw_number
    FROM UserPhotoCounts upc
)

SELECT
    upc.username,
    upc.photo_count,
    LAG(upc.photo_count) OVER (ORDER BY upc.rw_number) AS prev_photo_count,
    LEAD(upc.photo_count) OVER (ORDER BY upc.rw_number) AS next_photo_count
FROM UserPhotoCountsPrevNext upc
ORDER BY upc.rw_number;

