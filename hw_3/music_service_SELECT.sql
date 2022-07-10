-- 1. Название и год выхода альбомов, вышедших в 2018 году.
SELECT name, release_year FROM albums
	WHERE release_year = 2018;

-- 2. Название и продолжительность самого длительного трек.
SELECT name, duration FROM tracks
	WHERE duration = (SELECT max(duration) FROM tracks);

-- 3. Название треков, продолжительность которых не менее 3,5 минуты.
SELECT name FROM tracks
	WHERE duration >= 210;

-- 4. Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name FROM mixes
	WHERE release_year BETWEEN 2018 AND 2020;

-- 5. Исполнители, чье имя состоит из 1 слова.
SELECT name FROM singers
	WHERE name NOT LIKE '% %';

-- 6. Название треков, которые содержат слово "мой"/"my".
SELECT name FROM tracks
	WHERE name ILIKE '%my%' OR name ILIKE '%мой%';