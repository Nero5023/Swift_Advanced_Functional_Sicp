(define (call-each procedures)
    (if (null? procedures)
        'done
        (begin
            ((car procedures))
            (call-each (cdr procedures))
        ))
)

(define (make-wire)
    (let ((signal-value 0)
            (action-procedures '()))
        (define (set-my-signal! new-value)
            (if (not (= signal-value new-value))
                (begin (set! signal-value new-value)
                       (call-each action-procedures))
                'done)
        )

        (define (accept-action-procedures! proc)
            (set! action-procedures (cons proc action-procedures))
        (proc))

        (define (dispatch m)
            (cond ((eq? m 'get-signal) signal-value)
                  ((eq? m 'set-signal!) set-my-signal!)
                  ((eq? m 'add-action!) accept-action-procedures!)
                  (else 
                        (error "Unknown operation -- WIRE" m)
                  )
            )
        )
    )
)

(define (get-signal wire)
    (wire 'get-signal)
)

(define (set-signal! wire new-value)
    ((wire 'set-signal!) new-value)
)

(define (add-action! wire action-procedure)
    ((wire 'add-action!) action-procedure)
)

(define (propagate)
    (if (empty-agenda? the-agenda)
        'done
        (let ((first-item (first-agenda-item the-agenda)))
                (first-item)
                (remove-first-agenda-item! the-agenda)
                (propagate)
        )    
    )
)



(define (probe name wire)
    (add-action! wire
        (lambda () 
            (newline)
            (display name)
            (display " ")
            (display (current-time the-agenda))
            (display " New-Value = ")
            (display (get-signal wire))
        ))
)
