(define (make-account balance password)
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
                (cond ((eq? m 'withdraw) withdraw)
                      ((eq? m 'deposit) deposit)
                      (else 
                            (error "Unknow request --MAKE-ACCOUNT"))
                )
            (lambda (x) (display "Incroect password"))
        )
    )
    dispatch
)

(define (make-joint origin-account origin-password new-password)
    (lambda (given-password m)
        (if (eq? given-password new-password)
             (origin-account origin-password m)
             (display "Incroect new-password")) 
    )
)