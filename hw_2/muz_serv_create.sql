CREATE TABLE IF NOT EXISTS genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS singers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL    
);

CREATE TABLE IF NOT EXISTS genres_singers (       
    genre_id INTEGER REFERENCES genres(id),
    singer_id INTEGER REFERENCES singers(id),
    CONSTRAINT gs PRIMARY KEY (genre_id, singer_id)
);

CREATE TABLE IF NOT EXISTS albums (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    release_year INTEGER NOT NULL    
);

CREATE TABLE IF NOT EXISTS singers_albums (        
    singer_id INTEGER REFERENCES singers(id),
    album_id INTEGER REFERENCES albums(id),
    CONSTRAINT sa PRIMARY KEY (singer_id, album_id)
);

CREATE TABLE IF NOT EXISTS mixes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    release_year INTEGER NOT NULL    
);

CREATE TABLE IF NOT EXISTS tracks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(90) NOT NULL,
    duration INTERVAL MINUTE TO SECOND NOT NULL,    
    album_id INTEGER REFERENCES albums(id)
);

CREATE TABLE IF NOT EXISTS mixes_tracks (        
    mix_id INTEGER REFERENCES mixes(id),
    track_id INTEGER REFERENCES tracks(id),
    CONSTRAINT mt PRIMARY KEY (mix_id, track_id)
);


