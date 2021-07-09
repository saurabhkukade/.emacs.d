(use-package ace-window
 :ensure t
 :init
 (progn
  (global-set-key [remap other-window] 'ace-window)
  (custom-set-faces
   '(aw-leading-char-face
	   ((t (:inherit ace-jump-face-foreground :height 3.0)))))
 ))

(electric-pair-mode)

(use-package auto-complete
 :ensure t
 :init
 (progn
  (ac-config-default)
  (global-auto-complete-mode t)
 ))

(defun make-backup-file-name (FILE)
 (let ((dirname (concat "~/.backups/emacs/"
		 (format-time-string "%y/%m/%d/"))))
  (if (not (file-exists-p dirname))
   (make-directory dirname t))
  (concat dirname (file-name-nondirectory FILE))))

(use-package drag-stuff
 :ensure t
 :config (drag-stuff-global-mode))

(use-package electric-operator
 :ensure t)

(setq evil-want-C-i-jump nil)
	(use-package evil
	 :ensure t
	 :config
	 (evil-mode))

(use-package flycheck
 :ensure t
 :init
 (global-flycheck-mode t))

(use-package yasnippet
 :ensure t
 :init
 (yas-global-mode 1))

;; 	    (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; 	    (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; 	    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;; 	    (custom-set-variables '(haskell-stylish-on-save t))
;; 	    (custom-set-variables '(haskell-tags-on-save t))
;;   ;;	  (add-hook 'haskell-mode-hook 'turn-on-haskell-unicode-input-method)

;;     ;; When you open a file called Foo.hs, it will auto-insert

;;     ;; -- |

;;     ;; module Foo where

;;     ;; And put your cursor in the comment section.
;;     ;;
;; 	    (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)



;;     ;;; In order to use it, invoke the haskell-compile command instead of compile as you would for the ordinary Compilation mode.
;;     ;;; It’s recommended to bind haskell-compile to a convenient key binding.
;;     ;;; For instance, you can add the following to your Emacs initialization to bind haskell-compile to C-c C-c

;;     (eval-after-load "haskell-mode"
;; 	'(define-key haskell-mode-map (kbd "C-c h c") 'haskell-compile))

;;     (eval-after-load "haskell-mode"
;; 	'(define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring))

;;     (eval-after-load "haskell-cabal"
;; 	'(define-key haskell-cabal-mode-map (kbd "C-c h c") 'haskell-compile))

;;     (eval-after-load "interactive-haskell-mode"
;; 	'((define-key interactive-haskell-mode-map (kbd "M-.") 'haskell-mode-goto-loc)
;; 	  (define-key interactive-haskell-mode-map (kbd "C-c C-t") 'haskell-mode-show-type-at)))

;;     (eval-after-load "interactive-haskell-mode"
;; 	'((define-key interactive-haskell-mode-map (kbd "M-.") 'haskell-mode-goto-loc)
;; 	  (define-key interactive-haskell-mode-map (kbd "C-c C-t") 'haskell-mode-show-type-at)
;; 	  (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
;; 	  (define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)))


;;   ;; Whenever GHC says something is not in scope, it will hoogle that symbol.
;;   ;; If there are results, it will prompt to add one of the modules from Hoogle’s results.
;;   ;; You need to make sure you’ve generated your Hoogle database properly.
;;    (custom-set-variables '(haskell-process-suggest-hoogle-imports t))



;;   ;; ;;(custom-set-variables
;;   ;; ;;  '(haskell-process-suggest-remove-import-lines t))


;; ;; OFF evil mode
;; (evil-set-initial-state 'haskell-interactive-mode 'emacs)

(global-hl-line-mode 1)
	(set-face-background 'hl-line "#3e4446")
	(set-face-foreground 'highlight nil)

(require 'erc)

(global-display-line-numbers-mode)
(setq linum-format "%3d" )

(use-package magit
 :ensure t)

(defun xah-open-file-at-cursor ()
 "Open the file path under cursor.
 Using given emacs function find-file-at-point but without prompt"
 (interactive)
 (let ((-path (if (use-region-p)
	       (buffer-substring-no-properties (region-beginning) (region-end))
	       (let (p0 p1 p2)
		(setq p0 (point))
		;; chars that are likely to be delimiters of full path, e.g. space, tabs, brakets.
		(skip-chars-backward "^  \"\t\n`'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\`")
		(setq p1 (point))
		(goto-char p0)
		(skip-chars-forward "^  \"\t\n`'|()[]{}<>〔〕“”〈〉《》【】〖〗«»‹›·。\\'")
		(setq p2 (point))
		(goto-char p0)
		(buffer-substring-no-properties p1 p2)))))
  (if (string-match-p "\\`https?://" -path)
   (browse-url -path)
   (progn ; not starting “http://”
    (if (string-match "^\\`\\(.+?\\):\\([0-9]+\\)\\'" -path)
     (progn
      (let (
	    (-fpath (match-string 1 -path))
	    (-line-num (string-to-number (match-string 2 -path))))
       (if (file-exists-p -fpath)
	(progn
	 (find-file -fpath)
	 (goto-char 1)
	 (forward-line (1- -line-num)))
	(progn
	 (when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" -fpath))
	  (find-file -fpath))))))
     (progn
      (if (file-exists-p -path)
       (find-file -path)
       (if (file-exists-p (concat -path ".el"))
	(find-file (concat -path ".el"))
	(when (y-or-n-p (format "file doesn't exist: 「%s」. Create?" -path))
	 (find-file -path ))))))))))

(use-package org
 :ensure t)

(use-package org-bullets
 :ensure t
 :config
 (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(defun load-emacs-org () (interactive) (find-file "~/.emacs.d/emacs.org"))
  (defun load-makefile () (interactive) (find-file "~/workspace/demo-blockchain-hs/Makefile"))
  (defun electric-modes ()
   (interactive)
   (electric-spacing-mode t)
   (electric-operator-mode t))

  (global-set-key (kbd "<f12>") 'evil-local-mode)
  (global-set-key (kbd "C-c f") 'xah-open-file-at-cursor) ;; open file under cursor
  (global-set-key (kbd "M-f") 'comint-dynamic-complete-filename) ;; complete file-path
  (global-set-key (kbd "C-c C-g") 'load-emacs-org)
  (global-set-key (kbd "C-x C-g") 'electric-modes)
  (global-set-key (kbd "C-+") 'text-scale-increase)
  (global-set-key (kbd "C--") 'text-scale-decrease)
  (global-set-key (kbd " C-c /") 'helm-find)

  (global-set-key (kbd "C-c m") 'magit) ;;magit
  (global-set-key (kbd "C-c a") 'org-agenda) ;;get agenda in org mode

  (global-set-key (kbd "C-S-v") 'yank)
;;  (eval-after-load 'haskell-mode (load-library "haskell-mode"))

  (use-package bind-key
   :ensure t)
  (bind-key "M-1" 'ispell-buffer)
  (bind-key "M-7" 'linum-mode)
  (bind-key "M-k" 'kill-this-buffer)
  (bind-key "M-w" 'delete-other-windows)
  (bind-key "M-g" 'google)
  (bind-key "M-j" 'join-line-or-lines-in-region)
  (bind-key "<M-up>" 'drag-stuff-up)
  (bind-key "M-`" 'other-window)
  (bind-key "<M-down>" 'drag-stuff-down)
  (bind-key "<M-down>" 'drag-stuff-down)
  (bind-key "C-x w" 'kill-buffer-and-window)
  (bind-key "M-[" 'previous-buffer)
  (bind-key "M-]" 'next-buffer)

(use-package saveplace
 :ensure t
 :init (save-place-mode))

(setq scroll-step 1)

(show-paren-mode t)

(use-package avy
 :ensure t
 :bind ("M-s" . avy-goto-char))

(use-package avy
 :ensure t
 :config
 (avy-setup-default))

;;     (setq custom-safe-themes t)
;;         (use-package darcula-theme
;;         :ensure t
;;         :config (load-theme 'darcula))

;;  (add-hook 'text-mode-hook
;;	     (lambda ()
;;	       (variable-pitch-mode 1)))

;;(set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 100)
;; (set-face-attribute 'fixed-pitch nil :family "DejaVu Sans Mono")
;;(set-face-attribute 'variable-pitch nil :family "IBM Plex Serif")

  ;; (add-to-list
  ;;   'default-frame-alist'(ns-transparent-titlebar . t))
  ;; (add-to-list
  ;;   'default-frame-alist'(ns-appearance . light))

  ;;    (setq custom-safe-themes t)
  ;; 	 (use-package poet-theme
  ;; 	 :ensure t
  ;; 	 :config (load-theme 'poet-dark))

(use-package try
 :ensure t)

(defalias 'yes-or-no-p 'y-or-n-p)

;; (set-frame-font "FiraCode 11")
 (set-frame-font "Inconsolata 14" nil t)
;; (set-frame-font "Fantasque Sans Mono-11" nil t)

(tool-bar-mode -1)

(display-time-mode 1)

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(use-package helm
   :diminish helm-mode
   :init
   (progn
     (require 'helm-config)
     (setq helm-candidate-number-limit 100)
     ;; From https://gist.github.com/antifuchs/9238468
     (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
	   helm-input-idle-delay 0.01  ; this actually updates things
					 ; reeeelatively quickly.
	   helm-yas-display-key-on-candidate t
	   helm-quick-update t
	   helm-M-x-requires-pattern nil
	   helm-ff-skip-boring-files t)
     (helm-mode))
   :bind (("C-c h" . helm-mini)
	  ("C-h a" . helm-apropos)
	  ("C-x C-b" . helm-buffers-list)
	  ("C-x b" . helm-buffers-list)
	  ("M-y" . helm-show-kill-ring)
	  ("M-x" . helm-M-x)
	  ("C-x C-f" . helm-find-files)
	  ("C-x c o" . helm-occur)
	  ("C-x c y" . helm-yas-complete)
	  ("C-x c Y" . helm-yas-create-snippet-on-region)
	  ("C-x c SPC" . helm-all-mark-rings)))
 (use-package helm-swoop
  :ensure t
  :bind (("C-s" . helm-swoop)))

'(helm-boring-buffer-regexp-list
  (quote
   ("\\` " "\\`\\*helm" "\\`\\*Echo Area" "\\`\\*Minibuf" "\\`\\*scratch" "\\`\\*Messages" "magit" "\\`\\*Flycheck" "TAGS")))

 (ido-mode -1) ;; Turn off ido mode in case I enabled it accidentally

 (setq helm-boring-buffer-regexp-list (list (rx "*org") (rx "*helm") (rx "*Echo Area") (rx "*Minibuf") (rx "*scratch") (rx "*Messages") (rx "*Flycheck") (rx "*")))


 (set-face-attribute 'helm-selection nil
                   :background "#3e4446"
                   :foreground "nil")

(use-package smart-mode-line
 :ensure t
 :init (smart-mode-line-enable))

(use-package rainbow-delimiters
 :ensure t
 :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package electric-operator
 :ensure t
 :config (add-hook 'prog-mode-hook #'electric-operator-mode))

;; auto save often
;; save every 20 characters typed (this is the minimum)
(setq auto-save-interval 20)

(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8-mac) ; For old Carbon emacs on OS X only
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system
  (if (eq system-type 'windows-nt)
      'utf-16-le  ;; https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows
    'utf-8))
(prefer-coding-system 'utf-8)

(use-package markdown-mode
  :ensure t)

(use-package ox-hugo
    :ensure t          ;Auto-install the package from Melpa (optional)
    :after ox)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package multiple-cursors
    :ensure t)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-visual-line-mode t)

(global-set-key (kbd "C-c c") 'org-capture)
  (setq org-default-notes-file "~/Dropbox/org-notebooks/capture.org")
  (setq org-directory "~/Dropbox/org-notebooks")

  ;; Setting org capture templates
  ;; (setq org-capture-templates
  ;;     '(("p" "Prompt us for input" entry
  ;;         (file+headline "demo.org" "Our first heading")
  ;; 	"* %^{Please write here} %?")

  ;;       ("d" "Demo Template" entry
  ;;         (file+headline "demo.org" "Our first heading")
  ;; 	"* Demo Text %?")

  ;;       ("o" "Option in prompt" entry
  ;;         (file+headline "demo.org" "Our first heading")
  ;; 	"* %^{Select your option|ONE|TWO|THREE}\n SCHEDULED: %^t\n Some more text %?")

  ;;       ;; Nested template
  ;;       ("a" "A random template")

  ;;       ("at" "Submenu option T" entry
  ;; 	  (file+headline "demo.org" "Our first heading")
  ;; 	  "* Demo Text %?")

  ;;       ("aa" "Submenu option a" entry
  ;; 	  (file+headline "demo.org" "Our first heading")
  ;; 	  "* Demo Text %?")))

 (setq org-capture-templates
     '(
	("t" "Task" entry
	    (file "tasks.org")
	  "* %^\n SCHEDULED: %^t\n Details %?")
	  ))


  (global-set-key (kbd "C-c b") (lambda() (interactive)(find-file "~/Dropbox/org-notebooks/hugo_blog_template.org")))
  (global-set-key (kbd "C-c d") (lambda() (interactive)(find-file "~/Dropbox/org-notebooks/")))
  (global-set-key (kbd "C-c o p") (lambda() (interactive)(find-file "~/Dropbox/org-notebooks/projects.org")))
  (global-set-key (kbd "C-c o t") (lambda() (interactive)(find-file "~/Dropbox/org-notebooks/tasks.org")))
  (global-set-key (kbd "C-c o m") (lambda() (interactive)(find-file "~/Dropbox/org-notebooks/misc.org")))


  (setq org-todo-keywords
  '((sequence "TODO"
      "STARTED"
      "|"
      "DONE"
      "CANCELLED")))



  (setq org-todo-keyword-faces
    '(("PROJ" :background "blue" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("TODO" :background "firebrick2" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("NEXT" :background "DarkOrchid1" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("STARTED" :background "goldenrod3" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
    ;;  ("WAITING" :background "yellow" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("QUERY" :background "cyan1" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("DEFERRED" :background "gold" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("DELEGATED" :background "gold" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("MAYBE" :background "gray" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("APPT" :background "red1" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("DONE" :background "medium sea green" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("CANCELLED" :background "lime green" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("ANALYSIS_COMPLETED" :background "light sky blue" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("IN_DEVELOPMENT" :background "firebrick2" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("NEXT" :background "DarkOrchid1" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("CODE_REVIEW" :background "goldenrod3" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("DEVELOPMENT_DONE" :background "medium sea green" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))
      ("CANCELLED" :background "gray" :foreground "black" :width semi-expanded :weight light :box (:line-width 2 :style released-button))))

(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%d %b %Y %a>" . "<%d %b %Y %a %H:%M>"))

(setq org-agenda-files (directory-files-recursively "~/Dropbox/org-notebooks" "\\.org$"))

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

(use-package org-download
    :ensure t
    :config (add-hook 'dired-mode-hook 'org-download-enable))
