create database spotify;

use spotify;

select * from spotify_data;

ALTER TABLE spotify_data
RENAME TO spotify;


-- Basic Level Questions

-- Show all records from the spotify_data table.
select count(*) from spotify;

-- Show only song name and artist.
select song,artist from spotify;

-- Show top 10 records.
select * from spotify
limit 10;

-- Find total number of songs.
select count(song) from spotify;

-- Find total number of unique artists.
select DISTINCT artist from spotify;

-- Show all explicit songs.
select * from spotify where is_explicit = true;

-- Show all non-explicit songs.
select * from spotify where is_explicit = false;

-- Find songs with popularity greater than 80.
select song, artist,popularity from spotify where popularity > 80;


-- Find songs released after 2020.
select artist, song, release_date
from spotify 
where release_date > '2020-12-31'
order by release_date asc;

-- Show songs with position = 1.
select artist, song, release_date, position
from spotify
where position = 1
order by artist;


-- Intermediate Level Questions


-- Find top 10 most popular songs.
SELECT song,
       COUNT(*) AS total_songs,
       ROUND(max(popularity), 2) AS max_popularity
FROM spotify
GROUP BY song
ORDER BY max_popularity DESC
LIMIT 10;


-- Find top 10 most popular artists.
SELECT artist,
       COUNT(*) AS total_songs,
       ROUND(max(popularity), 2) AS max_popularity
FROM spotify
GROUP BY artist
ORDER BY max_popularity DESC
LIMIT 10;


-- Count how many songs each artist has.
SELECT artist, COUNT(*) AS total_songs
FROM spotify
GROUP BY artist
ORDER BY total_songs DESC;

-- Find average popularity of all songs.
SELECT song, avg(popularity) AS avg_songs
FROM spotify
GROUP BY song
ORDER BY avg_songs DESC;

-- Find maximum popularity.
SELECT song, max(popularity) AS max_songs
FROM spotify
GROUP BY song
ORDER BY max_songs DESC;

-- Find minimum popularity.
SELECT song, min(popularity) AS min_songs
FROM spotify
GROUP BY song
ORDER BY min_songs DESC;

-- Find average song duration
SELECT song, avg(`duration_ms`) AS avg_duration_ms
FROM spotify
GROUP BY song
ORDER BY avg_duration_ms DESC;

-- Find longest song.
SELECT song, max(`duration_ms`) AS max_duration_ms
FROM spotify
GROUP BY song
ORDER BY max_duration_ms DESC
limit 1;

-- Find shortest song.
SELECT song, min(`duration_ms`) AS min_duration_ms
FROM spotify
GROUP BY song
ORDER BY min_duration_ms DESC
limit 1;

-- Find total songs for each album_type.
select album_type, count(album_type) as total_album_type
from spotify
group by album_type
order by total_album_type desc;

-- Filtering Questions

-- Find songs with popularity between 70 and 90.
select song, popularity
from  spotify
where popularity between  70 and 90
order by popularity  desc;

-- Find songs where artist name starts with 'A'.
select artist, song
from spotify
where artist LIKE 'a%';

-- Find songs where song name contains "Love".
select artist,song
from spotify
where song LIKE 'Love%';

-- Find songs released in 2023.
SELECT artist, song 
FROM spotify 
WHERE release_date BETWEEN '1/1/2023' AND '31/12/2023';

-- Find explicit songs with popularity greater than 80.
SELECT song, artist
FROM spotify
WHERE is_explicit = TRUE AND popularity > 80;

-- Group By Questions

-- Count number of songs per artist.
select artist, count(song) as total_songs
from spotify
group by artist
order by total_songs desc;

-- Find average popularity per artist.
select artist, avg(popularity) as avg_popularity
from spotify
group by artist
order by avg_popularity desc;

-- Find max popularity per artist.
select artist, max(popularity) as max_popularity
from spotify
group by artist
order by max_popularity desc;

-- Find total songs per release year.SELECT 
    SELECT CASE
        WHEN release_date LIKE '%/%/%' THEN SUBSTR(release_date, -4)
        WHEN release_date LIKE '____-%' THEN SUBSTR(release_date, 1, 4)
        ELSE SUBSTR(release_date, 1, 4) 
    END AS release_year, 
    COUNT(*) AS total_songs
FROM spotify
GROUP BY release_year
ORDER BY release_year DESC;

