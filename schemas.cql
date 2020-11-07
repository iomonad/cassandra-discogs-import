-- schemas

CREATE TABLE IF NOT EXISTS artists (
       id BIGINT PRIMARY KEY,
       name TEXT,
       realname TEXT,
       data_quality TEXT,
       urls list<TEXT>,
       name_variation list<TEXT>,
       aliases list<tuple<BIGINT, TEXT>>
);

CREATE TABLE IF NOT EXISTS labels (
       id BIGINT PRIMARY KEY,
       name TEXT,
       contactinfo TEXT,
       profile TEXT,
       data_quality TEXT,
       urls list<TEXT>,
       sublabels list<tuple<BIGINT, TEXT>>
);

CREATE TABLE IF NOT EXISTS masters (
       id BIGINT PRIMARY KEY,
       childs list<BIGINT> -- releases id
);


CREATE TABLE IF NOT EXISTS releases (
       id BIGINT PRIMARY KEY,
       artists list<BIGINT>, -- artist id
       title TEXT,
       label tuple<TEXT, BIGINT>, -- CATNO / ID
       genre list<TEXT>,
       styles list<TEXT>,
       country TEXT,
       release_date TEXT,
       master_release BIGINT,
);
