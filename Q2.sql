-- 2. Find the top 5 most used hashtags.
USE ig_clone;
SELECT tag_name, COUNT(*) tags_count
FROM tags
GROUP BY tag_name
ORDER BY tags_count
LIMIT 5


