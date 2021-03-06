(define (entry tree)
  (car tree))

(define (left-branch tree)
  (cadr tree))

(define (right-branch tree)
  (caddr tree))

(define (make-tree entry left-branch right-branch)
  (list entry left-branch right-branch))

(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((= x (entry set)) #t)
          ((< x (entry set)) 
                (element-of-set? x (left-branch set)))
          ((> x (entry set)) 
                (element-of-set? x (right-branch set)))
    )
)

(define (adjoin-set x set)
    (cond ((null? set) (make-tree x '() '()))
          ((= x (entry set)) set)
          ((< x (entry set))
                (make-tree (entry set) (adjoin-set x (left-branch set)) (right-branch set))
          )
          ((> x (entry set))
                (make-tree (entry set) (left-branch set) (right-branch set))
          )
    )
)

(define (tree->list1 tree)
    (if (null? tree)
        '()
        (append (tree->list1 (left-branch tree)) (cons (entry tree) (tree->list1 (right-branch tree)))))
)

(define (tree->list2 tree)
    (define (copy-to-list tree result-list)
        (if (null? tree)
            result-list  
            (copy-to-list (left-branch tree) (cons (entry tree) (copy-to-list (right-branch tree) result-list)))
        )  
    )
    (copy-to-list tree '())
)

(define (partial-tree elts n)
    (if (= n 0)
        (cons '() elts)
        (let ((left-size (quotient (- n 1) 2)))
            (let ((left-result (partial-tree elts left-size)))
                (let ((left-tree (car left-result))
                      (non-left-elts (cdr left-result))
                      (right-size (- n left-size 1)))
                    (let ((this-entry (car non-left-elts))
                          (right-result (partial-tree (cdr non-left-elts) right-size)))
                        (let ((right-tree (car right-result))
                              (remaining-elts (cdr right-result)))
                            (cons (make-tree this-entry left-tree right-tree) remaining-elts))
                    )
                )
            )        
        )    
    )
)

(define (list->tree element)
    (car (partial-tree element (length element)))
)

(define (intersection-set set1 set2)
    (if (or (null? set1) (null? set2))
            '()
            (let ((x1 (car set1))
                  (x2 (car set2)))
                (cond ((= x1 x2) (cons x1 (intersection-set (cdr set1) (cdr set2))))
                      ((< x1 x2) (intersection-set (cdr set1) set2))
                      ((> x1 x2) (intersection-set set1 (cdr set2)))
                )
            )
    )    
)



(define (union-set set1 set2)
    (cond ((and (null? set1) (null? set2)) 
                '())
          ((or (null? set1) (null? set2)) 
                (append set1 set2))
          (else 
                (let ((x1 (car set1))
                      (x2 (car set2)))
                    (cond ((= x1 x2) 
                                (cons x1 (union-set (cdr set1) (cdr set2))))
                          ((< x1 x2) 
                                (cons x1 (union-set (cdr set1) set2)))
                          ((> x1 x2)
                                (cons x2 (union-set set1 (cdr set2))))
                    )
                )
          )
    )  
)

(define (intersction-tree tree1 tree2)
    (list->tree (intersection-set 
                    (tree->list2 tree1)
                    (tree->list2 tree2)))
)

(define (union-tree tree1 tree2)
    (list->tree (union-set 
                    (tree->list2 tree1)
                    (tree->list2 tree2)))
)


(define (key record)
  (car record))

(define (lookup given-key set-of-records)
    (cond ((null? set-of-records) #f)
          ((equal? given-key (key (car set-of-records)))
                (car set-of-records))
          (else 
                (lookup given-key (cdr set-of-records)))
    )
)

(define (lookup given-key tree-of-record)
    (if (null? tree-of-record)
        #f
        (let ((entry-key (key (entry tree-of-record)))
              (entry-record (entry tree-of-record))
        )
            (cond ((= entry-key given-key) entry-record)
                  ((< given-key entry-key) (lookup given-key (left-branch tree-of-record)))
                  ((> given-key entry-key) (lookup given-key (right-branch tree-of-record)))
            )
        )
    )
)