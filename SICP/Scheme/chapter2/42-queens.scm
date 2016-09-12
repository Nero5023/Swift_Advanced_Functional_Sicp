(define (flatmap proc seq)
    (accumulate append '() (map proc seq)))

(define (enumerate-interval start end)
    (cond ((= start end) (list end))
          ((> start end) '())
          (else
                (append (list start) (enumerate-interval (+ start 1) end)))
    )
)


(define (adjoin-position new-row k rest-of-queens)
    (cons new-row rest-of-queens)
)

(define (safe? k positions)
    (define (iter-check row-of-new-queen rest-of-queens i)
        (if (null? rest-of-queens)
            #t
            (let ((row-of-queen (car rest-of-queens)))
                 (if (or (= row-of-queen row-of-new-queen)
                          (= (+ i row-of-queen) row-of-new-queen)
                          (= (- row-of-queen i) row-of-new-queen))
                    #f
                    (iter-check row-of-new-queen (cdr rest-of-queens) (+ i 1)))
            )
        )
    )
    (iter-check (car positions) (cdr positions) 1)
)

(define empty-board '() )

(define (queens board-size)
    (define (queen-cols k)
        (if (= k 0)
            (list empty-board)
            (filter
                (lambda (positions) (safe? k positions))
                (flatmap 
                    (lambda (rest-of-queens) 
                        (map (lambda (new-row) (adjoin-position new-row k rest-of-queens))
                        (enumerate-interval 1 board-size)))
                (queen-cols (- k 1)))
            )))
    (queen-cols board-size)
)

