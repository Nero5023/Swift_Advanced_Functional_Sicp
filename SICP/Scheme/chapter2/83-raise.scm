(define (raise x)
    (apply-generic 'raise x)
)

(put 'raise 'integer 
(lambda (x) (make-rational x 1)))

(put 'raise 'rational 
    (lambda (x) (make-real (/ (numer x) (denom 1)))))

