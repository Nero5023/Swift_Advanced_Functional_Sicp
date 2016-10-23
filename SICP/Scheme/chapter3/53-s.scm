(define (stream-map proc . list-of-stream)
    (if (null? (car list-of-stream))
        '()
        (cons-stream (apply proc (map (lambda (s) (stream-car s)) list-of-stream))
            (apply stream-map (cons proc (map (lambda (s) (stream-cdr s)) list-of-stream)))
        )    
    )
)

(define (add-streams s1 s2)
  (stream-map + s1 s2))

