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
          ((< (weight x) (weight (car set))) (cons x set))
          (else 
                (cons (car set) (adjoin-set x (cdr set)))
            )
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

(define tree (make-code-tree (make-leaf 'A 4)
                   (make-code-tree (make-leaf 'B 2)
                                   (make-code-tree (make-leaf 'D 1)
                                                   (make-leaf 'C 1)))))


(define msg '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(decode msg tree)

(define (encode message tree)
    (if (null? message)
        '()
        (append (encode-symbol (car message) tree)
                (encode (cdr message) tree))
    )
)

(define (encode-symbol symbol tree)
    (cond ((leaf? tree) '())
          ((symbol-in-tree? symbol (left-branch tree)) 
                (cons 0 (encode-symbol symbol (left-branch tree))))
          ((symbol-in-tree? symbol (right-branch tree)) 
                (cons 1 (encode-symbol symbol (right-branch tree))))
          (else 
                (error "This symbol is not in tree: " symbol))
    )
)

(define (symbol-in-tree? symbol tree)
    (not (equal? (find (lambda (x) (eq? x symbol)) (symbols tree)) #f))
)

(define (generate-huffman-tree pairs)
    (successive-merge (make-leaf-set pairs))
)

(define (successive-merge leaves-set)
    (if (null? (cdr leaves-set))
        (car leaves-set)
        (let ((leave0 (car leaves-set))
              (leave1 (cadr leaves-set))
              (remain-leaves (caddr leaves-set)))
            (let ((combined-leave (make-code-tree leave0 leave1)))
                (successive-merge (adjoin-set combined-leave remain-leaves)))
        )

    )
)