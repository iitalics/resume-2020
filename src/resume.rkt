#lang racket/base

(define personal
  '#hash((name    . "Milo Turner")
         (github  . "github.com/iitalics")
         (email   . "milo@ccs.neu.edu")
         (phone   . "(808)280-0766")
         (address . "PO BOX 230043, Boston, MA 02123")))

(define education
  '(["Northeastern University"
     "Boston, MA"
     "Khoury College of Computer Sciences"
     "Candidate for Bachelor of Science in Computer Science"
     #hash((gpa    . "3.61/4")
           (honors . "Dean's list")
           (grad   . "May, 2020"))]))

(define skills
  '(["Languages"
     (["Racket"           1.0]
      ["Haskell"          0.8]
      ["Python"           0.8]
      ["Rust"             0.6]
      ["Scala"            0.7]
      ["Javascript (ES6)" 0.6])]

    ["Software"
     (["Git"              0.8]
      ["GNU/Linux"        0.8]
      ["Emacs"            0.8]
      ["Docker"           0.6])]))

(define work-experience
  '(["Software Engineer"
     "Jul-Dec, 2019"
     "Broad Institute of MIT and Harvard"
     "Cambridge, MA"
     ("One" "Two" "Three" "Four")]

    ["Software Engineer"
     "Jul-Dec, 2018"
     "Kumu Networks"
     "Sunnyvale, CA"
     ("One" "Two" "Three" "Four")]

    ["Research Assistant"
     "May-Aug, 2017 + May-Jun, 2018"
     "NU Programming Research Lab"
     "Boston, MA"
     ("One" "Two" "Three" "Four")]

    ["Tutor, Fundamentals of CS"
     "Sep-Dec, 2017"
     "Northeastern University"
     "Boston, MA"
     ("One" "Two")]))

(define publications
  '(["Dependent Type Systems as Macros"
     ("Stephen Chang"
      "Michael Ballantyne"
      "Milo Turner"
      "William J. Bowman")
     (POPL 47)]))

(require "../resume-gen.rkt")
(gen-resume #:personal personal
            #:education education
            #:skills skills
            #:work-experience work-experience
            #:publications publications)
