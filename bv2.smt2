;Author: Janek Speit
;BV2: 
;Eine Transaktion erhält die Summe der Kontostände der beiden beteiligten Konten.

;Negierte BV1
(assert
    (forall((t1 Transaction))
        (not
            (= 
                (+
                    (balance(transaction_sender t1))
                    (balance(transaction_receiver t1))
                )  
                (+
                    (balance(block_account(transaction_receiver t1)(successor(transaction_block t1))))
                    (balance(block_account(transaction_sender t1)(successor(transaction_block t1))))
                )
            )
        )
    )
)

;erwarte UNSAT
(check-sat)