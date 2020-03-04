;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;;; code:
(package-initialize)
;; Loading all emacs config from ~/.emacs.d/emacs.org
(org-babel-load-file  (expand-file-name "~/.emacs.d/emacs.org"))
(provide '.emacs)
;;; .emacs ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-stylish-on-save t)
 '(org-agenda-files
   (quote
    ("~/personal-org/personal.org" "~/personal-org/demo-blockchain.org" "~/personal-org/office_work.org")))
 '(package-selected-packages
   (quote
    (leuven-theme hindent which-key monokai-theme try counsel web-mode php-mode org-bullets magit iedit haskell-mode yasnippet jedi flycheck evil electric-operator drag-stuff auto-complete ace-window use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 89)) (:foreground "#333333" :background "#FFFFFF"))))
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
