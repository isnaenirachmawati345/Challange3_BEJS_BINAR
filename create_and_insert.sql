CREATE TABLE account (
	account_id INTEGER PRIMARY KEY,
	customer_id VARCHAR NOT NULL,
	account_number VARCHAR NOT NULL,
	account_type VARCHAR,
	account_open_date DATE NOT NULL
);
CREATE TABLE transactions (
	transaction_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL,
	transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	deposit_amount MONEY,
	withdraw_amount MONEY
);
CREATE TABLE nasabah (
	customer_id SERIAL PRIMARY KEY,
	customer_name VARCHAR,
	birth_date DATE,
	address VARCHAR NOT NULL,
	account_number VARCHAR NULL
);
INSERT INTO nasabah (customer_id, customer_name, birth_date, address, account_number)
VALUES
	('1', 'Isnaeni', '2001/07/08' , 'Indonesian', '999999'),
	('2', 'Raisa', '1999/07/07', 'Indonesian', '888888'),
	('3', 'Faisal', '1998/11/09', 'American', '777777'),
	('4', 'Adele', '1998/11/09', 'British', '999999'),
	('5', 'Suzy', '1999/09/09', 'Korean', '222222');	
SELECT * FROM nasabah ORDER BY customer_id ASC;
INSERT INTO account (account_id, customer_id, account_number,account_type, ACCOUNT_OPEN_DATE)
VALUES
	(1, 1, '999999', 'Gold', '2023/07/07'),
	(2, 2, '888888', 'Silver', '2023/05/09'),
	(3, 3, '777777', 'Silver', '2023/07/08'),
	(4, 3, '999999', 'Gold', '2022/05/06'),
	(5, 4, '222222', 'Silver', '2022/04/04');
SELECT * FROM account ORDER BY account_id ASC;
INSERT INTO transactions (transaction_id, account_id, deposit_amount, withdraw_amount)
VALUES
	(1, 1, '10000', NULL),
	(2, 2, '3000000', NULL),
	(3, 3, NULL, '400000'),
	(4, 4, NULL, '100000000'),
	(5, 5, '100000', NULL);
SELECT * FROM transactions ORDER BY transaction_id ASC;
ALTER TABLE account
RENAME ACCOUNT_OPEN_DATE TO account_open_date;
--UNTUK MELAKUKAN INDEKS
CREATE INDEX idx_customer_id ON account (customer_id);
--UPDATE DATA ACCOUNT
UPDATE account
SET account_type = 'Gold'
--DELETE DATA DARI AKUN KONSUMEN
WHERE customer_id = '2';
--delete hard
DELETE FROM account
WHERE account_id = 5;
--cte
WITH AccountNasabahTransaction AS (
  SELECT
    a.account_id,
    a.customer_id,
    a.account_number,
    a.account_type,
    a.account_open_date,
    c.customer_name,
    c.birth_date,
    c.address,
    c.account_number AS customer_account_number,
    t.transaction_id,
    t.transaction_time,
    t.deposit_amount,
    t.withdraw_amount
  FROM account a
  JOIN nasabah c ON a.customer_id = c.customer_id
  LEFT JOIN transactions t ON a.account_id = t.account_id
)
SELECT Nasabah;
--untuk mengubah tipe data customer_id

--ALTER TABLE account
--ALTER COLUMN customer_id TYPE INTEGER USING customer_id::INTEGER;

--untuk relasi tabel account ke customer
ALTER TABLE account
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES nasabah (customer_id);
--relasi transaksi ke akun
ALTER TABLE transactions
ADD CONSTRAINT fk_account
FOREIGN KEY (account_id)
REFERENCES account (account_id);
-------------------------------
--prosedure 
CREATE OR REPLACE FUNCTION get_transactions_by_account_id(account_id_param INTEGER) RETURNS TABLE (
    transaction_id INTEGER,
    transaction_time TIMESTAMP,
    deposit_amount MONEY,
    withdraw_amount MONEY
) AS $$
BEGIN
    RETURN QUERY
    SELECT transaction_id, transaction_time, deposit_amount, withdraw_amount
    FROM transactions
    WHERE account_id = account_id_param;
END;
$$ LANGUAGE plpgsql;