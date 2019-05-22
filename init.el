;;; package --- Summary:
;;; Commentary:
;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)


;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "Orestis Markou"
      user-mail-address "orestis@orestis.gr")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst bozhidar-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p bozhidar-savefile-dir)
  (make-directory bozhidar-savefile-dir))

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(setq exec-path (append exec-path '("~/bin")))

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(setq-default cursor-type 'bar)


;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand) ;; uses super, but what is it?

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; align code in a pretty way
(global-set-key (kbd "C-x \\") #'align-regexp)

;; show help for emacs lisp command at point
(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(defun top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))

(global-set-key (kbd "C-S-j") 'top-join-line)

(require 'use-package)
(setq use-package-verbose t)

;; (use-package dracula-theme
;;   :ensure t
;;   :config
;;   (load-theme 'dracula t))

(use-package monokai-theme
  :ensure t
  :config
  (load-theme 'monokai t)
  (set-face-attribute 'region nil :background "#aa0" :foreground "#ffffff"))


;; highlight the current line
(global-hl-line-mode +1)

(use-package dimmer
  :ensure t
  :config
  (setq dimmer-fraction 0.25)
  (dimmer-mode))

(use-package idle-highlight-mode
  :ensure t)

(use-package neotree
  :ensure t)

;; (use-package ag
;;   :ensure t)

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package paredit
  :ensure t
  ;; :pin melpa-stable
  :config
  (define-key paredit-mode-map (kbd "C-,") 'paredit-forward-barf-sexp)
  (define-key paredit-mode-map (kbd "C-.") 'paredit-forward-slurp-sexp)

  ;;(add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  ;; enable in the *scratch* buffer
  ;;(add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  ;;(add-hook 'ielm-mode-hook #'paredit-mode)
  ;;(add-hook 'lisp-mode-hook #'paredit-mode)
  ;;(add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode)
  )


(use-package paren
  ;;:pin melpa-stable
  :config
  (show-paren-mode +1))

(use-package uniquify
  ;;:pin melpa-stable
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

(use-package dired
  ;;:pin melpa-stable
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package rainbow-delimiters
  ;;:pin melpa-stable
  :ensure t)

(use-package rainbow-mode
  ;;:pin melpa-stable
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))


;; highlight various different whitespace chars
(use-package whitespace
  ;;:pin melpa-stable
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-style '(face tabs empty trailing)))

(use-package clojure-mode
  ;;:pin melpa-stable
  :ensure t
  :config

  (setq clojure-toplevel-inside-comment-form t)

  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode))

(use-package flycheck-joker
  :ensure t)

;;(use-package flycheck-clojure
;;  :ensure t)

;; (use-package inf-clojure
;;   :ensure t)

(use-package cider
  :pin melpa-stable
  :ensure t
  :config

  ;; upon connect, don't show the repl window at all
  (setq cider-repl-pop-to-buffer-on-connect nil)

  ;; when doing interactive functions that need a symbol,
  ;; e.g. cider-doc, don't prompt for a symbol -- use the
  ;; one at point
  (setq cider-prompt-for-symbol nil)


  ;; when evaling the whole buffer, just save already
  (setq cider-save-file-on-load t)

  ;; syntax highlight inline/overlay buffer results
  (setq cider-overlays-use-font-lock t)

  ;; when doing "switch-to-repl" C-c C-z -- use the current window,
  ;; not a random one
  (setq cider-repl-display-in-current-window t)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode))

(use-package markdown-mode
  :pin melpa-stable
  :ensure t
  :config
  ;; TODO: Remove after https://github.com/jrblevin/markdown-mode/pull/335/files is merged
 ;;  (cl-delete-if (lambda (element) (equal (cdr element) 'markdown-mode)) auto-mode-alist)
  (add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode)))


;; some neat auto-complete popup mode
(use-package company
  :pin melpa-stable
  :ensure t
  :config
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))


;; highlight TODO comments
(use-package hl-todo
  :pin melpa-stable
  :ensure t
  :config
  (global-hl-todo-mode))

(use-package flyspell
  :pin melpa-stable
  :config
  (when (eq system-type 'windows-nt)
    (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/"))
  (setq ispell-program-name "aspell" ; use aspell instead of ispell
        ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
					;(add-hook 'prog-mode-hook #'flyspell-prog-mode)
  )

(use-package flycheck
  :pin melpa-stable
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))



(use-package flycheck-pos-tip
  :pin melpa-stable
  :ensure t
  :config
  (with-eval-after-load 'flycheck
    (flycheck-pos-tip-mode)))

;; save when windows lose focus
(use-package super-save
  :pin melpa-stable
  :ensure t
  :config
  ;; add integration with ace-window
  (add-to-list 'super-save-triggers 'ace-window)
  (super-save-mode +1))

(use-package which-key
  :pin melpa-stable
  :ensure t
  :config
  (which-key-mode +1))

;; HTML etc
(use-package web-mode
  :pin melpa-stable
  :ensure t)

(use-package projectile
  :pin melpa
  :ensure t
  :config
  (projectile-mode)
  (setq projectile-enable-caching t))


;; remember previously used M-x commands, show them first
(use-package smex
  :pin melpa-stable
  :ensure t
  :config
  (smex-initialize)
  (setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory)))


;; super nice suggestions/completion
(use-package ivy
  :pin melpa
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (ivy-mode 1))

;; super nice search
(use-package swiper
  :pin melpa
  :ensure t
  :config
  (global-set-key (kbd "C-s") 'swiper))

;; super nice other functionality (ivy/swiper/counsel trifecta)
(use-package counsel
  :pin melpa
  :ensure t
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "C-c k") 'counsel-ag))

(define-prefix-command 'fancy-find-map)
(global-set-key (kbd "M-p") 'fancy-find-map)

(use-package counsel-projectile
  :pin melpa
  :ensure t
  :config
  (define-key fancy-find-map (kbd "p") 'counsel-projectile)
  (define-key fancy-find-map (kbd "a") 'counsel-projectile-ag))

;; enter wgrep mode after searching with counsel-ag
;; edit the buffer then save -- all files are changed
(use-package wgrep
  :pin melpa-stable
  :ensure t)


(use-package deadgrep
  :pin melpa-stable
  :ensure t
  :config
  (define-key fancy-find-map (kbd "r") 'deadgrep))

;; pickup .editorconfig files
(use-package editorconfig
  :pin melpa-stable
  :ensure t
  :config
  (editorconfig-mode 1))


;; Bozhidars useful functions
(use-package crux
  :pin melpa-stable
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'crux-smart-open-line)
  (global-set-key (kbd "M-O") 'crux-smart-open-line-above)
  (crux-with-region-or-line kill-region) ;; c-w will kill all line if no region
  (crux-with-region-or-line kill-ring-save) ;; M-w/M-c will copy all line if no region
  )

;;(use-package magit
;;  :ensure t
;;)

(setq visible-bell 1)

(use-package js2-mode
  :pin melpa-stable
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
  ;;(define-key js2-mode-map (kbd "C-k") #'js2r-kill) ;; this looks broken
  )

;; this doesn't seem to do what it says on the tin
(use-package xref-js2
  :pin melpa-stable
  :ensure t
  :config
  (define-key js-mode-map (kbd "M-.") nil)
  (add-hook 'js2-mode-hook (lambda ()
                             (add-hook 'xref-backend-functions
                                       #'xref-js2-xref-backend nil t))))

(use-package yaml-mode
  :pin melpa-stable
  :ensure t)

(use-package nginx-mode
  :pin melpa-stable
  :ensure t)

(use-package graphql-mode
  :pin melpa
  :ensure t)
;;;; ----- custom defuns and commands

;;;; ----- custom defuns and commands

(setq js-indent-level 2)

(defun my-js-mode-hook ()
  "Custom `js-mode' behaviours."
  (setq indent-tabs-mode nil))

(add-hook 'js-mode-hook 'my-js-mode-hook)

;; macOS friendly copy-paste-cut keys
(global-set-key [(meta c)] 'kill-ring-save)
(global-set-key [(meta v)] 'yank)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; MY STUFF TO BE REPLACED
(setq icomplete-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "617341f1be9e584692e4f01821716a0b6326baaec1749e15d88f6cc11c288ec6" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(package-selected-packages
   (quote
    (spacemacs-theme material-theme leuven-theme parinfer-smart neotree idle-highlight-mode flycheck-joker graphql-mode dimmer sesman nginx-mode yaml-mode deadgrep flycheck-clojure xref-js2 js2-mode smex magit crux flycheck-pos-tip counsel-projectile projectile editorconfig wgrep counsel counsel-ag swiper ivy web-mode inf-clojure monokai-theme color-theme-sanityinc-tomorrow solarized-theme dracula-theme rainbow-delimiters zenburn-theme which-key use-package super-save rainbow-mode paredit markdown-mode hl-todo flycheck expand-region company cider ag))))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-doc-face ((t (:foreground "light green" :slant oblique)))))
