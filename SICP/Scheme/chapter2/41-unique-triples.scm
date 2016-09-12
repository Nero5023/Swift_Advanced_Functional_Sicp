(define (enumerate-interval start end)
    (cond ((= start end) (list end))
          ((> start end) '())
          (else
                (append (list start) (enumerate-interval (+ start 1) end)))

    )
)

(define (flatmap proc seq)
    (accumulate append '() (map proc seq)))

(define (unique-triples n)
    (flatmap 
        (lambda (i) 
            (flatmap 
                (lambda (j) 
                    (map  
                        (lambda (k) (list i j k))
                    (enumerate-interval 1 (- j 1)))
                )
            (enumerate-interval 1 (- i 1)))
        )
    (enumerate-interval 1 n))
)


(define (unique-pairs n)
    (flatmap 
        (lambda (i) 
            (map 
                (lambda (j) (list i j))
            (enumerate-interval 1 (- i 1)))
        )
    (enumerate-interval 1 n))
)

(define (unique-triples2 n)
    (flatmap 
        (lambda (i) 
            (map 
                (lambda (j) (cons i j))
            (unique-pairs (- i 1)))
        )
    (enumerate-interval 1 n))
)

(define (triple-sum-equal-to? sum triples)
    (= sum
        (+ (car triples)
            (cadr triples)
            (caddr triples))
    )
)

(define (triples-sum-equal sum bound)
    (filter 
        (lambda (triple) (triple-sum-equal-to? sum triple))
    (unique-triples bound))
)


