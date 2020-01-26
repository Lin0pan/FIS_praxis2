;Author: Janek Speit
;BV1: 
;Hat ein Konto acc1 in einem Block b1 den Kontostand 42 und überweist in diesem Block den Betrag
;19 an ein anderes Konto, so hat acc1 im nächsten Block den Kontostand 23.

(declare-const acc1 Account)
(declare-const b1 Block)
(declare-const b2 Block)
(declare-const t1 Transaction)

(assert(=(successor b1) b2))

(assert(=(balance acc1) 42))
(assert(=(transaction_sender t1) acc1))
(assert(=(transaction_amount t1) 19))
(assert(=(transaction_block t1) b1))

;negierte BV1
(assert
    (not
        (=(balance (block_account acc1 b2)) 23)
    )
)

;erwarte UNSAT
(check-sat)
