(define (make-account balance password)
    (let ((try-times 0) (max-tiems 7))
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

        (define (dispatch password-input m)
            (if (eq? password-input password)
                    (begin (set! try-times 0)
                        (cond ((eq? m 'withdraw) withdraw)
                              ((eq? m 'deposit) deposit)
                              (else 
                                    (error "Unknow request --MAKE-ACCOUNT"))
                    ))
                (lambda (x)
                    (set! try-times (+ 1 try-times)) 
                    (if (> try-times  max-tiems)
                        (display "call the cops")
                        (display "Incroect password"))
                    

                )
            )
        )

        dispatch
    )

)