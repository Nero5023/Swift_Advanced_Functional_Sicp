(define (count-pairs x)
    (if (not (pair? x))
        0
        (+ (count-pairs (car x)) (count-pairs (cdr x)) 1)
    )
)
(count-pairs (list (list 1)))
(count-pairs (list (list (list 1))))