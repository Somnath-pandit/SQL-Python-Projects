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