-- Find number of explicit songs per artist.
SELECT 
    artist, 
    COUNT(song) AS total_explicit_songs
FROM 
    spotify
WHERE 
    is_explicit = TRUE  -- or 1 depending on your database
GROUP BY 
    artist
ORDER BY 
    total_explicit_songs DESC;

-- Ranking Questions

-- Find top 5 artists with most songs.
select artist, count(song) total_songs
from spotify
group by artist
order by total_songs DESC
limit 5;

-- Find top 5 longest songs.
SELECT song, artist, MAX(duration_ms) AS duration_ms
FROM spotify
GROUP BY song, artist
ORDER BY duration_ms DESC
LIMIT 5;

-- Find top 5 shortest songs.
SELECT song, artist, min(duration_ms) AS duration_ms
FROM spotify
GROUP BY song, artist
ORDER BY duration_ms DESC
LIMIT 5;

-- Find top 5 most popular explicit songs.
SELECT song, artist, MAX(popularity) AS max_popularity
FROM spotify
WHERE is_explicit = TRUE
GROUP BY song, artist
ORDER BY max_popularity DESC
LIMIT 5;

-- Find top 5 most popular non-explicit songs.
SELECT song, artist, MAX(popularity) AS max_popularity
FROM spotify
WHERE is_explicit = false
GROUP BY song, artist
ORDER BY max_popularity DESC
LIMIT 5;

-- Business Insight Questions (Real Analyst Level)

-- Which artist appears most in Rank 1 position?
SELECT artist, COUNT(*) AS rank_1_count
FROM spotify
WHERE position = 1
GROUP BY artist
ORDER BY rank_1_count DESC
LIMIT 1;

-- Which album_type has highest average popularity?
select album_type, max(popularity) as max_popularity
from spotify
GROUP BY album_type
ORDER BY max_popularity DESC;

-- Which year has most song releases?
SELECT 
    CASE 
        WHEN release_date LIKE '%/%/%' THEN SUBSTR(release_date, -4)
        WHEN release_date LIKE '____-%' THEN SUBSTR(release_date, 1, 4)
        ELSE SUBSTR(release_date, 1, 4) 
    END AS release_year, 
    COUNT(*) AS song_count
FROM spotify
GROUP BY release_year
ORDER BY song_count DESC
LIMIT 1;

-- Which artist has highest average popularity?
select artist, avg(popularity) as highest_average_popularity
FROM spotify
GROUP BY artist
ORDER BY highest_average_popularity DESC
limit 1;

-- Which artist has longest average song duration?
select artist, avg(duration_ms) as highest_average_duration_ms
FROM spotify
GROUP BY artist
ORDER BY  highest_average_duration_ms DESC
limit 1;

-- Advanced Questions

-- Find duplicate songs.
SELECT song,artist,COUNT(*) AS occurrence_count
FROM spotify
GROUP BY song, artist
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

-- Find artists with more than 50 songs.
select artist, COUNT(distinct song) as count_of_songs
FROM spotify group by artist
having count_of_songs > 50
ORDER BY count_of_songs DESC;

-- Find songs with popularity above average popularity.
SELECT DISTINCT song, artist, popularity
FROM spotify
WHERE popularity > (SELECT AVG(popularity) FROM spotify)
ORDER BY popularity DESC;

-- Find artists whose average popularity is above 80.
SELECT artist, AVG(popularity) AS avg_popularity
FROM spotify
GROUP BY artist
HAVING avg_popularity > 80
ORDER BY avg_popularity DESC;

-- Find top artist for each year.
WITH year_artist_counts AS (
    SELECT 
        CASE 
            WHEN release_date LIKE '%/%/%' THEN SUBSTR(release_date, -4)
            WHEN release_date LIKE '____-%' THEN SUBSTR(release_date, 1, 4)
            ELSE SUBSTR(release_date, 1, 4) 
        END AS release_year,
        artist,
        COUNT(*) AS entry_count
    FROM spotify
    GROUP BY release_year, artist
),
ranked_artists AS (
    SELECT 
        release_year, artist, entry_count,
        RANK() OVER (PARTITION BY release_year ORDER BY entry_count DESC) AS rnk
    FROM year_artist_counts
)
SELECT release_year, artist, entry_count
FROM ranked_artists
WHERE rnk = 1
ORDER BY release_year DESC;
