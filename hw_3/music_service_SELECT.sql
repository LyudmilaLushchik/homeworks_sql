--1. �������� � ��� ������ ��������, �������� � 2018 ����.
SELECT name, release_year FROM albums
	WHERE release_year = 2018;

--2. �������� � ����������������� ������ ����������� �����.
SELECT name, duration FROM tracks
	WHERE duration = (SELECT max(duration) FROM tracks);

--3. �������� ������, ����������������� ������� �� ����� 3,5 ������.	
SELECT name FROM tracks
	WHERE duration >= 210;

--4. �������� ���������, �������� � ������ � 2018 �� 2020 ��� ������������.	
SELECT name FROM mixes
	WHERE release_year BETWEEN 2018 AND 2020;

--5. �����������, ��� ��� ������� �� 1 �����.	
SELECT name FROM singers
	WHERE name NOT LIKE '% %';
	
--6. �������� ������, ������� �������� ����� "���"/"my".	
SELECT name FROM tracks
	WHERE name ILIKE '%my%' OR name ILIKE '%���%';