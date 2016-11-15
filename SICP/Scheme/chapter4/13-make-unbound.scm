(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

(define (make-unbound? exp)
  (tagged-list exp 'make-unbound!))

(define (eval-make-bound exp env)
    (set-variable-value! (cadr exp) '() env)
)

(define (make-unbound-exp var)
  (cons 'make-unbound! var))

