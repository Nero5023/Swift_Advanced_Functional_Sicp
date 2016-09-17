

(define (apply-generic op . args) 
   ; coercing list to a type 
   (define (coerce-list-to-type lst type) 
      (map (lambda (x) 
            (let ((proc (get-coercion (type-tag x) type))) 
              (if proc (proc x) x))) 
          lst) 
    ) 
  
   ; applying to a list of multiple arguments 
   (define (apply-coerced lst) 
     (if (null? lst) 
       (error "No method for given arguments") 
       (let ((coerced-list (coerce-list-to-type args (type-tag (car lst))))) 
         (let ((proc (get op (map type-tag coerced-list)))) 
           (if proc 
             (apply proc (map contents coerced-list)) 
             (apply-coerced (cdr lst))))))) 
  
   ; logic to prevent always coercing if there is already direct input entry 
   (let ((type-tags (map type-tag args))) 
     (let ((proc (get op type-tags))) 
       (if proc 
         (apply proc (map contents args)) 
         (apply-coerced args))))) 

