#lang racket
(provide gen-resume)
(require xml)

(define (gen-resume #:personal prs
                    #:education edu
                    #:skills skl
                    #:projects prj
                    #:work-experience wrk
                    #:publications pub
                    #:style [style "2c"])
  (write-xexpr
   (resume #:personal prs
           #:education edu
           #:skills skl
           #:projects prj
           #:work-experience wrk
           #:publications pub
           #:style style)))

(define (resume #:personal prs
                #:education edu
                #:skills skl
                #:projects prj
                #:work-experience wrk
                #:publications pub
                #:style style)
  `(html
    (head
     (meta ([charset "utf8"]))
     (link ([rel "stylesheet"]
            [type "text/css"]
            [href ,(format "~a.css" style)])))
    (body
     ,(main (list (header prs)
                  (personal prs)
                  (education edu)
                  (skills skl)
                  (projects prj))
            (list (work-exp wrk)
                  (publications pub))
            #:style style))))

(define rich
  (match-lambda
    [(? string? s) (list s)]
    [(? list? xs) xs]))

;; --------------------

(define (header info)
  (define name (hash-ref info 'name))
  `(header (h1 () ,name)))

;; --------------------

(define (personal info)
  (define (info-tr key label value-class)
    (match (hash-ref info key #f)
      [#f ""]
      [value `(tr (td ([class ,(format "label ~a" key)]) ,label)
                  (td ([class ,value-class]) ,@(rich value)))]))
  `(section ([class "info"])
            (h1 "Personal Info")
            (table ,@(for/list ([x '([github "github:" "mono"]
                                     [email  "email:"  "mono"]
                                     [phone  "phone:"  "mono"])])
                       (apply info-tr x)))))

;; --------------------

(define (education xs)
  (define (edu x)
    (match-define (list school where college degree stats) x)
    (define (stat-tr key label value-class)
      (match (hash-ref stats key #f)
        [#f ""]
        [value `(tr (td ([class ,(format "label ~a" key)]) ,label)
                    (td ([class ,value-class]) ,@(rich value)))]))
    `(div (h2 ([class "school"]) ,school)
          (h3 ([class "where"]) ,where)
          (h3 ([class "college"]) ,college)
          (h3 ([class "degree"]) ,degree)
          (table ,@(for/list ([x '([gpa "GPA:" ""]
                                   [honors "honors:" ""]
                                   [grad "expected graduation:" "time"])])
                     (apply stat-tr x)))))
  `(section ([class "edu"])
            (h1 "Education")
            ,@(map edu xs)))

;; --------------------

(define (skills xs)
  (define (skl x)
    (match-define (list cat entries) x)
    `(article (h2 ,cat)
              (p ,(string-join (map car entries)
                               ", "))))
  `(section ([class "skills"])
            (h1 "Skills")
            ,@(map skl xs)))

#;
(define (skills xs)
  (define (skl x)
    (match-define (list cat entries) x)
    (define (tr name amt)
      (define w1 (exact-ceiling (* amt 8)))
      (define w2 (- 8 w1))
      `(tr (td ([class "label"]) ,name)
           (td (span ([class ,(format "bar full w~a" w1)]))
               (span ([class ,(format "bar empty w~a" w2)])))))
    `(article (h2 ,cat)
              (table ,@(for/list ([e (in-list entries)])
                         (apply tr e)))))
  `(section ([class "skills"])
            (h1 "Skills")
            ,@(map skl xs)))

;; --------------------

(define (projects xs)
  (define (prj x)
    (match-define (cons name text) x)
    `(article
      (h2 () ,@(rich name))
      (p () ,@(rich text))))
  `(section ([class "projects"])
            (h1 "Projects")
            ,@(map prj xs)
            (h3 "(all projects available on GitHub)")))

;; --------------------

(define (work-exp xs)
  (define (wrk job when place where points)
    `(article ([class "exp"])
              (div ([class "row"])
                   (h2 ([class "job"]) ,@(rich job))
                   (h2 ([class "when"]) ,@(rich when)))
              (div ([class "row"])
                   (h2 ([class "place"]) ,@(rich place))
                   (h2 ([class "where"]) ,@(rich where)))
              (ul ,@(for/list ([p (in-list points)])
                      `(li ,@(rich p))))))
  `(section ([class "work"])
            (h1 "Work Experience")
            ,@(for/list ([x (in-list xs)])
                (apply wrk x))))

;; --------------------

(define (conference-name desc)
  (match desc
    [`(POPL ,n)
     (format (string-append "Proceedings of the ~ath "
                            "Symposium on Principles "
                            "of Programming Languages (POPL)")
             n)]))

(define (publications xs)
  (define (pub name authors conf)
    `(article ([class "paper"])
              (h2 ([class "pubname"]) (span ([class "dquo"]) ,@(rich name)))
              (h2 ([class "pubauths"]) ,(string-join authors ", "))
              (h2 ([class "pubconf"])
                  "In " (span ([class "proceedings"]) ,(conference-name conf)) ".")))
  `(section ([class "work pub"])
            (h1 "Publications")
            ,@(for/list ([x (in-list xs)])
                (apply pub x))))

;; --------------------

(define (main about-sections
              experience-sections
              #:style style)
  (match style
    ["2c"
     `(main
       (div ([id "lc"]) ,@about-sections)
       (div ([id "rc"]) ,@experience-sections))]))
