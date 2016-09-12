(define (enumerate-interval start end)
    (cond ((= start end) (list end))
          ((> start end) '())
          (else
                (append (list start) (enumerate-interval (+ start 1) end)))

    )
)

(define (flatmap proc seq)
    (accumulate append '() (map proc seq)))

(define (unique-pairs n)
    (flatmap 
        (lambda (i) 
            (map 
                (lambda (j) (list i j))
            (enumerate-interval 1 (- i 1)))
        )
    (enumerate-interval 1 n))
)