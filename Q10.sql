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
