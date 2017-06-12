#lang racket
(require scheme/mpair)

(define (solve Case) (let ((n (read)) (m (read)) (k (read)))
	
	(define a (make-vector (* n m)))
	(define (As x y k) (vector-set! a (+ (* m x) y) k))
	(define (Ar x y) (vector-ref a (+ (* m x) y)))
	(for-each (lambda (i)
		(for-each (lambda (j)
			(As i j (read))
		) (range m))
	) (range n))
	
	(define f (make-vector (* (add1 k) n m) +inf.0))
	(define (tr x y z) (+ (* x n m) (* y m) z))
	(define (Fr x y z) (vector-ref f (tr x y z)))
	(define (Fs x y z k) (vector-set! f (tr x y z) k))
	
	(Fs 0 0 0 0)
	(define tail (mcons (list 0 0 0) '()))
	(define (expand z x y d)
		(unless (or (< x 0) (>= x n) (< y 0) (>= y m) (eq? (Ar x y) 'W))
			(when (eq? (Ar x y) 'M) (set! z (add1 z)))
			(when (and (<= z k) (= (Fr z x y) +inf.0))
				(Fs z x y (add1 d))
				(set-mcdr! tail (mcons (list z x y) '()))
				(set! tail (mcdr tail))
			)
		)
	)
	(define (loop head) (let ((cur (mcar head)))
		(let* ( (z (car cur)) (x (cadr cur)) (y (caddr cur)) (d (Fr z x y)) )
			(expand z (add1 x) y d)
			(expand z (sub1 x) y d)
			(expand z x (add1 y) d)
			(expand z x (sub1 y) d)
		)
		(unless (null? (mcdr head)) (loop (mcdr head)))
	))
	(loop tail)
	
	(define ans +inf.0)
	(for-each (lambda (i)
		(set! ans (min ans (Fr i (- n 1) (- m 1))))
	) (range (+ k 1)))

	(displayln (if (= ans +inf.0) "inf" ans))
)
)

(for-each solve (range (read)))