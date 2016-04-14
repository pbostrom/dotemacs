;; column number mode
(setq column-number-mode t)

(require 'package)
(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

(defun load-melpa-stable ()
  (interactive)
  (package-initialize)
  (add-to-list 'package-archives
	       '("melpa-stable" . "http://stable.melpa.org/packages/") t))

(defun load-melpa ()
  (package-initialize)
  (add-to-list 'package-archives
	       '("melpa" .
		 "http://melpa.milkbox.net/packages/")))

(defun default-indent ()
  (setq clojure-defun-style-default-indent t))

;;(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
  ;;                       ("marmalade" . "http://marmalade-repo.org/packages/")
    ;;                     ("melpa" . "http://melpa.milkbox.net/packages/")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups"))))
 '(cider-cljs-lein-repl
   "(do (require 'cljs.repl.node) (cemerick.piggieback/cljs-repl (cljs.repl.node/repl-env)))")
 '(custom-safe-themes
   (quote
    ("0b2e94037dbb1ff45cc3cd89a07901eeed93849524b574fa8daa79901b2bfdcf" default)))
 '(inhibit-startup-screen t)
 '(magit-status-show-hashes-in-headers t)
 '(magit-tag-arguments (quote ("--annotate" "--sign")))
 '(ns-alternate-modifier (quote meta))
 '(ns-command-modifier (quote control))
 '(sql-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ido mode
(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)

;; smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(setq-default show-trailing-whitespace t)

;; custom theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'tron t)

;; magit colors
(require 'magit)
;;(set-face-foreground 'magit-diff-add "brightgreen")
;;(set-face-foreground 'magit-diff-del "brightred")
;;(set-face-background 'magit-item-highlight "brightblack")

(require 'evil)
(evil-mode 1)
(define-key evil-motion-state-map "\t" nil)
(define-key evil-normal-state-map (kbd "M-.") nil)
(define-key evil-normal-state-map "q" nil)

(define-key evil-normal-state-map "\C-d" 'evil-delete-char)
(define-key evil-insert-state-map "\C-d" 'evil-delete-char)
(define-key evil-visual-state-map "\C-d" 'evil-delete-char)

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code."
  t)

(defun cider-ji-and-switch-ns ()
  (interactive)
  (cider-jack-in)
  (add-hook 'nrepl-connected-hook
    (lambda ()
      (cider-switch-to-last-clojure-buffer)
      (cider-repl-set-ns (cider-current-ns))
      (cider-switch-to-repl-buffer))))

;; clojure-mode
(defun customize-clojure-mode ()
  (paredit-mode 1)
  (local-set-key "\M-{" 'paredit-wrap-curly)
  (local-set-key "\M-}" 'paredit-close-curly-and-newline)
					;  (local-set-key "\M-[" 'paredit-wrap-square)
  (local-set-key "\M-]" 'paredit-close-square-and-newline)
  (define-key clojure-mode-map (kbd "C-c M-y") 'cider-ji-and-switch-ns)
  (put-clojure-indent 'for-all 1)
  (put-clojure-indent 'gen/ 1)
  (put-clojure-indent 'match 1)

  (setq cider-prompt-for-symbol nil)

  (defvar clojure-keyword-vars
    '("defn$" "defn'" "fna" "fnv" "fn'" "fn$"))

  ;; Font lock annotate keywords vars
  (font-lock-add-keywords 'clojure-mode
			  `((,(concat "(\\(?:\.*/\\)?"
				      (regexp-opt clojure-keyword-vars t)
				      "\\>")
			     1 font-lock-keyword-face)))

  ;; Function name support for defn$
  (font-lock-add-keywords 'clojure-mode
			  `((,(concat "(\\(?:[a-z\.-]+/\\)?\\(defn\\$\\)"
				      ;; Function declarations
				      "\\>"
				      ;; Any whitespace
				      "[ \r\n\t]*"
				      ;; Possibly type or metadata
				      "\\(?:#?^\\(?:{[^}]*}\\|\\sw+\\)[ \r\n\t]*\\)*"
				      "\\(\\sw+\\)?")
			     2 font-lock-function-name-face)))

  ;; Indentation
  (define-clojure-indent
    (fn$ 1)
    (fna 1)
    (fnv 1)
    (fn' 1)
    (valid 1)
    (invalid 1)
    (typecheck 1)))

(add-hook 'clojure-mode-hook 'customize-clojure-mode)
;;(add-hook 'clojure-mode-hook 'paredit-mode)
;(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.scss$" . css-mode))

;(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)

(add-hook 'python-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 2)
    (setq python-indent 2)))

(add-hook 'js-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq js-indent-level 2)))

(add-hook 'css-mode-hook
  (lambda ()
    (setq css-indent-offset 2)))

(add-hook 'html-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)))

(define-key evil-insert-state-map "j" #'cofi/maybe-exit)

(evil-define-command cofi/maybe-exit ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))

;(define-key input-decode-map "\e[1;5A" [C-up])
;(define-key input-decode-map "\e[1;5B" [C-down])
;(define-key input-decode-map "\e[1;5C" [C-right])
;(define-key input-decode-map "\e[1;5D" [C-left])

(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

;; org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-src-fontify-natively t)

;; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;; sql indent
(eval-after-load "sql"
  (load-library "sql-indent"))

;; Magit blame mode
(define-key global-map (kbd "C-c M-b") 'magit-blame)
