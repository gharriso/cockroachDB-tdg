DROP INDEX fname_idx;
DROP INDEX lname_idx;
DROP INDEX flname_idx;
EXPLAIN ANALYZE SELECT * FROM person WHERE firstname='John' AND lastname='Wood';

CREATE INDEX fname_idx ON person (firstname);
 

EXPLAIN ANALYZE SELECT * FROM person WHERE firstname='John' AND lastname='Wood';

CREATE INDEX lname_idx ON person (lastname);

EXPLAIN ANALYZE SELECT * FROM person WHERE firstname='John' AND lastname='Wood';

CREATE INDEX flname_idx ON person (lastname,firstname);
EXPLAIN ANALYZE SELECT * FROM person WHERE firstname='John' AND lastname='Wood';

