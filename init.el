;; -*- lexical-binding: t; -*-

(set-face-attribute
 'default nil
 :height 90
 :font "JuliaMono"
 :weight 'regular)
(set-face-attribute
 'fixed-pitch nil
 :height 90
 :font "JuliaMono"
 :weight 'regular)
(set-face-attribute
 'variable-pitch nil
 :height 105
 :font "Libre Baskerville")

;; important
(use-package general
  :demand
  :init
  (general-create-definer dog/leader
    :prefix "C-c")
  :straight t)

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))))
  :straight t)
(use-package ctrlf
  :init
  (ctrlf-mode)
  :straight t)
(use-package consult
  :init
  (advice-add #'completing-read-multiple
              :override #'consult-completing-read-multiple)
  :straight t)
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-quit-no-match t)
  :init
  (corfu-global-mode)
  :straight t)
(straight-use-package '(vertico :files (:defaults "extensions/*")))
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-count 6))
(use-package vertico-flat
  :after vertico
  :init
  (setq vertico-flat-format
        '(:left #("{" 0 1 (face minibuffer-prompt))
          :separator #(" | " 0 3 (face shadow))
          :right #("}" 0 1 (face minibuffer-prompt))
          :ellipsis #("…" 0 1 (face shadow))
          :no-match "[No match]")))
(use-package vertico-grid
  :custom
  (vertico-grid-separator "   ")
  :after vertico)
(use-package vertico-multiform
  :after vertico vertico-flat vertico-grid
  :init
  (vertico-multiform-mode)
  (setq vertico-multiform-command-modes
    '((execute-extended-command flat)))
  (setq vertico-multiform-category-modes
        '((file grid))))
(use-package which-key
  :init
  (setq max-mini-window-height 5)
  (which-key-setup-minibuffer)
  (which-key-mode)
  :straight t)

(use-package org
  :preface
  (defun +dog/org-mode ()
    (visual-line-mode)
    (variable-pitch-mode))
  :hook
  (org-mode . +dog/org-mode)
  :init
  (setq org-directory (expand-file-name "~/Documents/"))
  :straight t)
(use-package org-roam
  :init
  (setq org-roam-directory (file-name-concat org-directory "Zettelkasten" "Notes")
        org-roam-completion-everywhere t)
  (dog/leader
    "n f" #'org-roam-node-find
    "n r" #'org-roam-node-random)
  (dog/leader
    :keymaps 'org-mode-map
    "n i" #'org-roam-node-insert
    "n o" #'org-id-get-create
    "n t" #'org-roam-tag-add
    "n a" #'org-roam-alias-add
    "n l" #'org-roam-buffer-toggle)
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.33)
                 (window-height . fit-window-to-buffer)))
  :config
  (org-roam-setup)
  :straight t)
(use-package org-roam-ui
  :after org-roam
  :init
  (setq org-roam-ui-sync-theme nil
        org-roam-ui-follow nil
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t)
  :straight t)

;; theme!
(use-package modus-themes
  :demand
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-links '(background neutral-underline)
        modus-themes-prompts '(background)
        modus-themes-mode-line '(accented)
        modus-themes-completions 'opinionated
        modus-themes-lang-checkers '(straight-underline background faint)
        modus-themes-hl-line '(accented)
        modus-themes-subtle-line-numbers t
        modus-themes-mixed-fonts t
        modus-themes-intense-markup t
        modus-themes-paren-match '(bold underline)
        modus-themes-region '(accented)
        modus-themes-headings '((1 . (background overline 1.3))
                                (2 . (background overline 1.2))
                                (3 . (background overline))
                                (t . (background overline))))
  :config
  (modus-themes-load-themes)
  (modus-themes-load-operandi)
  :straight t)

(use-package emacs
  :preface
  (defun +dog/prog-mode ()
    (hl-line-mode)
    (display-line-numbers-mode)
    (show-paren-local-mode)
    (electric-pair-local-mode))
  :init
  (setq inhibit-startup-screen t)
  (blink-cursor-mode 0)
  (setq-default cursor-type 'bar)
  (setq-default c-basic-offset 4
                indent-tabs-mode nil
                tab-width 4)
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8-unix)
  (setq make-backup-files nil
        backup-by-copying t
        create-lockfiles nil
        auto-save-default nil)
  (global-auto-revert-mode 1)
  (setq enable-recursive-minibuffers t)
  (customize-set-variable
   'minibuffer-prompt-properties
   (quote (read-only t cursor-intangible t face minibuffer-prompt)))
  (delete-selection-mode 1)
  (defalias 'yes-or-no-p #'y-or-n-p)
  :hook (prog-mode . +dog/prog-mode))
