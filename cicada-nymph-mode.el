;;; cicada-nymph-mode.el -- major mode for editing cicada-nymph code

;; Copyright (C) 2015, XIE Yuheng <xyheme@gmail.com>

;; Author: XIE Yuheng <xyheme@gmail.com>

;; Permission to use, copy, modify, and/or distribute this software
;; for any purpose with or without fee is hereby granted,
;; provided that the above copyright notice
;; and this permission notice appear in all copies.

;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


;;; Usage :

;; Do not insert ascii TAB char in cicada-nymph-mode.

;; add the following to your ``.emacs'' :
;; (add-to-list 'load-path "{path to the directory that contain xyh-emacs-lib.el}")
;; (add-to-list 'load-path "{path to the directory that contain cicada-nymph-mode.el}")
;; (require 'cicada-nymph-mode)

;; note that
;; auto-indentation is not supported by cicada-nymph-mode.el
;; because auto-indentation functions written by other people
;; always do not satisfy my need,
;; while I provide the following functions to help you to indent your code :
;; ``turn-on-indent'' ``turn-off-indent''
;; ``move-line-foreword'' ``move-line-backword''
;; these four functions are defined in ``xyh-emacs-lib.el''

;; if you want to use other colors to highlight the code
;; just uncomment the ``color-test'' parts in
;; ``make-faces'' and ``setq cicada-nymph-font-lock-keywords''
;; restart emacs, and add the following words into
;; a buffer with ``cicada-nymph-mode'',
;; you will see these words highlighted,
;; then you could just make your choices
;; and hack the definitions of syntax highlighting :

;;; the way I use cicada-nymph-mode :
;; (add-to-list 'load-path "~/.emacs.d/cicada-nymph-mode/")
;; (require 'cicada-nymph-mode)
;; (require 'inferior-cicada-nymph-mode)

;; ;; (define-prefix-command 'C-s-map)
;; ;; (global-set-key (kbd "C-s") 'C-s-map)
;; (defun switch-to-buffer-*cicada-nymph* ()
;;   (interactive)
;;   (if (member-string? "*cicada-nymph*" (mapcar 'buffer-name (buffer-list)))
;;       (let ()
;;         (switch-to-buffer "*cicada-nymph*")
;;         (local-set-key (kbd "C-s C-d") 'previous-buffer))
;;     (let ()
;;       (run-cicada-nymph "cicada-nymph"))))
;; (global-set-key (kbd "C-s C-d") 'switch-to-buffer-*cicada-nymph>>

;; (add-hook 'cicada-nymph-mode-hook
;;  (lambda ()
;;    (local-set-key (kbd "C-h") 'hippie-expand)
;;    (local-set-key (kbd "M-q") 'query-replace)
;;    (local-set-key (kbd "C-c C-e")
;;                   'cicada-nymph-send-region-and-split-window)
;;    (local-set-key (kbd "C-<tab>")
;;                   'cicada-nymph-send-line-and-split-window-and-goto-next-line)))


;;; Bugs:

;; 1 :
;; sometimes, when using ``<<'' at the beginning, and ``>>'' at the end,
;; to comment many lines of code,
;; syntax highlighting of the comment will fail.
;; to kill this bug,
;; one HAVE TO scan almost the whole buffer very frequently,
;; this will make the performance unacceptable (to me).
;; And I will wait for a better text editor to solve this problem.
;; I will NOT provide ``\'' and ``end-of-line'' as a another pair
;; to make comment in cicada-nymph,
;; NOR will I comment many continuous lines
;; with many ``<<'' ``>>'' pairs in my cicada-nymph code.
;; because my friends and I will write a new text editor to solve this !!


(require 'xyh-emacs-lib)
(provide 'cicada-nymph-mode)

;; a syntax-table is a char-table
;; ``forward-word'' should act as finely as possible,
;; however, my highlighting must use
;; ``word-start'' and ``word-end''
;; to match the zero-length-string of start/end of a cicada-nymph-word,
;; of which the constituent is from ascii.33 to ascii.126
;; so, I have to redefine the functions such as ``forward-word''.
;; (make-syntaxes cicada-nymph-mode-syntax-table
;;                ;; default is word constituent
;;                ;; whitespace characters:
;;                (   '(0 . 32)    "-"  )
;;                (      127       "-"  ))

(make-syntaxes cicada-nymph-mode-syntax-table
               ;; note that, if modify one syntax entry twice
               ;; the second will shadow the first
               ;; whitespace characters:
               (   '(0 . 32)    "-"  )
               (      127       "-"  )
               ;; symbol constituent:
               ;; the following functions need this:
               ;; ``forward-word'' and so on ...
               ;; (  '(33 . 47)    "_"  )
               ;; (  '(58 . 64)    "_"  )
               ;; (  '(91 . 96)    "_"  )
               ;; ( '(123 . 126)   "_"  )
               ;; open/close delimiter:
               ;; the following functions need this:
               ;; ``forward-sexp'' ``backward-sexp''
               ;; ``mark-sexp'' and so on ...
               (  ?\(    "("  )
               (  ?\)    ")"  )
               (  ?\[    "("  )
               (  ?\]    ")"  )
               (  ?\{    "("  )
               (  ?\}    ")"  ))

(make-syntaxes cicada-nymph-mode-syntax-table-with-symbol&with-open/close-delimiter
               ;; note that, if modify one syntax entry twice
               ;; the second will shadow the first
               ;; whitespace characters:
               (   '(0 . 32)    "-"  )
               (      127       "-"  )
               ;; symbol constituent:
               ;; the following functions need this:
               ;; ``forward-word'' and so on ...
               (  '(33 . 47)    "_"  )
               (  '(58 . 64)    "_"  )
               (  '(91 . 96)    "_"  )
               ( '(123 . 126)   "_"  )
               ;; open/close delimiter:
               ;; the following functions need this:
               ;; ``forward-sexp'' ``backward-sexp''
               ;; ``mark-sexp'' and so on ...
               (  ?\(    "("  )
               (  ?\)    ")"  )
               (  ?\[    "("  )
               (  ?\]    ")"  )
               (  ?\{    "("  )
               (  ?\}    ")"  ))

(make-syntaxes cicada-nymph-mode-syntax-table-with-symbol
               ;; note that, if modify one syntax entry twice
               ;; the second will shadow the first
               ;; whitespace characters:
               (   '(0 . 32)    "-"  )
               (      127       "-"  )
               ;; symbol constituent:
               ;; the following functions need this:
               ;; ``forward-word'' and so on ...
               (  '(33 . 47)    "_"  )
               (  '(58 . 64)    "_"  )
               (  '(91 . 96)    "_"  )
               ( '(123 . 126)   "_"  ))

(make-syntaxes cicada-nymph-mode-syntax-table-with-open/close-delimiter
               ;; note that, if modify one syntax entry twice
               ;; the second will shadow the first
               ;; whitespace characters:
               (   '(0 . 32)    "-"  )
               (      127       "-"  )
               ;; open/close delimiter:
               ;; the following functions need this:
               ;; ``forward-sexp'' ``backward-sexp''
               ;; ``mark-sexp'' and so on ...
               (  ?\(    "("  )
               (  ?\)    ")"  )
               (  ?\[    "("  )
               (  ?\]    ")"  )
               (  ?\{    "("  )
               (  ?\}    ")"  ))

(defun cicada-nymph-rebinding-functions-with-symbol-help (rebinding)
  `(define-key a-keymap ,(car rebinding)
     '(lambda ()
       (interactive)
       (with-syntax-table
           cicada-nymph-mode-syntax-table-with-symbol
         (,(cadr rebinding))))))
(defmacro cicada-nymph-rebinding-functions-with-symbol (&rest lis)
  (cons 'progn
        (mapcar
         (function cicada-nymph-rebinding-functions-with-symbol-help)
         lis)))

(defun cicada-nymph-rebinding-functions-with-open/close-delimiter-help (rebinding)
  `(define-key a-keymap ,(car rebinding)
     '(lambda ()
       (interactive)
       (with-syntax-table
           cicada-nymph-mode-syntax-table-with-open/close-delimiter
         (,(cadr rebinding))))))
(defmacro cicada-nymph-rebinding-functions-with-open/close-delimiter (&rest lis)
  (cons 'progn
        (mapcar
         (function cicada-nymph-rebinding-functions-with-open/close-delimiter-help)
         lis)))

(defun cicada-nymph-rebinding-functions-with-symbol&with-open/close-delimiter-help (rebinding)
  `(define-key a-keymap ,(car rebinding)
     '(lambda ()
       (interactive)
       (with-syntax-table
           cicada-nymph-mode-syntax-table-with-symbol&with-open/close-delimiter
         (,(cadr rebinding))))))
(defmacro cicada-nymph-rebinding-functions-with-symbol&with-open/close-delimiter (&rest lis)
  (cons 'progn
        (mapcar
         (function cicada-nymph-rebinding-functions-with-symbol&with-open/close-delimiter-help)
         lis)))

(defun say-this-key-is-not-bound ()
  (interactive)
  (message "this key is not bound!"))

(setq cicada-nymph-mode-map
      (let ((a-keymap (make-keymap)))

        ;; rebinding functions which look syntax-table
        (cicada-nymph-rebinding-functions-with-symbol&with-open/close-delimiter
         ((kbd "s-s") forward-sexp)
         ((kbd "s-w") backward-sexp)
         ;; ((kbd "s-a") mark-sexp)
         ((kbd "s-e") in->)
         ((kbd "s-q") <-out)
         ((kbd "s-d") out->)
         ((kbd "M-f") forward-word)
         ((kbd "M-b") backward-word))
        (cicada-nymph-rebinding-functions-with-symbol
         ((kbd "M-d") (lambda () (kill-word 1)))
         ((kbd "M-DEL") (lambda () (backward-kill-word 1))))

        ;; no bother:
        (define-key a-keymap (kbd "M-t") 'say-this-key-is-not-bound)
        (define-key a-keymap (kbd "M-o") 'say-this-key-is-not-bound)
        (define-key a-keymap (kbd "M-l") 'say-this-key-is-not-bound)
        (define-key a-keymap (kbd "M-c") 'say-this-key-is-not-bound)

        ;; for indentation:
        (define-key a-keymap (kbd "M-u") 'move-line-backword)
        (define-key a-keymap (kbd "M-i") 'move-line-foreword)
        (define-key a-keymap (kbd "<tab>") '(lambda () (interactive) nil))

        ;; for comment:
        (define-key a-keymap (kbd "<menu> <menu>")
          '(lambda () (interactive)
            (insert "<< ")
            (point-to-register 666)
            (insert " -- >>")
            (jump-to-register 666)))

        a-keymap))


(make-faces
 (cicada-nymph-comment-face          ((default (:foreground "#FF8888"))))
 (cicada-nymph-end-face              ((default (:foreground "#00ffff" :bold t))))
 (cicada-nymph-syntax-key-word-face  ((default (:foreground "#f92672" :bold t))))
 (cicada-nymph-number-face           ((default (:foreground "#fd971f" :bold t))))
 (cicada-nymph-sentence-reader-face  ((default (:foreground "#ffff00" :bold t))))
 (cicada-nymph-word-to-define-face   ((default (:foreground "#ef5939" :bold t))))
 (cicada-nymph-lexicographer-face    ((default (:foreground "#ae81ff" :bold t))))
 (cicada-nymph-variable-face         ((default (:foreground "#fd971f"))))
 (cicada-nymph-bool-face             ((default (:foreground "#fd971f" :bold t))))
 (cicada-nymph-type-face             ((default (:foreground "#fd971f"))))
 (cicada-nymph-char-face             ((default (:foreground "#e6db78"))))
 (cicada-nymph-string-face           ((default (:foreground "#e6db74"))))
 (cicada-nymph-wody-face             ((default (:foreground "#a6e22e" :bold t))))

 (cicada-nymph-fetch-local-variable-1-face ((default (:foreground "#83EA83" :bold t))))
 (cicada-nymph-fetch-local-variable-2-face ((default (:foreground "#5CDD5C" :bold t))))
 (cicada-nymph-fetch-local-variable-3-face ((default (:foreground "#3DCD3D" :bold t))))
 (cicada-nymph-fetch-local-variable-4-face ((default (:foreground "#1DBB1D" :bold t))))

 (cicada-nymph-save-local-variable-1-face ((default (:foreground "#FF4C4C" :bold t))))
 (cicada-nymph-save-local-variable-2-face ((default (:foreground "#dc322f" :bold t))))
 (cicada-nymph-save-local-variable-3-face ((default (:foreground "#D41C1C" :bold t))))
 (cicada-nymph-save-local-variable-4-face ((default (:foreground "#AF0B0B" :bold t))))
 (cicada-nymph-save-local-variable-@-face ((default (:foreground "#AE7C3B" :bold t))))

 (cicada-nymph-square-brackets-face ((default (:foreground "#93a8c6"))))
 (cicada-nymph-parentheses-face     ((default (:foreground "#b0b1a3"))))
 (cicada-nymph-curly-braces-face    ((default (:foreground "#aebed8"))))
 )


;; non blank:
;; (not (in (0 . 32) 127))
;; alphabet or number:
;; (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))

(setq
 cicada-nymph-font-lock-keywords
 `(;; in the following, order matters

   ;; string
   (,(rx (minimal-match
          (seq word-start
               (group "\""
                      (one-or-more (not (in 34)))
                      "\"")
               word-end)))
     (1 'cicada-nymph-string-face))

   ;; comment
   (;; ,(rx (minimal-match
    ;;       (seq (minimal-match
    ;;             (seq word-start
    ;;                  (group "<<")
    ;;                  word-end
    ;;                  (minimal-match (group (zero-or-more anything)))))
    ;;            ;; (minimal-match
    ;;            ;;  (seq word-start
    ;;            ;;       (group ">>")
    ;;            ;;       word-end))
    ;;            (seq word-start
    ;;                 (group ">>")
    ;;                 word-end)
    ;;            )))
    ,(rx (seq (minimal-match
               (seq word-start
                    (group "<<")
                    word-end
                    (minimal-match (group (zero-or-more anything)))))
              ;; (minimal-match
              ;;  (seq word-start
              ;;       (group ">>")
              ;;       word-end))
              (seq word-start
                   (group ">>")
                   word-end)))
     (1 'cicada-nymph-comment-face t)
     (2 'cicada-nymph-comment-face t)
     (3 'cicada-nymph-comment-face t))

   ;; very special words
   (,(rx word-start
         (group (or "end"
                    "<>"))
         word-end)
     (1 'cicada-nymph-end-face))

   (,(rx word-start
         (group (or ;; "literal"
                 "branch"
                 "address"
                 ;; "char"
                 ;; "string"
                 "false?branch"
                 "if"
                 "else"
                 "then"
                 ))
         word-end)
     (1 'cicada-nymph-syntax-key-word-face))


   ;; lexicographer & reader for lexicographer
   (,(rx (seq word-start
              (group (or ":"))
              (one-or-more " ")
              (group (one-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-sentence-reader-face)
     (2 'cicada-nymph-word-to-define-face))

   (,(rx word-start
         (group (or ";"))
         word-end)
     (1 'cicada-nymph-sentence-reader-face)
     (,(rx word-start
           (group (one-or-more (not (in (0 . 32) 127))))
           word-end)
       nil
       nil
       (1 'cicada-nymph-lexicographer-face)))

   ;; number
   (,(rx word-start
         (group (zero-or-one "-")
                (one-or-more (in (?0 . ?9))))
         word-end)
     (1 'cicada-nymph-number-face))


   ;; variable
   (,(rx (seq word-start
              (group "*"
                     (one-or-more (not (in (0 . 32) 127)))
                     "*")
              word-end))
     (1 'cicada-nymph-variable-face))

   ;; important-noun
   (,(rx word-start
         (group (or "false"
                    "true"
                    ))
         word-end)
     (1 'cicada-nymph-bool-face))

   ;; char
   (,(rx (seq word-start
              (group "'"
                     (zero-or-more (not (in (0 . 32) 127)))
                     "'")
              word-end))
     (1 'cicada-nymph-char-face))


   ;; fetch-local-variable
   (,(rx (seq word-start
              (group ":"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-fetch-local-variable-1-face))
   (,(rx (seq word-start
              (group "::"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-fetch-local-variable-2-face))
   (,(rx (seq word-start
              (group ":::"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-fetch-local-variable-3-face))
   (,(rx (seq word-start
              (group "::::"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-fetch-local-variable-4-face))


   ;; save-local-variable
   (,(rx (seq word-start
              (group ">:"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-save-local-variable-1-face))
   (,(rx (seq word-start
              (group "@:"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-save-local-variable-@-face))
   (,(rx (seq word-start
              (group ">::"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-save-local-variable-2-face))
   (,(rx (seq word-start
              (group ">:::"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-save-local-variable-3-face))
   (,(rx (seq word-start
              (group ">::::"
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127))))
              word-end))
     (1 'cicada-nymph-save-local-variable-4-face))

   ;; wody
   (,(rx (seq word-start
              (group
               (or
                (seq (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     (zero-or-more (not (in (0 . 32) 127)))
                     (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     ":")
                (seq (not (in (0 . 47) (58 . 64) (91 . 96) (123 . 127)))
                     ":")))
              word-end))
     (1 'cicada-nymph-wody-face))


   ;; type
   (,(rx (seq word-start
              (group "<"
                     (one-or-more (not (in (0 . 32) 127)))
                     ">")
              word-end))
     (1 'cicada-nymph-type-face))


   ;; square-brackets
   (,(rx (seq ;; word-start
          (group (or "[" "]"))
          ;; word-end
          ))
     (1 'cicada-nymph-square-brackets-face))

   ;; parentheses
   (,(rx (seq ;; word-start
          (group (or "(" ")"))
          ;; word-end
          ))
     (1 'cicada-nymph-parentheses-face))

   ;; curly-braces
   (,(rx (seq ;; word-start
          (group (or "{" "}"))
          ;; word-end
          ))
     (1 'cicada-nymph-curly-braces-face))
   ))


(defvar cicada-nymph-mode-hook nil)


;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cn$" . cicada-nymph-mode))

(defun cicada-nymph-mode ()
  "major mode for editing cicada-nymph language files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table cicada-nymph-mode-syntax-table)
  (use-local-map cicada-nymph-mode-map)
  (set (make-local-variable 'font-lock-defaults)
       '(cicada-nymph-font-lock-keywords))
  (set (make-local-variable
        'comment-start) "<<")
  (set (make-local-variable
        'comment-end)  ">>")
  (set (make-local-variable
        'comment-style)  'extra-line)
  (setq major-mode 'cicada-nymph-mode)
  (setq mode-name "cicada-nymph")
  (turn-off-indent)
  (run-hooks 'cicada-nymph-mode-hook))
