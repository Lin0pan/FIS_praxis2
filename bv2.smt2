(
    assert
    (
        forall((t1 Transaction))
        (
            =
            
                
                (
                +
                    (balance(transaction_sender t1))
                    (balance(transaction_receiver t1))
                )
                
                (
                +
                    (balance(block_account((transaction_sender t1) (successor(transaction_block t1)))))
                    (balance(block_account((transaction_receiver t1) (successor(transaction_block t1)))))
                )
            
        )

    )
)