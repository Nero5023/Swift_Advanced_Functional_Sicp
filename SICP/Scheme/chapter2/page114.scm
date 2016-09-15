(define (make-leaf symbol weight)
    (list 'leaf symbol weight)
)

(define (leaf? object)
    (eq? (car object) 'leaf)
)

(define (symbol-leaf x)
    (cadr x)
)

(define (weight-leaf x)
    (caddr x)
)

(define (make-code-tree left right)
    (list left
          right
          (append (symbols left) (symbols right))
          (+ (weight left) (weight right))
    )
)

(define (left-branch tree)
    (car tree)
)

(define (right-branch tree)
    (cadr tree)
)

(define (symbols tree)
    (if (leaf? tree)
        (list (symbol-leaf tree)) 
        (caddr tree))
)

(define (weight tree)
    (if (leaf? tree)
        (weight-leaf tree)
        (cadddr tree))
)

(define (decode bits tree)
    (define (decode-iter bits current-branch)
        (if (null? bits)
            '()
            (let ((next-branch (choose-branch (car bits) current-branch)))
                (if (leaf? next-branch)
                            (cons (symbol-leaf next-branch) (decode-iter (cdr bits) tree))
                            (decode-iter (cdr bits) next-branch))        
            )    
        )
    )
    (decode-iter bits tree)
)


(define (choose-branch bit branch)
    (cond ((= 0 bit) (left-branch branch))
          ((= 1 bit) (right-branch branch))
          (else 
                (error "bad bit -- CHOOSE-BRANCH" bit))
    )
)


(define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set))) (cons x (adjoin-set x (cdr set))))
          (else 
                (adjoin-set x (cdr set)))
    )
)

(define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
            (adjoin-set (make-leaf (car pair) (cadr pair)) (make-leaf-set (cdr pairs)))      
        )  
    )
)