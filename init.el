(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)
(setq inhibit-startup-message t) ;; get rid of startup screen
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))

(add-to-list
'default-frame-alist'(ns-transparent-titlebar . t))
(add-to-list
'default-frame-alist'(ns-appearance . light))

(setq custom-safe-themes t)
    (use-package poet-theme
    :ensure t
    :config (load-theme 'poet-dark))


(setq org-agenda-files (directory-files-recursively "~/Dropbox/org-notebooks" "\\.org$"))

;; Loading all emacs config from ~/.emacs.d/emacs.org
(org-babel-load-file  (expand-file-name "~/.emacs.d/emacs.org"))
;;
;;
;;            STATIC CONFIG ENDS HERE
;;
;;
