(define (make-mointored func)
    (let ((num-call 0))
        (lambda (input) 
            (cond ((eq? input 'how-many-calls?) num-call)
                  (else 
                      (set! num-call (+ num-call 1))
                      (func input)
                  ))
        )    
    )
)