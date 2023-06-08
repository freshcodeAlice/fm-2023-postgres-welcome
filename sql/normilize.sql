DROP TABLE test;

CREATE TABLE test (   
    v varchar(13),
    t int,
    UNIQUE (v,t)
);   --- 1NF!

INSERT INTO test VALUES ('test', 1),
('abracadabra', 2),
('test', 3);


-----