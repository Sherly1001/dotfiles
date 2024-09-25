;; vi: shiftwidth=2 tabstop=2

;; A list of keys is in /usr/include/X11/keysym.h and in
;; /usr/include/X11/keysymdef.h
;; The XK_ is not needed.

;; List of modifier:
;;   Release, Control, Shift, Mod1 (Alt), Mod2 (NumLock),
;;   Mod3 (CapsLock), Mod4, Mod5 (Scroll).

(use-modules
  (srfi srfi-19)
  (ice-9 popen)
  (ice-9 threads)
  (ice-9 textual-ports))

(define click-threshold 200)
(define drag-threshold 50)

(define (all-but-last l)
  (reverse (cdr (reverse l))))

(define (get key lst)
  (cdr (assoc key lst)))

(define (get-mouse-location)
  (let* ((port (open-input-pipe "xdotool getmouselocation --shell"))
         (content (get-string-all port))
         (pairs (all-but-last (string-split content #\newline))))
    (close-port port)
    (map (lambda (input)
           (let* ((pair (string-split input #\=))
                  (key (car pair))
                  (val (cdr pair)))
             (cons (string->symbol key) (string->number (car val)))))
         pairs)))

(define (get-drag-direction prev-location curr-location)
  (let* ((diff-x (- (get 'X curr-location) (get 'X prev-location)))
         (diff-y (- (get 'Y curr-location) (get 'Y prev-location)))
         (adiff-x (abs diff-x))
         (adiff-y (abs diff-y)))
    (cond
      ((and (> drag-threshold adiff-x) (> drag-threshold adiff-y))
       'none)
      ((> adiff-x adiff-y)
       (if (> 0 diff-x)
         'left
         'right))
      (else
        (if (> 0 diff-y)
          'up
          'down)))))

(define (time-to-milisecond time)
  (+ (* (time-second time)
        (expt 10 3))
     (/ (time-nanosecond time)
        (expt 10 6))))

(define (current-time-mili)
  (time-to-milisecond (current-time)))

(define (emit-command k d commands)
  (let ((cmds (assoc k commands)))
    (if cmds
      (let ((cmd (assoc d (cdr cmds))))
        (if cmd
          (eval (cdr cmd) (interaction-environment)))))))

(define (multi-click-key key commands-normal . commands-long)
  (let ((count 0)
        (time (current-time-mili))
        (mouse-location '()))
    (unless (list? key)
      (set! key (list key)))
    (set! commands-long
      (if (null? commands-long)
        commands-normal
        (begin
          (set! commands-long (car commands-long))
          (if (eq? #t commands-long)
            commands-normal
            commands-long))))
    (xbindkey-function key (lambda ()
      (let ((prev-time time))
        (set! mouse-location (get-mouse-location))
        (set! time (current-time-mili))
        (if (> click-threshold (- time prev-time))
          (set! count (+ count 1))
          (set! count 1)))))
    (xbindkey-function (cons 'release key) (lambda ()
      (let* ((diff-time (- (current-time-mili) time))
             (drag-direction (get-drag-direction mouse-location (get-mouse-location))))
        (if (> click-threshold diff-time)
          (call-with-new-thread (let ((start-time-count count))
            (lambda ()
              (usleep (* (- click-threshold diff-time) 1000))
              (when (= count start-time-count)
                (emit-command start-time-count drag-direction commands-normal)))))
          (when commands-long
            (emit-command count drag-direction commands-long))))))))


;; start binding keys
(define i3-kill "i3-msg kill")
(define i3-sc-show "i3-msg 'scratchpad show'")
(define i3-fl-togg "i3-msg 'floating toggle'")
(define i3-ws-prev "i3-msg 'workspace prev'")
(define i3-ws-next "i3-msg 'workspace next'")
(define mouse-btn-8 "xdotool click --window $(xdotool getactivewindow) 8")
(define mouse-btn-9 "xdotool click --window $(xdotool getactivewindow) 9")

(multi-click-key 'b:8
  '((1 . ((none . (run-command mouse-btn-8))
          (right . (run-command i3-ws-prev))
          (left . (run-command i3-ws-next))
          (up . (run-command i3-sc-show))))
    (2 . ((none . (run-command i3-fl-togg))))))

(multi-click-key 'b:9
  '((1 . ((none . (run-command mouse-btn-9))
          (right . (run-command mouse-btn-8))
          (left . (run-command mouse-btn-9))))
    (2 . ((none . (run-command i3-kill))))))
