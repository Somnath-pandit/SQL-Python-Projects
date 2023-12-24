-- 4. Retrieve a list of users along with their usernames and the 
-- rank of their account creation, ordered by the creation date in ascending order.

SELECT *,
		RANK() OVER (ORDER BY created_at) ac_creation_rank
FROM users
ORDER BY created_at