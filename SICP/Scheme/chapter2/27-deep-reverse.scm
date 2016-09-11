(define (reverse lst)
    (define (iter origin result)
        (if (null? origin)
            result
            (iter (cdr origin) (cons (car origin) result))))
    (iter lst '())
)

(define (deep-reverse lst)
    (cond ((null? lst) 
                '())
          ((not (pair? lst))
                lst)
          (else 
                (reverse (list (deep-reverse (car lst)) (deep-reverse (cadr lst)))))
      ))

(define (real-deep-reverse lst)
    (define (iter origin result)
            (if (null? origin)
                result
                (iter (cdr origin)
                    (cons (if (pair? (car origin))
                        (real-deep-reverse (car origin))
                        (car origin))
                    result)
                )
            )
    )

    (iter lst '())
)