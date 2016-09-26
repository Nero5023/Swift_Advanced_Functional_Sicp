(define temp 0)
(define (f num)
    (cond ((= temp 1) 0)
          ((= 1 num) 
            (set! temp 1)
            1)
          ((= 0 num)
            (set! temp 1)
          0)
    )
)

(define f
    (lambda (first-value)
        (set! f (lambda (second-value) 0))
        first-value))

(define f2
    (lambda (first-value) 
        (set! f (lambda (second-value) 0))
        first-value
    )
)