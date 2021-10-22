
CREATE TABLE IF NOT EXISTS products (
	prod_id BIGSERIAL PRIMARY KEY,
	prod_name TEXT NOT NULL,
	prod_price DOUBLE PRECISION NOT NULL,
	prod_instock INT
);

CREATE TYPE sql_action AS ENUM (
	-- SELECT does not change the data in any way
	'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE'
);

CREATE TABLE IF NOT EXISTS auditing (
	action_id BIGSERIAL PRIMARY KEY,
	action_type sql_action NOT NULL,
	action_time TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION trgfn_ins_products()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO auditing (action_type, action_time)
	VALUES
	('INSERT'::sql_action, NOW());
	RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER trg_ins_products
AFTER INSERT
ON products
FOR EACH ROW
EXECUTE FUNCTION trgfn_ins_products();

INSERT INTO products (prod_name, prod_price, prod_instock) VALUES
	('abacaxi', 10.99, 7),
	('cenoura', 2.87, 4),
	('limão', 1.44, 281),
	('cheetos', 7.43, 11) ;

CREATE OR REPLACE FUNCTION fn_get_prices
()
RETURNS TABLE 
(
	price DOUBLE PRECISION
)
AS
$$
SELECT prod_price FROM products ;
$$
LANGUAGE SQL ;

CREATE OR REPLACE FUNCTION fn_get_instock
()
RETURNS TABLE
(
	name TEXT,
	instock INT
)
AS
$$
BEGIN
	RETURN QUERY (
		SELECT prod_name, prod_instock
		FROM products 
	);
END;
$$ LANGUAGE PLPGSQL ;
