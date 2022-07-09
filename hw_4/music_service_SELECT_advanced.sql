--1. Êîëè÷åñòâî èñïîëíèòåëåé â êàæäîì æàíðå.
SELECT name, COUNT(singer_id) singers_q FROM genres g
	JOIN genres_singers gs ON g.id = gs.genre_id
	GROUP BY g.name
	ORDER BY singers_q;

--2. Êîëè÷åñòâî òðåêîâ, âîøåäøèõ â àëüáîìû 2019-2020 ãîäîâ.
SELECT a.name, COUNT(t.id) tracks_q FROM albums a
	JOIN tracks t ON a.id = t.album_id 
	WHERE release_year IN (2019, 2020)
	GROUP BY a.name;

--3. Ñðåäíÿÿ ïðîäîëæèòåëüíîñòü òðåêîâ ïî êàæäîìó àëüáîìó.	
SELECT a.name, ROUND(AVG(t.duration), 2) duration_avg FROM albums a 
	JOIN tracks t ON a.id = t.album_id 
	GROUP BY a.name;

--4. Âñå èñïîëíèòåëè, êîòîðûå íå âûïóñòèëè àëüáîìû â 2020 ãîäó.
SELECT s.name FROM singers s 
	JOIN singers_albums sa ON s.id = sa.singer_id
	JOIN albums a ON sa.album_id = a.id
	WHERE a.release_year != 2020
	GROUP BY s.name;

--5. Íàçâàíèÿ ñáîðíèêîâ, â êîòîðûõ ïðèñóòñòâóåò êîíêðåòíûé èñïîëíèòåëü (Queen).
SELECT m.name FROM mixes m 
	JOIN mixes_tracks mt ON m.id = mt.mix_id
	JOIN tracks t ON mt.track_id = t.id
	JOIN albums a ON t.album_id = a.id 
	JOIN singers_albums sa ON a.id = sa.album_id 
	JOIN singers s ON sa.singer_id = s.id 
	WHERE s.name LIKE 'Queen'
	GROUP BY m.name;

--6. Íàçâàíèå àëüáîìîâ, â êîòîðûõ ïðèñóòñòâóþò èñïîëíèòåëè áîëåå 1 æàíðà.
SELECT a.name, COUNT(DISTINCT g.id) genre_q FROM albums a 
	JOIN singers_albums sa ON a.id = sa.album_id 
	JOIN singers s ON sa.singer_id = s.id 
	JOIN genres_singers gs ON s.id = gs.singer_id 
	JOIN genres g ON gs.genre_id = g.id 
	GROUP BY a.name
	HAVING COUNT(DISTINCT g.id) > 1
	ORDER BY a.name;

--7. Íàèìåíîâàíèå òðåêîâ, êîòîðûå íå âõîäÿò â ñáîðíèêè.
SELECT name, track_id track_in_mix FROM tracks t 
	LEFT JOIN mixes_tracks mt ON t.id = mt.track_id
	WHERE track_id IS NULL;	

--8. Èñïîëíèòåëÿ(-åé), íàïèñàâøåãî ñàìûé êîðîòêèé ïî ïðîäîëæèòåëüíîñòè òðåê. 
SELECT s.name, t.duration FROM singers s
	JOIN singers_albums sa ON s.id = sa.singer_id 
	JOIN albums a ON sa.album_id = a.id 
	JOIN tracks t ON a.id = t.album_id
	WHERE t.duration = (SELECT MIN(duration) FROM tracks);

--9. Íàçâàíèå àëüáîìîâ, ñîäåðæàùèõ íàèìåíüøåå êîëè÷åñòâî òðåêîâ.
SELECT a.name, COUNT(t.id) tracks_q FROM albums a 
	JOIN tracks t ON a.id = t.album_id 
	GROUP BY a.name
	HAVING COUNT(t.id) = (SELECT MIN(tracks_q) FROM 
		(SELECT a.name, COUNT(t.id) tracks_q FROM albums a 
		JOIN tracks t ON a.id = t.album_id 
		GROUP BY a.name) a1)	
	ORDER BY tracks_q;
