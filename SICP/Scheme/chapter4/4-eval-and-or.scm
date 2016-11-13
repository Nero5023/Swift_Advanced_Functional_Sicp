(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))


(define (and? exp)
  (tagged-list? exp 'and))

(define (or? exp)
  (tagged-list? exp 'or))

(define (logic-predicates exp)
  (cdr exp))

(define (first-predicate predicates)
  (car predicates))

(define (rest-predicates predicates)
  (cdr predicates))

(define (last-predicate? predicates)
  (null? (cdr predicates)))

(define (eval-and predicates env)
    (cond ((null? predicates) #t)
          ((last-predicate? predicates) (true? (first-predicate predicates) env))
          ((true? (first-predicate predicates) env)
                (eval-and (rest-predicates predicates) env))
          (else
            #f)
    )
)

(define (eval-or predicates env)
    (cond ((null? predicates) #f)
          ((last-predicate? predicates) 
                (true? (first-predicate predicates) env))
          ((true? (first-predicate predicates) env)
                #t)
          (else 
            (eval-or (rest-predicates predicates) env))
    )
)