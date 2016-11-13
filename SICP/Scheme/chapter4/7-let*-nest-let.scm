(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

(define (let*? exp)
  (tagged-list? exp))

(define (let*->nested-lets vars inits body)
    (cond ((null? vars) body)
          (else 
                (let*->nested-lets (drop-last vars) (drop-last inits) 
                        (make-let (list (last-elm vars) (list (last-elm inits) body)))))
    )
)