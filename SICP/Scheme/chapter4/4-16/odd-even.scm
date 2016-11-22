(define (f x)
    (define (odd? n)
      (if (= n 0)
          false
          (even? (- n 1))))
    (define (even? n)
      (if (= n 0)
          true
          (odd? (- n 1))))
    
    (odd? x)
)