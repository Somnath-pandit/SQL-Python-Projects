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
