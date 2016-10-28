(define (assoc key records)
    (cond ((null? records) #f)
          ((equal? key (caar records)) (car records))
          (else 
            (assoc key (cdr records))
          )
    )
)


(define (make-table)
    (let ((local-table (list '*table*)))

        (define (look-up key-1 key-2)
            (let ((sub-table (assoc key-1 (cdr local-table))))
                (if (sub-table)
                    (let ((record (assoc key-2 (cdr sub-table))))
                        (if (record)
                            (cdr record)
                            #f)
                    )
                    #f)
            )
        )

        (define (insert! key-1 key-2 value)
            (let ((sub-table (assoc key-1 (cdr local-table))))
                (if (sub-table)
                    (let ((record (assoc key-2 (cdr sub-table))))
                        (if (record)
                            (set-cdr! record value)
                            (set-cdr! sub-table (cons (cons key-2 value) (cdr sub-table))))
                    )
                    (set-cdr! local-table (cons (list key-1 (cons key-2 value)) (cdr local-table)))
                    )
            )
        'ok)

        (define (dispatch m)  
            (cond ((eq? m 'lookup-proc) look-up)
                  ((eq? m 'insert-proc!) insert!)
              (else
                (error "Unkonwn operation -- TABLE" m)
              ))
        )




    dispatch)
)