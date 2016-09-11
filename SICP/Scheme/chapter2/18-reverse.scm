(define (reverse lst)
    (define (iter origin result)
        (if (null? origin)
            result
            (iter (cdr origin) (cons (car origin) result))))
    (iter lst '())
)