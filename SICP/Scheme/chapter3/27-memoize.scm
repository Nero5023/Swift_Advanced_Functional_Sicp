(define (memoize f)
    (let ((table (make-table)))
        (lambda (x) 
            (let ((previously-computed-result (lookup x table)))
                (or previously-computed-result
                    (let ((result (f x)))
                        (insert! x result table)
                    result)
                )
            )))
)

(define memo-fib
    (memoize (lambda (n) 
        (cond ((= 0 n) 0)
              ((= 1 n) 1)
              (else 
                (+ (memo-fib (- n 1) (memo-fib (- n 2))))
              )
        )
    ))
)