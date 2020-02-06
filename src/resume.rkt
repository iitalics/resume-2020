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
           (grad   . "May, 2021"))]))

(define skills
  '(["Languages"
     (;["Racket"           1.0]
      ["Scala"            0.7]
      ["Haskell"          0.8]
      ["Python"           0.8]
      ["Rust"             0.6]
      ["C/C++"            0.6]
      ["Javascript (ES6)" 0.6])]

    ["Software"
     (["Git"              0.8]
      ["GNU/Linux"        0.8]
      ["Emacs"            0.8]
      ["Docker"           0.6])]))

(define projects
  '(["Nanocaml"
     "Compiler extension for the OCaml language. Uses reflection to automate tedious algorithms "
     "commonly found in compilers such as recursive tree traversals."]
    ["Ax"
     "Simple and performant UI toolkit and layout engine. Written in C, but intended to be used for "
     "reactive UI development in OCaml or Racket."]
    ["Opal"
     "Statically-typed programming language. Includes bytecode compiler and garbage-collected runtime "
     "system, with some unique type-system features."]))

(define work-experience
  `(["Software Engineer"
     "Jul–Dec, 2019"
     "Broad Institute of MIT and Harvard"
     "Cambridge, MA"
     (
      ["Worked on compiler backend for an open source Python library "
       "used by geneticists at the Broad Institute."]
      "Extended JVM code-generation infrastructure to enable new kinds of control flow optimizations."
      "Designed a space efficient stream-processing API based on cutting edge code-generation research."
      ;"Implemented data structures for aggregating results of distributed computations."
      )]

    ["Software Engineer"
     "Jul–Dec, 2018"
     "Kumu Networks"
     "Sunnyvale, CA"
     (
      "Maintained React apps used by customers and internal team."
      "Developed Python software to perform hardware stress-tests on multiple devices in parallel."
      "Designed MySQL database schema for tracking and querying hardware diagnostics data."
      ;"Configured GitLab CI service for custom Linux kernel builds."
      )]

    ["Research Assistant"
     ("May–Aug, 2017 +" (br) "May–Jun, 2018")
     "NU Programming Research Lab"
     "Boston, MA"
     (
      ["Developed " (em "Turnstile") ", a domain specific language for implementing type checkers."]
      "Designed new features to enable the implementation of linear and affine type systems."
      ["Collaborated with the maintainer of the "
       (em "Hackett")
       " language, in order to extend it with more advanced type system features."]
      )]

    ["Tutor, Fundamentals of CS"
     "Sep–Dec, 2017"
     "Northeastern University"
     "Boston, MA"
     ("Graded weekly homework assignments and provided feedback to students."
      ["Led two special-topic lab sessions, "
       "having students explore some advanced facilities of the Racket programming language."])]))

(define publications
  '(["Dependent Type Systems as Macros"
     ("Stephen Chang"
      "Michael Ballantyne"
      "Milo Turner"
      "William J. Bowman")
     (POPL 47)]))

;; ---

(require "../mangle.rkt")
(when (getenv "MANGLE")
  (mangle! personal)
  (mangle! education)
  (mangle! skills)
  (mangle! projects)
  (mangle! work-experience)
  (mangle! publications))

(module+ main
  (require "../resume-gen.rkt")
  (gen-resume #:personal personal
              #:education education
              #:skills skills
              #:projects projects
              #:work-experience work-experience
              #:publications publications))
