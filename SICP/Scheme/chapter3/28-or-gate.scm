(define (inverter input output)
    (define (inverter-input)
        (let ((new-value (logical-not (get-signal input))))
            (after-daly inverter-delay
                (lambda () 
                    (set-signal! output new-value))))
    )

    (add-action! input inverter-input)
    'ok
)

(define (logical-not s)
    (cond ((= s 0) 
            1)
          ((= s 1) 0)
          (else 
            (error "Incalid signal" s)))
)

(define (and-gate a1 a2 output)
    (define (and-action-procedure)
        (let ((new-value (logical-and (get-signal a1) (get-signal a2))))
            (after-daly and-gate-delay
                (lambda () (set-signal! output new-value))))
    )

    (add-action! a1 and-action-procedure)
    (add-action! a2 and-action-procedure)
    'ok
)6

(define (logical-or a1 a2)
    (if (or (= a1 1) (= a2 1))
        1
        0))

(define (or-gate a1 a2 output)
    (define (or-action-procedure)
        (let ((new-value (logical-or (get-signal a1) (get-signal a2))))
            (after-daly or-gate-delay
                (lambda () (set-signal! output new-value))))
    )

    (add-action! a1 or-action-procedure)
    (add-action! a2 or-action-procedure)
)