								                              #  Week 2 - Mandatory Project  # 


#1 Create an ER diagram or draw a schema for the given database.


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#2 We want to reward the user who has been around the longest, Find the 5 oldest users.

select * from users
order by created_at
limit 5;

-- ------------------------------------------------------------------------------------------------------------------------------------ --


#3 To understand when to run the ad campaign, figure out the day of the week most users register on? 

 SELECT
    WEEKDAY(created_at), dayname((created_at)) day_name, COUNT(WEEKDAY(created_at)) no_of_register
FROM users
GROUP BY WEEKDAY(created_at)
ORDER BY COUNT(WEEKDAY(created_at)) DESC;


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#4 To target inactive users in an email ad campaign, find the users who have never posted a photo.

SELECT *
FROM users
WHERE id NOT IN (SELECT user_id FROM photos);


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#5 Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

select u.username, l.photo_id, p.image_url, count(l.user_id) as likes
from users u
join photos p
on u.id = p.user_id
join likes l
on p.id = l.photo_id
group by l.photo_id
order by count(l.user_id) desc limit 1;


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#6 The investors want to know how many times does the average user post.

select
( select count(*) from photos ) / ( select count(*) from users ) as Avg ;


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#7 A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

select pt.tag_id, t.tag_name, count(pt.photo_id)
from photo_tags pt
join tags t
on pt.tag_id = t.id
group by tag_id
order by count(pt.photo_id) desc limit 5;


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#8 To find out if there are bots, find users who have liked every single photo on the site.
select u.id, u.username
from users u
join likes l
on u.id = l.user_id
group by l.user_id
having count(l.photo_id) = (select count(distinct photo_id) from likes)
order by u.id;


select id, username
from users
where id in (
	select user_id
	from likes
	group by user_id
	having count(photo_id) = (
		select count(distinct photo_id)
        from likes
	)
);


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#9 To know who the celebrities are, find users who have never commented on a photo.
select id, username
from users
where id not in (
	select distinct(user_id) from comments
)
order by id;


select u.id, u.username 
from users u
   left join comments c 
on u.id = c.user_id
where c.comment_text is null 
order by id ;


-- ------------------------------------------------------------------------------------------------------------------------------------ --


#10 Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.


select u.id, u.username, count(c.user_id) n_comments
from users u
left join comments c
on u.id = c.user_id
group by u.id
having count(c.user_id) = (select count(distinct (photo_id)) from comments) or count(c.user_id) = 0
order by count(c.user_id), u.id;


-- ------------------------------------------------------------------------------------------------------------------------------------ --

