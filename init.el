(setq inhibit-startup-message t)
(setq custom-file (concat user-emacs-directory "custom.el")) ; Get Custom to go away

(scroll-bar-mode -1)    ; Disable visual scrollbar
(tool-bar-mode -1)      ; Disable toolbar
(tooltip-mode -1)       ; Disable tooltips
(set-fringe-mode 10)    ; Give breathing room

(menu-bar-mode -1)

(setq visible-bell t)   ; Visible bell, no sound


;; Line numbers
(global-display-line-numbers-mode t)

;;Disable for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Setup package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa". "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Turn off minor mode on mode bar
(use-package diminish)

;; Fuzzy Search
(use-package swiper)


;; Completion framework
(use-package ivy
  :diminish
  :bind (("C-s" . swiper))
  :config
  (ivy-mode 1))

;; Information for ivy
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Untility package for ivy
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-M-j" . counsel-switch-buffer)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c j" . counsel-git-grep)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; For suggesting completions for chords
(use-package which-key
  :init (which-key-mode)
  :diminish
  :config
  (which-key-setup-side-window-right-bottom)
  (setq which-key-show-early-on-C-h t))


;; Colours for LISP likes
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package compat)
(use-package magit)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-monokai-spectrum t))

;; Keybinding
(use-package general
  :config
  (general-create-definer theAntiYeti/leader-keys
			  :prefix "C-#")
  (theAntiYeti/leader-keys
    "t" '(:ignore t :which-key "toggles")))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "done" :exit t))

(theAntiYeti/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))


(use-package projectile
  :diminish
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package forge)

;; LSP

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . lsp-deferred))

(use-package go-mode
  :hook ((go-mode . lsp-deferred)))

(use-package go-projectile
  :diminish
  :config
  (go-projectile-tools-add-path)
  :custom
  (go-projectile-tools '((gocode    . "github.com/mdempsky/gocode")
			 (golint    . "golang.org/x/lint/golint")
			 (godef     . "github.com/rogpeppe/godef")
			 (errcheck  . "github.com/kisielk/errcheck")
			 (godoc     . "golang.org/x/tools/cmd/godoc")
			 (gogetdoc  . "github.com/zmb3/gogetdoc")
			 (goimports . "golang.org/x/tools/cmd/goimports")
			 (gorename  . "golang.org/x/tools/cmd/gorename")
			 (gomvpkg   . "golang.org/x/tools/cmd/gomvpkg")
			 (guru      . "golang.org/x/tools/cmd/guru"))))

(use-package gotest)

;; Org-mode

(use-package org
  :config
  (org-babel-do-load-languages 'org-babel-load-languages
			       '((python . t)))
  (setq org-babel-python-command "python3")
  (setq org-ellipsis " ▾"))


(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 125
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
