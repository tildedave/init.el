(load "~/.emacs.d/haskell-mode-2.8.0/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-to-list 'load-path "~/.emacs.d/")

;;(load-file "~/.emacs.d/hilit19.el")
;;(load-file "~/.emacs.d/coq.el")
;;(load-file "~/.emacs.d/coq-inferior.el")

;;(defvar coq-prog-name "coq-emacs.bat")
(load-file "~/.emacs.d/ProofGeneral-4.0pre100927/generic/proof-site.el")
;;(load-file "~/.emacs.d/js2.elc")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; (cond (window-system
;;       (setq hilit-mode-enable-list  '(not text-mode)
;;             hilit-background-mode   'light
;;             hilit-inhibit-hooks     nil
;;             hilit-inhibit-rebinding nil)
;;       (require 'hilit19)
;;       ))

;(global-set-key (kbd "<C-tab>") 'bury-buffer)
(global-set-key (kbd "<C-tab>") 'other-window)
;(global-set-key (kbd "<S-C-tab>") 'previous-buffer)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(setq savehist-file "~/.emacs.d/tmp/savehist")

(add-hook 'comint-output-filter-functions
    'shell-strip-ctrl-m nil t)
(add-hook 'comint-output-filter-functions
    'comint-watch-for-password-prompt nil t)
(setq explicit-shell-file-name "bash.exe")
;; For subprocesses invoked via the shell
;; (e.g., "shell -c command")

(load "~/.emacs.d/geiser/build/elisp/geiser-load")
(require 'geiser-install)
(setq geiser-scheme-dir "C:/cygwin/usr/local/share/geiser")

(setq shell-file-name explicit-shell-file-name)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(setq-default indent-tabs-mode nil)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
