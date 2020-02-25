(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
        '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(setq inhibit-startup-message t) ;; get rid of startup screen
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

(setq org-agenda-files (list "~/personal-org"))

(defun bjm/align-whitespace (start end)
  "Align columns by whitespace"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)\\s-" 1 0 t))

(defun bjm/align-& (start end)
  "Align columns by ampersand"
  (interactive "r")
  (align-regexp start end
                "\\(\\s-*\\)&" 1 1 t))

(electric-pair-mode)

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

(global-set-key (kbd "C-.") 'other-window)
(global-set-key (kbd "C-,") 'prev-window)

(defun prev-window ()
  (interactive)
  (other-window -1))

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

(use-package jedi
:ensure t
:init
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup))


(use-package yasnippet
:ensure t
:init
(yas-global-mode 1))

(eval-after-load 'haskell 
                  '(lambda () (local-set-key (kbd "M 1") #'haskell-mode-show-type-at)))
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(custom-set-variables '(haskell-stylish-on-save t))

(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight nil)

(use-package iedit
:ensure t)

(defun iedit-dwim (arg)
"Starts iedit but uses \\[narrow-to-defun] to limit its scope."
(interactive "P")
(if arg
    (iedit-mode)
    (save-excursion
    (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
        ;; `current-word' can of course be replaced by other
        ;; functions.
        (narrow-to-defun)
        (iedit-start (current-word) (point-min) (point-max)))))))



(global-set-key (kbd "C-;") 'iedit-dwim)

(require 'erc)

(global-linum-mode t)
(setq linum-format "%2d \u2502")

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

(setq org-todo-keyword-faces
      '(
        ("WORKING" . (:foreground "blue" :weight bold))
        ("IF-TIME" . (:foreground "yellow" :weight bold))
        ("NOT-REPRO" . (:foreground "purple" :weight bold))
        ))

(defun load-emacs-org () (interactive) (find-file "~/.emacs.d/emacs.org"))
(defun electric-modes ()
    (interactive)
    (electric-spacing-mode t)
    (electric-operator-mode t))
(global-set-key (kbd "C-c a") 'org-agenda) ;;get agenda in org mode
(global-set-key (kbd "C-c f") 'xah-open-file-at-cursor) ;; open file under cursor
(global-set-key (kbd "M-f") 'comint-dynamic-complete-filename) ;; complete file-path
(global-set-key (kbd "C-c C-g") 'load-emacs-org)
(global-set-key (kbd "C-x C-g") 'electric-modes) 
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c o") (lambda() (interactive)(find-file "~/personal-org/")))
(global-set-key (kbd "C-S-p") 'yank)

(use-package bind-key
    :ensure t)
(bind-key "M-7" 'linum-mode)
(bind-key "M-k" 'kill-this-buffer)
(bind-key "M-1" 'delete-other-windows)
(bind-key "M-g" 'google)
(bind-key "C-c n" 'clean-up-buffer-or-region)
(bind-key "C-c s" 'swap_windows)
(bind-key "M-j" 'join-line-or-lines-in-region)
(bind-key "<M-up>" 'drag-stuff-up)
(bind-key "M-`" 'other-window)
(bind-key "<M-down>" 'drag-stuff-down)
(bind-key "<M-left>" 'next-buffer)
(bind-key "<M-right>" 'previous-buffer)

(use-package saveplace
:ensure t
:init (save-place-mode))

(setq scroll-step 1)

(show-paren-mode t)

(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char))

(use-package avy
  :ensure t
  :config
  (avy-setup-default))

(setq custom-safe-themes t)

(use-package leuven-theme
:ensure t
:config (load-theme 'leuven))

(use-package try
:ensure t)

(use-package which-key
:ensure t
:config
(which-key-mode))

(use-package projectile
:ensure t
:config
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'default-frame-alist
             '(font . "Fantasque Sans Mono-11"))

(set-frame-font "Fantasque Sans Mono-11" nil t)

(tool-bar-mode -1)
