-- 6. For each tag, show the tag name and the number of 
-- photos associated with that tag. Rank the tags by the number of photos in descending order.
USE ig_clone;

SELECT t.tag_name, COUNT(pt.photo_id) count_of_photo
FROM tags t 
LEFT JOIN photo_tags pt 
	ON t.id = pt.tag_id 
GROUP BY t.tag_name
ORDER BY count_of_photo
