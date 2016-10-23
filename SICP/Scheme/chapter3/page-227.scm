(define (integers-start-from n)
  (cons-stream n (integers-start-from (+ n 1))))

(define (divisible? x y)
  (= (remainder x y) 0))

(define (sieve stream)
  (cons-stream 
    (stream-car stream)
    (sieve (stream-filter 
            (lambda (x) 
                (not (divisible? x (stream-car stream))))
            (stream-cdr stream)))))

(define primes (sieve (integers-start-from 2)))