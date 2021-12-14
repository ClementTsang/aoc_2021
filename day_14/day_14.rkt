#lang racket/base

(require racket/string)

(define (solve file steps)
  (define saw-newline #f)
  (define template '())
  (define pairs (make-hash))
  (define counts (make-hash))

  (for ([line (in-lines (open-input-file file))])
    (cond
      [(non-empty-string? line)
       (cond
         [saw-newline
          (define pair (map string-trim (string-split line "->")))
          (hash-set! pairs (car pair) (car (cdr pair)))
          (hash-set! counts (car pair) 0)
          ]
         [else
          (for ([i (in-range (- (string-length line) 1))])
            (set! template (cons (substring line i (+ i 2)) template))
            )
          ]
         )
       ]
      [else
       (set! saw-newline #t)
       ]
      )
    )

  (for ([ele (in-list template)])
    (hash-set! counts ele (+ 1 (hash-ref counts ele)))
    )

  (for ([i (in-range steps)])
    (define new-counts (make-hash))

    (for ([ele+cnt (in-hash-pairs counts)])
      (define ele (car ele+cnt))
      (define cnt (cdr ele+cnt))
      (define val (hash-ref pairs ele))
      (define l (string-append (substring ele 0 1) val))
      (define r (string-append val (substring ele 1 2)))

      (hash-set! new-counts l (+ cnt (hash-ref! new-counts l 0)))
      (hash-set! new-counts r (+ cnt (hash-ref! new-counts r 0)))
      (hash-set! new-counts ele (- (hash-ref! new-counts ele 0) cnt))
      )
    (for ([ele+cnt (in-hash-pairs new-counts)])
      (define ele (car ele+cnt))
      (define cnt (cdr ele+cnt))
      (hash-set! counts ele (+ cnt (hash-ref counts ele)))
      )
    )

  (define element-counts (make-hash))
  (for ([ele+cnt (in-hash-pairs counts)])
    (define ele (car ele+cnt))
    (define cnt (cdr ele+cnt))
    (define a (substring ele 0 1))
    (define b (substring ele 1 2))
    (hash-set! element-counts a (+ cnt (hash-ref! element-counts a 0)))
    (hash-set! element-counts b (+ cnt (hash-ref! element-counts b 0)))
    )

  (for ([ele+cnt (in-hash-pairs element-counts)])
    (define ele (car ele+cnt))
    (define cnt (cdr ele+cnt))
    (hash-set! element-counts ele (ceiling (/ cnt 2)))
    )

  (define smallest (apply min (hash-values element-counts)))
  (define biggest (apply max (hash-values element-counts)))

  (display biggest)
  (display " - ")
  (display smallest)
  (display " = ")
  (displayln (- biggest smallest))
  )

(solve "input.txt" 10)
(solve "input.txt" 40)