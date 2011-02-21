;; Basic setup
(setq my-emacsd (file-name-as-directory "~/.emacs.d"))
(setq my-site-lisp my-emacsd)
(add-to-list 'load-path my-site-lisp)

;; By default, all language modes get loaded
(setq use-haskell t)
(setq use-geiser t)
(setq use-proofgeneral t)
(setq use-js2 t)
(setq use-yaml t)
(setq use-nxml t)
(setq use-php t)
(setq use-tidy t)
(setq use-python-pep8 t)
(setq use-python-pylint t)
(setq use-inf-ruby t)
(setq use-rails-reloaded t)
(setq use-feature-mode t)

;; Which other packages get loaded
(setq use-yasnippet t)
(setq use-autocomplete t)
(setq use-icicles t)

;; Essential keybindings
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key "\C-f" 'scroll-down)
(global-set-key "\C-v" 'scroll-up)
(global-set-key "\M-\C-f" 'scroll-other-window-down)
(global-set-key "\M-\C-v" 'scroll-other-window)
(global-set-key "\M-g" 'goto-line)

;; Check if we are on my Windows 7 box
(setq is-windows (string= system-type "windows-nt"))

;; Directory Conversion Functions

(defun list-to-directory (list)
  (let (value)
    (dolist (element list value)
      (setq value (file-name-as-directory (concat value element))))))

(defun path-to-file (list filename) 
  (concat (list-to-directory list) filename))

;; LANGUAGE SPECIFIC MODES 

;; Haskell

(if use-haskell
    (let
        ((haskell-site-file
          (path-to-file (list my-site-lisp "haskell-mode-2.8.0") "haskell-site-file.el")))
      (if (file-exists-p haskell-site-file)
          (progn
            (load haskell-site-file)
            (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
            (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
            (add-hook 'haskell-mode-hook 'font-lock-mode))
        (warn "Error loading Haskell mode -- could not find site file"))))

;; Coq/Proof General

(if use-proofgeneral
    (let ((proofgeneral-site-file
           (path-to-file (list my-emacsd "ProofGeneral-4.0pre100927" "generic") "proof-site.el")))
      (if (file-exists-p proofgeneral-site-file)
          (load-file proofgeneral-site-file)
        (warn "Error loading Proof General mode -- could not find site file"))))

;; Geiser Mode
(if use-geiser
    (let 
        ((geiser-load-file 
          (path-to-file (list my-site-lisp "geiser" "build" "elisp") "geiser-load.elc"))
         )
      (if (file-exists-p geiser-load-file)
          (progn
            (load geiser-load-file)
            (require 'geiser-install)
            (if is-windows
                (setq geiser-scheme-dir "C:/cygwin/usr/local/share/geiser"))
            (add-to-list 'auto-mode-alist '("\.rkt" . scheme-mode)))
        (warn "Unable to load geiser-mode"))))

;; JS2/Yaml -- These should be in the load path

(if use-js2
    (progn
      (autoload 'js2-mode "js2" nil t)
      (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
      (add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))))

(if use-yaml
    (progn 
      (require 'yaml-mode)
      (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))))

(if use-nxml
    (progn
      (add-to-list 'load-path (path-to-file (list my-site-lisp "nxml-mode-20041004") "rng-auto.el"))))

(if use-tidy
    (require 'tidy))

;; Python

(if use-python-pep8
    (progn
      (require 'compile)
      (require 'python-pep8)))
      
(if use-python-pylint
    (progn
      (require 'python-pylint)
      (autoload 'python-pylint "python-pylint")
      (autoload 'pylint "python-pylint")))

;; PHP

(if use-php
    (progn
      (autoload 'php-mode "php-mode" nil t)
      (add-to-list 'auto-mode-alist '("\\.php" . php-mode))))

;; Ruby

(if use-inf-ruby
    (progn
      (add-to-list 'auto-mode-alist '("\\.rake" . ruby-mode))
      (require 'inf-ruby)))

;; Cucumber

(if use-feature-mode
    (let ((feature-mode-directory (list-to-directory (list my-site-lisp "feature-mode"))))
      (if (file-exists-p feature-mode-directory)
          (progn
            (add-to-list 'load-path feature-mode-directory)
            (add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))
            (setq feature-default-language "fi")
            (require 'feature-mode))
        (warn "Could not load feature mode"))))

(if use-rails-reloaded
    (let*
        ((rails-reloaded-path (list-to-directory (list my-site-lisp "rails-reloaded"))))
      (progn
        (add-to-list 'load-path rails-reloaded-path)
        (require 'rails-autoload))))

;; OTHER MODULES (yasnippet, autocomplete, etc)

(if use-yasnippet
    (let* 
        ((yasnippet-load-directory
          (list-to-directory (list my-site-lisp "plugins" "yasnippet-0.6.1c")))
	 (yasnippet-bundle
	  (list-to-directory (list yasnippet-load-directory "snippets")))
         )
      (if (and (file-exists-p yasnippet-load-directory)
	       (file-exists-p yasnippet-bundle))
	  (progn
	    (add-to-list 'load-path yasnippet-load-directory)
	    (require 'yasnippet) ;; not yasnippet-bundle
	    (yas/initialize)
	    (yas/load-directory yasnippet-bundle))
	(warn "Error loading yasnippet"))))

(if use-autocomplete
    (progn 
      (require 'auto-complete-config)
      (add-to-list 'ac-dictionary-directories (list-to-directory (list my-emacsd "ac-dist")))
      (ac-config-default)
      (define-globalized-minor-mode real-global-auto-complete-mode
        auto-complete-mode (lambda ()
                             (if (not (or (minibufferp (current-buffer))
                                          (search "shell" (buffer-name (current-buffer)))))
                                 (auto-complete-mode 1))
                             ))
      (real-global-auto-complete-mode t)))

(if use-icicles
      (let 
          ((icicle-path (list-to-directory (list my-site-lisp "icicles"))))
        (progn
          (add-to-list 'load-path icicle-path)
          (require 'icicles)
          (icy-mode 1))))


;; QUALITY OF LIFE SETTINGS

;; savehist mode
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(setq savehist-file (concat (file-name-as-directory (concat my-emacsd "tmp")) "savehist"))

;; big ol' windows hacks
(if is-windows 
    (progn 
      (add-hook 'comint-output-filter-functions
                'shell-strip-ctrl-m nil t)
      (add-hook 'comint-output-filter-functions
                'comint-watch-for-password-prompt nil t)
      (setq explicit-shell-file-name "bash.exe")
      (setq shell-file-name explicit-shell-file-name)))
  
;; Shell coloring
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; No tabs
(setq-default indent-tabs-mode nil)

;; Remove toolbar
(tool-bar-mode -1)

;; Kill shells without asking
(add-hook 
 'shell-mode-hook 
 (lambda () 
   (set-process-query-on-exit-flag (get-buffer-process 
                                   (current-buffer)) 
                                 nil))) 


;; AUTOMATICALLY SET VARIABLES/FACES

(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t))

(if (not is-windows)
    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(default ((t (
                :inherit nil :stipple nil :background "white" :foreground "black" 
                :inverse-video nil :box nil :strike-through nil :overline nil
                :underline nil :slant normal :weight normal :height 109
                :width normal :foundry "unknown" :family "DejaVu Sans Mono"
                ))))))
