-- artists.xml

CREATE TABLE artists (
       id BIGINT PRIMARY KEY,
       name TEXT,
       realname TEXT,
       data_quality TEXT,
       urls list<TEXT>,
       name_variation list<TEXT>,
       aliases list<tuple<BIGINT, TEXT>>
);
