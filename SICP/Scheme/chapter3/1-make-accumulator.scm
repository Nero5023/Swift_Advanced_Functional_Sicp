(define (make-accumulator initial)
    (lambda (add-number) 
        (set! initial (+ initial add-number))
        initial
    )
)