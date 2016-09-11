(define (fringe lst)
    (cond ((null? lst) '())
          ((not (pair? lst)) 
            (list lst))
          (else 
                (append (fringe (car lst)) (fringe (cdr lst))))
      )
)

(define (fringe-iter lst)
    (define (iter origin result)
        (cond ((null? origin) 
                    result)
              ((not (pair? origin))
                    (append result (list origin) ))
              (else 
                    (iter (cdr origin) (append result (fringe-iter (car origin)) )))

        )    
    )
    (iter lst '())
)