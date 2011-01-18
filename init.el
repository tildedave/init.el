;; Basic setup
(setq my-emacsd (file-name-as-directory "~/.emacs.d"))
(setq my-site-lisp my-emacsd)
(add-to-list 'load-path my-site-lisp)

;; Which language modes get loaded
(setq use-haskell t)
(setq use-geiser t)
(setq use-proofgeneral t)
(setq use-js2 t)
(setq use-yaml t)

;; Essential keybindings
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key "\C-f" 'scroll-down)
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
                (setq geiser-scheme-dir "C:/cygwin/usr/local/share/geiser")))
        (warn "Unable to load geiser-mode"))))

;; JS2/Yaml -- These should be in the load path

(if use-js2
    (progn
      (autoload 'js2-mode "js2" nil t)
      (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))))

(if use-yaml
    (progn 
      (require 'yaml-mode)
      (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))))


;; QUALITY OF LIFE SETTINGS

;; savehist mode
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(setq savehist-file (concat (file-name-as-directory (concat my-emacsd "tmp")) "savehist"))

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

