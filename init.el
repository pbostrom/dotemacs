(desktop-save-mode 1)
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
	       '("melpa-stable" . "https://stable.melpa.org/packages/") t))

(defun load-melpa ()
  (interactive)
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
   "(do (require 'cljs.repl.node) (cemerick.piggieback/cljs-repl (cljs.repl.node/repl-env)))" t)
 '(custom-safe-themes
   (quote
    ("0b2e94037dbb1ff45cc3cd89a07901eeed93849524b574fa8daa79901b2bfdcf" default)))
 '(grep-find-ignored-directories
   (quote
    ("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules")))
 '(inhibit-startup-screen t)
 '(json-reformat:indent-width 2)
 '(magit-pull-arguments nil)
 '(magit-status-show-hashes-in-headers t)
 '(magit-tag-arguments (quote ("--annotate" "--sign")))
 '(ns-alternate-modifier (quote meta))
 '(ns-command-modifier (quote control))
 '(package-selected-packages
   (quote
    (rust-mode toml-mode go-mode nodejs-repl terraform-mode markdown-mode alchemist yaml-mode dockerfile-mode buffer-move inf-clojure dimmer sql-indent smex paredit multiple-cursors magit json-mode ido-vertical-mode haskell-mode groovy-mode evil cider)))
 '(sql-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-keyword-face ((t (:foreground "#de344c")))))

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
    '("defn$" "defn'" "fna" "fnv" "fn'" "fn$" "fn-traced" "pdoseq"))

  ;; Font lock annotate keywords vars
  (font-lock-add-keywords 'clojure-mode
			  `((,(concat "(\\(?:\.*/\\)?"
				      (regexp-opt clojure-keyword-vars t)
				      "\\>")
			     1 font-lock-keyword-face)))

  (dolist (c (string-to-list ":_-?!#*"))
      (modify-syntax-entry c "w" clojure-mode-syntax-table))

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
    (typecheck 1)
    (fn-traced 1)
    (pdoseq 1)))

(add-hook 'clojure-mode-hook 'customize-clojure-mode)
;;(add-hook 'clojure-mode-hook 'paredit-mode)
;(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.scss$" . css-mode))

;(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'paredit-mode)

(add-hook 'elixir-mode-hook
  (lambda ()
    (require 'elixir-format)
    (setq indent-tabs-mode nil)))

(add-hook 'python-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 4)
    (setq python-indent 4)))

(add-hook 'go-mode-hook
  (lambda ()
    (setq tab-width 2)))

(add-hook 'js-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq js-indent-level 2)))

(add-hook 'json-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq js-indent-level 2)))

(add-hook 'css-mode-hook
  (lambda ()
    (setq css-indent-offset 2)))

(add-hook 'html-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)))

(add-hook 'groovy-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)))

(add-hook 'sh-mode-hook
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq sh-basic-offset 2)
    (setq sh-indentation 2)))

(defun json4-indent ()
  (interactive)
  (setq js-indent-level 4))

(defun bash2-indent ()
  (interactive)
  (setq sh-basic-offset 2)
  (setq sh-indentation 2))

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

;; Cider w/ figwheel
(defun cider-figwheel-repl ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(require 'figwheel-sidecar.repl-api)
	     (figwheel-sidecar.repl-api/start-figwheel!) ; idempotent
	     (figwheel-sidecar.repl-api/cljs-repl)")
    (cider-repl-return)))

(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

(defun figwheel-repl ()
  (interactive)
  (inf-clojure-minor-mode)
  (inf-clojure "lein figwheel"))

(require 'dimmer)
(dimmer-activate)

(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(put 'upcase-region 'disabled nil)

;; nodejs repl
(require 'nodejs-repl)

(add-hook 'js-mode-hook
          (lambda ()
            (define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-expression)
            (define-key js-mode-map (kbd "C-c C-j") 'nodejs-repl-send-line)
            (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
            (define-key js-mode-map (kbd "C-c C-k") 'nodejs-repl-load-file)
            (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))

;; toml
(require 'toml-mode)

(setq require-final-newline t)
