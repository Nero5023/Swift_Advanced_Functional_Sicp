(define (accumulate op initial sequencce)
    (if (null? sequencce)
        initial
        (op (car sequencce) (accumulate op initial (cdr sequencce)))))

(define (horner-eval x cofficient-sequence)
    (accumulate (lambda (this-coeff higher-terms) (+ (* x higher-terms) this-coeff))
        0 
        cofficient-sequence)    
)