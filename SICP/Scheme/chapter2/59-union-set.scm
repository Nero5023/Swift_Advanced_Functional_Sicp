(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((equal? x (car set)) #t)
          (else 
            (element-of-set? x (cdr set)))
    )
)

(define (adjoin-set x set)
    (if (element-of-set? x set)
        set
        (cons x set))
)

(define (intersection-set set1 set2)
    (cond ((or (null? set1) (null? set2)) '())
          ((element-of-set? (car set1) set2) 
                (cons (car set1) (intersection-set (cdr set1) set2)))
          (else 
            (intersection-set (cdr set1) set2))
    )    
)

(define (union-set set1 set2)
    (cond ((or (null? set1) (null? set2)) 
                (append set1 set2))
          (else 
                (adjoin-set (car set1) (unon-set (cdr set1) set2)))
    )
)


(define (union-set2 set1 set2)
    (define (iter input result)
        (if (null? input)
            result
            (let ((current-item (car input))
                 (remained-items (cdr input))
                  )
                (if (element-of-set? current-item result)
                    (iter remained-items result)
                    (iter remained-items (cons current-item result)))
            )    
        )
    )
    (iter (append set1 set2) '())
)