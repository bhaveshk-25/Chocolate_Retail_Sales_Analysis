-------- Calendar Table -------------

CREATE TABLE date_dim (
    date         DATE        PRIMARY KEY,
    year         INTEGER     NOT NULL,
    month        INTEGER     NOT NULL CHECK (month BETWEEN 1 AND 12),
    day          INTEGER     NOT NULL CHECK (day BETWEEN 1 AND 31),
    week         INTEGER     NOT NULL CHECK (week BETWEEN 1 AND 53),
    day_of_week  INTEGER     NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
	week_name    TEXT        GENERATED ALWAYS AS (TO_CHAR(date, 'Day')) STORED
);

-------- Customer details table ----------

CREATE TABLE customer_dim (
    customer_id   VARCHAR(20) PRIMARY KEY,
    age           INTEGER     NOT NULL CHECK (age >= 0 AND age <= 120),
    gender        VARCHAR(10) NOT NULL CHECK (gender IN ('Male','Female','Other')),
    loyalty_m     BOOLEAN     NOT NULL,   -- 1 = loyal, 0 = not loyal
    join_date     DATE        NOT NULL CHECK (join_date <= CURRENT_DATE)
);

-------- Product details table -----------

CREATE TABLE product_dim (
    product_id   VARCHAR(20)  PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    brand        VARCHAR(50)  NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    cocoa_per    NUMERIC(5,2) NOT NULL CHECK (cocoa_per >= 0 AND cocoa_per <= 100),
    weight_g     INTEGER      NOT NULL CHECK (weight_g > 0)
);

--------- Store details table ----------

CREATE TABLE store_dim (
    store_id    VARCHAR(20)  PRIMARY KEY,
    store_name  VARCHAR(100) NOT NULL,
    city        VARCHAR(30)  NOT NULL,
    country     VARCHAR(30)  NOT NULL,
    store_type  VARCHAR(50)  NOT NULL CHECK (store_type IN ('Retail','Mall','Online','Airport'))
);

----------- Sales table ----------------

CREATE TABLE IF NOT EXISTS sales(
	order_id       VARCHAR(20),
	order_date     DATE           NOT NULL CHECK (order_date <= CURRENT_DATE),
	product_id     VARCHAR(20),
	store_id       VARCHAR(10)    NOT NULL,
	customer_id    VARCHAR(20)    NOT NULL,
	quantity       INTEGER        NOT NULL CHECK (quantity > 0),
	unit_price     NUMERIC(10,2)  NOT NULL CHECK (unit_price >= 0),
	discount       NUMERIC(3,2)   NOT NULL CHECK (discount >= 0 AND discount <= 1),
	revenue        NUMERIC(12,2)  NOT NULL CHECK (revenue >= 0),
	cost           NUMERIC(12,2)  NOT NULL CHECK (cost >= 0),
	profit         NUMERIC(12,2)  NOT NULL,
	PRIMARY KEY (order_id, product_id),
	FOREIGN KEY (order_date) REFERENCES date_dim(date),
	FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (store_id) REFERENCES store_dim(store_id),
    FOREIGN KEY (customer_id) REFERENCES customer_dim(customer_id)
);