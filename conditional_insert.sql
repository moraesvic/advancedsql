INSERT INTO products
(
    prod_name,
    prod_price,
    prod_instock
)
SELECT * FROM
(
    VALUES
    ('abacaxi', 12.99, 4),
    ('mamão', 4.55, 7)
) new_values
(
    prod_name,
    prod_price,
    prod_instock
)
WHERE NOT EXISTS
(
    SELECT
    FROM products
    WHERE prod_name = new_values.prod_name
);