(define (assoc key records)
    (cond ((null? records) #f)
          ((equal? key (caar records)) (car records))
          (else 
            (assoc key (cdr records))
          )
    )
)

(define (lookup key table)
    (let ((record (assoc key (cdr table))))
        (if (record)
            (car record)
            #f)
    )
)


(define (insert! key value table)
    (let ((record (assoc key (car table))))
        (if (record)
            (set-cdr! record value)
            (set-cdr! (cons (cons key value) (cdr table)))
            )    
    )
'ok)

(define (make-table)
  (list '*list*))
