CREATE TYPE enum_gender AS ENUM('m','f','o');

CREATE TABLE IF NOT EXISTS people (
    p_id BIGSERIAL PRIMARY KEY,
    p_name TEXT NOT NULL,
    p_gender enum_gender NOT NULL,
    p_age INT NOT NULL,

    CHECK (p_age > 0)
);

INSERT INTO people
(
    p_name,
    p_gender,
    p_age
)
VALUES
    ('Robert', 'm'::enum_gender, 10),
    ('John', 'm'::enum_gender, 30),
    ('William', 'm'::enum_gender, 20),
    ('Eric', 'm'::enum_gender, 30),
    ('Louise', 'f'::enum_gender, 40),
    ('Anna', 'f'::enum_gender, 60),
    ('Samara', 'f'::enum_gender, 30)
;

-- print, for every gender, all the columns referring to the oldest person


WITH oldest AS
(
    SELECT p_gender, max(p_age) AS max_age
    FROM people
    GROUP BY p_gender
)
SELECT *
FROM oldest;

WITH oldest AS
(
    SELECT p_gender, max(p_age) AS max_age
    FROM people
    GROUP BY p_gender
)
SELECT people.*
FROM people
INNER JOIN oldest
ON people.p_gender = oldest.p_gender
AND people.p_age = oldest.max_age;

-- good, but for the males, we have a tie (Eric and John are the oldest)
-- let's establish a second rule: if there is a tie, untie with the one who
-- comes first in the alphabet

WITH oldest AS
(
    SELECT p_gender, max(p_age) AS max_age
    FROM people
    GROUP BY p_gender
),
first_in_alphabet AS
(
    SELECT DISTINCT p_gender, min(p_name) AS first_in_alphabet, p_age
    FROM people
    GROUP BY p_gender, p_age 
)
SELECT people.*
FROM people
INNER JOIN oldest
ON people.p_gender = oldest.p_gender
AND people.p_age = oldest.max_age
INNER JOIN first_in_alphabet
ON people.p_name = first_in_alphabet.first_in_alphabet
AND people.p_gender = first_in_alphabet.p_gender ;
