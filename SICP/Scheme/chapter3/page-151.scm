(define balance 100)

(define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
            balance)
        "Insuficient amount")
)

(withdraw 25)
(withdraw 25)
(withdraw 60)
(withdraw 25)

(define (new-withdraw)
    (let ((balance 100))
        (lambda (amount) 
            (if (>= balance amount)
                (begin (set! balance (- balance amount)) 
                amount)
                "Insufficient funds")
        )    
    )
)

(define (make-account balance)
    (define (withdraw amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount))
                balance)
            "Insuficient amount")
    )

    (define (deposit amount)
        (set! balance (+ balance amount))
        balance
    )

    (define (dispatch m)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              (else 
                    (error "Unknow request --MAKE-ACCOUNT"))
        )
    )
    dispatch
)