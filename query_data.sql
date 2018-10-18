-- Find the 5 oldest users
SELECT * FROM users
ORDER BY created_at ASC
LIMIT 5;

-- Most popular registration date
SELECT 
	DAYNAME(created_at) AS Day,
	COUNT(*) AS Total
FROM users
GROUP BY Day
ORDER BY Total DESC;

-- Identify inactive users (Users with no posted photos)

SELECT 
	username
FROM users
LEFT JOIN photos
	ON users.id = photos.user_id
WHERE photos.image_url IS NULL;

-- User with most likes on a single photo

SELECT 
	username,
	photos.id,
	photos.image_url,
	COUNT(likes.user_id) AS Total
FROM photos
INNER JOIN likes
	ON likes.photo_id = photos.id
INNER JOIN users
	ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY Total DESC
LIMIT 1;

-- Average number of photos per user

SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS Average;

-- 5 mots commonly used hashtags

SELECT 
	tags.tag_name,
	COUNT(*) AS Total
FROM photo_tags
INNER JOIN tags
	ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY COUNT(*) DESC
LIMIT 5;


-- Finding Bots - users who have liked every single photo
SELECT 
	username,
	COUNT(*) AS num_likes
FROM users
INNER JOIN likes
	ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);