;Author: Janek Speit

(declare-sort Account 0)
(declare-sort Block 0)
(declare-sort Transaction 0)

;es gibt einen initialen Block.
(declare-const initial Block)

;jeder Block hat einen Vorgänger. 
(declare-fun predecessor (Block) Block)

;Nachfolger Block
(declare-fun successor (Block) Block)

;ein Konto hat einen Kontostand, ... *
(declare-fun balance (Account) Int)

;Transaktionen haben einen Sender, einen Empfänger und einen Betrag. Sie gehören zu einem Block.
(declare-fun transaction_sender (Transaction) Account)
(declare-fun transaction_receiver (Transaction) Account)
(declare-fun transaction_amount (Transaction) Int)
(declare-fun transaction_block (Transaction) Block)

;* ...der sich von Block zu Block verändern kann.
;(Gibt Account in Zustand abhängig vom Block)
(declare-fun block_account (Account Block) Account) 

;kein Block hat mehr als einen Nachfolger.
(assert 
    (not 
        (exists((b1 Block) (b2 Block))
            (and
                (= b1 b2)
                (not(= (successor b1)(successor b2)))
            )
        )
    )
)

;der initiale Block ist der einzige, der sein eigener Vorgänger ist
(assert
        (=(predecessor initial) initial)
)

(assert 
    (forall((b1 Block))
        (or
            (= b1 initial)
            (not(= (predecessor b1) b1))
        )        
    )
)

;jeder Block hat einen Vorgänger
(assert
    (forall((b1 Block))
        (exists((b2 Block))
            (= b2 (predecessor b1))
        )
    )
)

;Kontostand kann nicht negativ sein
(assert
    (forall((a1 Account))
        (not
            (< (balance a1) 0 )
        )
    )
)


;Der zu überweisende Betrag ist positiv ... * 
(assert
    (forall((t1 Transaction))
        (not 
            (< (transaction_amount t1) 0 )
        )
    )
)


;* ...und nicht größer als der Kontostand des Senders.
(assert
    (forall((t1 Transaction))
        (< 
            (transaction_amount t1) 
            (balance (transaction_sender t1))
        )
    )
)


;Wird in einer Transaktion in einem Block Geld von einem Konto an ein anderes überwiesen,
;dann werden die beiden Kontostände im nachfolgenden Block dementsprechend angepasst.
(assert
    (forall((transaction Transaction))
        (exists((block Block))
            (and 
                (= (transaction_block transaction) block)
                (= 
                    (+ 
                        (transaction_amount transaction) 
                        (balance (transaction_receiver transaction))
                    ) 
                    (balance (block_account (transaction_receiver transaction) (successor block)))
                )

                (= 
                    (- 
                        (balance (transaction_sender transaction))
                        (transaction_amount transaction) 
                    ) 
                    (balance (block_account (transaction_sender transaction) (successor block)))
                )
            )
        )
    )
)




;Jedes Konto kommt pro Block nur einmal vor, d.h. es ist z.B. nicht möglich, dass in einem Block
;mehrere Transaktionen von einem Konto ausgehen oder dass ein Konto innerhalb eines Blocks
;gleichzeitig Geld empfängt und versendet.
(assert 
    (not 
        (exists((t1 Transaction) (t2 Transaction))
            (and
                (= (transaction_block t1) (transaction_block t2))
                (not (= t1 t2))
                (or
                    (= (transaction_sender t1) (transaction_receiver t2))
                    (= (transaction_receiver t1) (transaction_sender t2))
                    (= (transaction_sender t1) (transaction_sender t2))
                    (= (transaction_receiver t1) (transaction_receiver t2))
                    (= (transaction_sender t1) (transaction_receiver t1))
                    (= (transaction_sender t2) (transaction_receiver t2))
                )
            )
        )
    )
)

(check-sat)