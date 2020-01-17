#lang racket/base
(provide
 mangled-string
 mangled
 mangle!)

(require
 racket/match
 racket/list)

(define MANGLE-CHAR-SETS
  '("abcdefghijklmnopqrstuvwxyz"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "0123456789"))

(define (string-has-char? s c0)
  (for/or ([c (in-string s)])
    (char=? c c0)))

(define (string-weight s)
  (for/sum ([c (in-string s)])
    (match c
      [(or #\m #\w #\Q) 1.2]
      [(or #\f #\i #\j #\l #\I #\J) 0.5]
      [_ 1.0])))

(define (mangled-chars cs)
  (for/list ([c (in-list cs)])
    (or (for/first ([s (in-list MANGLE-CHAR-SETS)]
                    #:when (string-has-char? s c))
          (string-ref s (random (string-length s))))
        c)))

(define (mangled-string s)
  (match (regexp-match #px"^([0-9a-zA-Z']+)|." s)
    [#f ""]
    [(list pre mangle?)
     (define suf (substring s (string-length pre)))
     (define (weight-error s*)
       (abs (- (string-weight s*) (string-weight pre))))
     (string-append (argmin weight-error
                            (for/list ([i (in-range 10)])
                              (list->string (mangled-chars (string->list pre)))))
                    (mangled-string suf))]))

(define (mangled sexp)
  (cond
    [(string? sexp) (mangled-string sexp)]
    [(pair? sexp) (cons (mangled (car sexp))
                        (mangled (cdr sexp)))]
    [(hash? sexp) (for/hash ([(k v) (in-hash sexp)])
                    (values k (mangled v)))]
    [else sexp]))

(define-syntax-rule (mangle! x)
  (set! x (mangled x)))
