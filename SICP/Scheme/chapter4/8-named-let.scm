 (define (named-let? expr) (and (let? expr) (symbol? (cadr expr)))) 
  
 (define (named-let-func-name expr) (cadr expr)) 
  
 (define (named-let-func-body expr) (cadddr expr)) 
  
 (define (named-let-func-parameters expr) (map car (caddr expr))) 
  
 (define (named-let-func-inits expr) (map cadr (caddr expr))) 


(define (named-let->func exp)
  (list 'define (cons named-let-func-name named-let-func-parameters) (named-let-func-body exp)))

(define (let->combination exp)
  (if (named-let? exp)
      (sequence->exp 
        (list (named-let->func exp) (cons (named-let-func-name exp) (named-let-func-inits exp))))
      (cons (make-lambda (let-vars exp) (list (let-body exp)))) 
            (let-inits exp))
)
