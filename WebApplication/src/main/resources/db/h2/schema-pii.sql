DROP TABLE customers IF exists;

CREATE TABLE customers (
  id         INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  first_name VARCHAR(255),
  last_name  VARCHAR_IGNORECASE(255),
  address    VARCHAR(255),
  city       VARCHAR(80),
  telephone  VARCHAR(20)
);
CREATE INDEX customer_last_name ON customers (last_name);
