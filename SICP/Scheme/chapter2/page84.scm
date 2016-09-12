(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
          ((divides? test-divisor n) test-divisor)
          (else (find-divisor n (+ test-divisor 1)))
      )
)

(define (divides? a b)
    (= (remainder b a) 0))

(define (prime? n)
    (= n (smallest-divisor n)))


(define (enumerate-interval start end)
    (cond ((= start end) (list end))
          ((> start end) '())
          (else
                (append (list start) (enumerate-interval (+ start 1) end)))

    )
)

(define (accumulate op initial sequencce)
    (if (null? sequencce)
        initial
        (op (car sequencce) (accumulate op initial (cdr sequencce)))))


(define (hello n)
    (accumulate append '()
        (map 
            (lambda (i) 
                (map 
                    (lambda (j) (list i j))
                (enumerate-interval 1 (- i 1)))
            )
        (enumerate-interval 1 n))
    )
)

(define (flatmap proc seq)
    (accumulate append '() (map proc seq)))


(define (prime-sum? pair)
    (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
    (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
    (map make-pair-sum 
        (filter prime-sum? 
            (flatmap 
                (lambda (i) (map (lambda (j) (list i j))
                    (enumerate-interval 1 (- i 1))) 
                )
            (enumerate-interval 1 n))
        )
    )
)

(define (remove item sequencce)
  (filter (lambda (x) (not (= x item))) sequencce))


(define (permutations s)
    (if (null? s)
        (list '())
        (flatmap
            (lambda (x) 
                (map (lambda (sub-seq) (cons x sub-seq)) (permutations (remove x s)))
            )
        s)
    )
)