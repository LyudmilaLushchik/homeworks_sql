-- 1. Количество исполнителей в каждом жанре.
SELECT name, COUNT(singer_id) singers_q FROM genres g
	JOIN genres_singers gs ON g.id = gs.genre_id
	GROUP BY g.name
	ORDER BY singers_q;

-- 2. Количество треков, вошедших в альбомы 2019-2020 годов.
SELECT a.name, COUNT(t.id) tracks_q FROM albums a
	JOIN tracks t ON a.id = t.album_id 
	WHERE release_year IN (2019, 2020)
	GROUP BY a.name;

-- 3. Средняя продолжительность треков по каждому альбому.
SELECT a.name, ROUND(AVG(t.duration), 2) avg_duration FROM albums a 
	JOIN tracks t ON a.id = t.album_id 
	GROUP BY a.name;

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT s.name FROM singers s 
	JOIN singers_albums sa ON s.id = sa.singer_id
	JOIN albums a ON sa.album_id = a.id
	WHERE a.release_year != 2020
	GROUP BY s.name;

-- 5. Названия сборников, в которых присутствует исполнитель 'Queen'.
SELECT m.name FROM mixes m 
	JOIN mixes_tracks mt ON m.id = mt.mix_id
	JOIN tracks t ON mt.track_id = t.id
	JOIN albums a ON t.album_id = a.id 
	JOIN singers_albums sa ON a.id = sa.album_id 
	JOIN singers s ON sa.singer_id = s.id 
	WHERE s.name LIKE 'Queen'
	GROUP BY m.name;

-- 6. Название альбомов, в которых присутствуют исполнители более 1 жанра.
SELECT a.name, COUNT(DISTINCT g.id) genre_q FROM albums a 
	JOIN singers_albums sa ON a.id = sa.album_id 
	JOIN singers s ON sa.singer_id = s.id 
	JOIN genres_singers gs ON s.id = gs.singer_id 
	JOIN genres g ON gs.genre_id = g.id 
	GROUP BY a.name
	HAVING COUNT(DISTINCT g.id) > 1
	ORDER BY a.name;

-- 7. Наименование треков, которые не входят в сборники.
SELECT name, track_id track_in_mix FROM tracks t 
	LEFT JOIN mixes_tracks mt ON t.id = mt.track_id
	WHERE track_id IS NULL;	

-- 8. Исполнителя(-ей), написавшего самый короткий по продолжительности трек.
SELECT s.name, t.duration FROM singers s
	JOIN singers_albums sa ON s.id = sa.singer_id 
	JOIN albums a ON sa.album_id = a.id 
	JOIN tracks t ON a.id = t.album_id
	WHERE t.duration = (SELECT MIN(duration) FROM tracks);

-- 9. Название альбомов, содержащих наименьшее количество треков.
SELECT a.name, COUNT(t.id) tracks_q FROM albums a 
	JOIN tracks t ON a.id = t.album_id 
	GROUP BY a.name
	HAVING COUNT(t.id) = (SELECT min(tracks_q) FROM 
		(SELECT a.name, COUNT(t.id) tracks_q FROM albums a 
		JOIN tracks t ON a.id = t.album_id 
		GROUP BY a.name) a1) 
	ORDER BY tracks_q;