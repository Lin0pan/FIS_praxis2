(declare-sort Account 0)
(declare-sort Block 0)
(declare-sort Transaction 0)

(declare-const initial Block)
(declare-fun predecessor (Block) Block)
(declare-fun successor (Block) Block)

(declare-fun balance (Account) Int)

(declare-fun transaction_sender (Transaction) Account)
(declare-fun transaction_receiver (Transaction) Account)
(declare-fun transaction_amount (Transaction) Int)
(declare-fun transaction_block (Transaction) Block)

(declare-fun perform_transaction (Account Account Int) Transaction)

(declare-fun block_account (Account Block) Account) ;get Account state of specific Block

;Kontostand nicht negativ
(
    assert
    (
        forall((a1 Account))
        (
            not (< (balance a1) 0 )
        )
    )
)


;Betrag bei Transaktion nicht negativ
(
    assert
    (
        forall((t1 Transaction))
        (
            not (< (transaction_amount t1) 0 )
        )
    )
)


;Nicht mehr Senden als Geld auf Konto
(
    assert
    (
        forall((t1 Transaction))
        (
             < (transaction_amount t1) (balance (transaction_sender t1))
        )
    )
)


;Account im nachfolgenden Block angepasst 
(                                               
    assert
    (
        forall((transaction Transaction))
        (
            exists((block Block))
            (
                and 
                (= 
                    (transaction_block transaction) block
                )
                (= 
                    (+ 
                        (transaction_amount transaction) 
                        (balance (transaction_receiver transaction))
                    ) 
                    (
                        balance (block_account (transaction_receiver transaction) (successor block))
                    )
                )

                (= 
                    (- 
                        (balance (transaction_sender transaction))
                        (transaction_amount transaction) 
                    ) 
                    (
                        balance (block_account (transaction_sender transaction) (successor block))
                    )
                )

            )
        )
    )
)




;nicht zwei Accounts im selben Block
(
    assert
    (
        forall((t1 Transaction) (t2 Transaction))
        (
            or
            (
            not
            (=(transaction_block t1)(transaction_block t2))
            )
            (
                not
                (
                    or
                        ;(=(transaction_sender t1)(transaction_sender t2))
                        ;(=(transaction_receiver t1)(transaction_receiver t2))
                        (=(transaction_sender t1)(transaction_receiver t2))
                        (=(transaction_receiver t1)(transaction_sender t2)) 
                )
            )
        )
    )
)

;initial Block der einzige der sein Vorgaenger sein kann 
(
    assert
        (=(predecessor initial) initial)
)

(check-sat)
;
;konstante initialblock
;funktionen: executeTransaction
;praedikat vorgaenger
;


