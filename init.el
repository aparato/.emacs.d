;; I need loop!! Should look for a way to remove it
(require 'cl)

;; This windows thing. God!!
(setq-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(setq-default default-buffer-file-coding-system 'utf-8-unix)

;; Disable backups. I just hate the mess they make
(setq backup-inhibited t)
(setq auto-save-default nil)

;; hide splash screen
(setq inhibit-startup-message t)


;; Add more repos to package.el
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Define default packages for installation
(defvar axolote/packages '(
			   paredit
			   auto-complete
			   autopair
			   magit
			   smex
			   helm
			   helm-ls-git
               yasnippet
               emmet-mode
               web-mode
               org-pomodoro
               helm-ag
               color-theme-approximate
               color-theme-sanityinc-tomorrow)
  "Default packages")

;; Install packages if not already
(defun axolote/packages-installed-p ()
  (loop for pkg in axolote/packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)))

(unless (axolote/packages-installed-p)
  (message "%s" "Refreshing package DB...")
  (package-refresh-contents)
  (dolist (pkg axolote/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Load vendor directory
(defvar axolote/vendor-dir (expand-file-name "vendor" user-emacs-directory))
(add-to-list 'load-path axolote/vendor-dir)

(dolist (project (directory-files axolote/vendor-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Set the custom theme
(load-theme 'sanityinc-tomorrow-night t)

;; Delete selected text... as God intended
(delete-selection-mode t)
(transient-mark-mode t)

;; Font stuff
;; (set-face-attribute 'default nil :height 100)

;; (custom-set-variables '(linum-format (quote " %2d")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "90b5269aefee2c5f4029a6a039fb53803725af6f5c96036dee5dc029ff4dff60" "dc46381844ec8fcf9607a319aa6b442244d8c7a734a2625dac6a1f63e34bc4a6" "e26780280b5248eb9b2d02a237d9941956fc94972443b0f7aeec12b5c15db9f3" "91b5a381aa9b691429597c97ac56a300db02ca6c7285f24f6fe4ec1aa44a98c3" "29a4267a4ae1e8b06934fec2ee49472daebd45e1ee6a10d8ff747853f9a3e622" "d293542c9d4be8a9e9ec8afd6938c7304ac3d0d39110344908706614ed5861c9" default)))
 '(linum-format (quote dynamic))
 '(org-agenda-files nil))

;; Make stuff easier
(defalias 'yes-or-no-p 'y-or-n-p)

;; hide toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Proper line wrapping
(global-visual-line-mode t)

;; enable paredit useful buffers
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook  #'enable-paredit-mode)
(add-hook 'ielm-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)

;; Editing stuff
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Keybindings
(global-set-key (kbd "C-;") 'comment-or-uncomment-region) ;; self explanatory

;; Misc
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)
(show-paren-mode t)

;; SMEX
(setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; IDO
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

;; Column number mode
(setq column-number-mode t)

;; autopair
(require 'autopair)

;; autocomplete
(require 'auto-complete-config)
(ac-config-default)

;; configure helm
(require 'helm-config)
(require 'helm-ls-git)

(defun helm-mini ()
  "Additions to helm mini so that I can use .git as a project thing"
  (interactive)
  (require 'helm-files)
  (helm-other-buffer '(
		       helm-c-source-buffers-list
		       helm-c-source-recentf
		       helm-c-source-ls-git-status
		       helm-c-source-ls-git
		       helm-c-source-buffer-not-found)
		     "*helm mini"))

(global-set-key (kbd "C-c h") 'helm-mini)

;; Configure YASnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Smart beginning of line
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character"
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(global-set-key (kbd "C-a") 'smart-beginning-of-line)

;; To be honest... not having a newline on enter sucks
(define-key global-map (kbd "RET") 'newline-and-indent)

;; uniquify... which I kind of remember was already set...
(require 'uniquify)
(setq
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")

;; Activate Emmet mode on shit
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'html-mode 'emmet-mode)

;; Close matching stuff like braces
(autopair-global-mode)

;; LANGUAGE CONFIGURATIONS

;; PYTHON
   ;; Virtualenv settings
;; (require 'virtualenvwrapper)
;; (venv-initialize-interactive-shells)
;; (venv-initialize-eshell)
;; (setq venv-location "~/.virtualenvs/")

;; (defadvice venv-mkvirtualenv (after install-common-tools)
;;   "Install commonly used packages in venv"
;;   (shell-command "pip install jedi epc"))

    ;; Jedi completion
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:setup-keys t)
;; (setq jedi:complete-on-dot t)

;; HTML, JS, CSS
(require 'web-mode)
(setq web-mode-engines-alist
      '(("django" . "\\.html\\'"))
)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; Org-Mode and shit
; Bindings and stuff
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)



; Todo flow and stuff
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "white" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING" . t) ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))


;; Define the path to stuff depending on whether the editor is used in
;; windows or a *NIX environment
(setq org-base-path (expand-file-name "~/Box Sync/Documents/journal/"))
(when (eq system-type 'windows-nt)
  (setq org-base-path "C:/Users/Mario/Box Sync/Documents/journal/"))

; Default notes file
(setq org-default-notes-file (format "%s/%s" org-base-path "notes.org"))

;; This is so that it works with the android app
(setq org-mobile-directory (format "%s/%s" org-base-path "mobile"))
(setq org-directory org-base-path)

; Agenda stuff
;;(setq org-agenda-files (quote ((format "%s" org-base-path))))
(setq org-agenda-files (list org-base-path (format "%s/%s" org-base-path "clients")))
(setq org-mobile-files (list org-base-path (format "%s/%s" org-base-path "clients")))

(setq org-mobile-inbox-for-pull (format "%s/%s/%s" org-base-path "inbox" "inbox.org"))

; Org capture templates
(setq org-capture-templates
      (quote (("t" "todo" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree (format "%s/%s" org-base-path "diary.org"))
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file (format "%s/%s" org-base-path "refile.org"))
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

; Habit tracking
(setq org-log-repeat "time")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
(put 'dired-find-alternate-file 'disabled nil)
