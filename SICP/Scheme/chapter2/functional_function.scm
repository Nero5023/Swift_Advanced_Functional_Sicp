(define (map proc items)
    (if (null? items)
        '()
        (cons (proc (car items))
            (map proc (cdr items))
        )))

(define (for-each proc items)
    (if (not (null? items))
        ;保证 begin 后面的两个方法以先后顺序运行
        ;而不是像 if 语句中两个方法就是if 和 else 两种情况
        ;用 cond 就不会出现这个问题
        (begin (proc (car items)) (for-each proc (cdr items)))
    )
)


(define (filter predicate sequencce)
    (cond ((null? sequencce) '())
          ((predicate (car sequencce)) 
            (cons (car sequencce) (filter predicate (cdr sequencce))))
          (else 
            (filter predicate (cdr sequencce)))
      )
)

(define (accumulate op initial sequencce)
    (if (null? sequencce)
        initial
        (op (car sequencce) (accumulate op initial (cdr sequencce)))))

(define (map2 proc items)
    (accumulate (lambda (x y) (cons (proc x) y)) '() items))

(define (append2 seq1 seq2)
    (accumulate cons seq2 seq1))

(define (length2 sequencce)
    (accumulate (lambda (x y) (+ y 1)) 0 sequencce))


(define (enumerate-interval start end)
    (cond ((= start end) (list end))
          ((> start end) (error "start larger than end"))
          (else
                (append (list start) (enumerate-interval (+ start 1) end)))

    )
)

(define (flatmap proc seq)
    (accumulate append '() (map proc seq)))

(define (enumerate-interval start end)
    (cond ((= start end) (list end))
          ((> start end) '())
          (else
                (append (list start) (enumerate-interval (+ start 1) end)))

    )
)