CREATE TABLE
    Bank
(
    bank_id BIGINT       NOT NULL,
    name    VARCHAR(255) NOT NULL,

    CONSTRAINT bank_pk
        PRIMARY KEY (bank_id),
    CONSTRAINT bank_identification_number_length_chk
        CHECK (length(cast(bank_id AS VARCHAR)) = 11)
);

CREATE TABLE
    Client
(
    client_id BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    username  VARCHAR(50)                             NOT NULL,
    email     VARCHAR(100)                            NOT NULL,
    password  CHAR(60)                                NOT NULL,

    CONSTRAINT client_pk
        PRIMARY KEY (client_id),
    CONSTRAINT email_uq
        UNIQUE (email)
);

CREATE TABLE Currency
(
    currency_id VARCHAR(3) NOT NULL,

    CONSTRAINT currency_pk
        PRIMARY KEY (currency_id)
);

CREATE TABLE
    Account
(
    account_id       VARCHAR(28)    NOT NULL,
    client_id        BIGINT         NOT NULL,
    bank_id          BIGINT         NOT NULL,
    money_amount     DECIMAL(22, 2) NOT NULL,
    currency_id      VARCHAR(3)     NOT NULL,
    date_when_opened DATE           NOT NULL,

    CONSTRAINT account_pk
        PRIMARY KEY (account_id),
    CONSTRAINT account_client_fk
        FOREIGN KEY (client_id) REFERENCES Client (client_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT account_bank_fk
        FOREIGN KEY (bank_id) REFERENCES Bank (bank_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT account_currency_fk
        FOREIGN KEY (currency_id) REFERENCES Currency (currency_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT account_money_amount_not_negative
        CHECK ( money_amount >= 0)
);

CREATE TABLE MonetaryTransactionType
(
    type VARCHAR(20) NOT NULL,

    CONSTRAINT monetary_transaction_type_pk
        PRIMARY KEY (type)
);

CREATE TABLE
    MonetaryTransaction
(
    monetary_transaction_id BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    time_when_committed     TIMESTAMP                               NOT NULL,
    sender_account_id       VARCHAR(28)                             NOT NULL,
    receiver_account_id     VARCHAR(28)                             NOT NULL,
    money_amount            DECIMAL(22, 2)                          NOT NULL,
    type                    VARCHAR(20)                             NOT NULL,

    CONSTRAINT monetary_transaction_pk
        PRIMARY KEY (monetary_transaction_id),
    CONSTRAINT monetary_transaction_sender_account_fk
        FOREIGN KEY (sender_account_id) REFERENCES Account (account_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT monetary_transaction_receiver_account_fk
        FOREIGN KEY (receiver_account_id) REFERENCES Account (account_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT monetary_transaction_type_fk
        FOREIGN KEY (type) REFERENCES MonetaryTransactionType (type)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT monetary_transaction_different_accounts_chk
        CHECK (sender_account_id != receiver_account_id),
    CONSTRAINT money_transaction_money_amount_not_negative
        CHECK ( money_amount >= 0)
);

