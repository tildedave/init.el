;; Basic setup
(setq my-emacsd (file-name-as-directory "~/.emacs.d"))
(setq my-site-lisp my-emacsd)
(add-to-list 'load-path my-site-lisp)

;; By default, all language modes get loaded
(setq use-geiser t)
(setq use-proofgeneral t)
(setq use-tuareg t)
(setq use-python-pep8 t)
(setq use-python-pylint t)

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

;; ELPA/Marmalade
(load-file "~/.emacs.d/elpa/package.el")
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(when (> emacs-major-version 23)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/")
               'APPEND))

(package-initialize)

;; Directory Conversion Functions

(defun list-to-directory (list)
  (let (value)
    (dolist (element list value)
      (setq value (file-name-as-directory (concat value element))))))

(defun path-to-file (list filename)
  (concat (list-to-directory list) filename))

;; LANGUAGE SPECIFIC MODES

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

(if use-tuareg
    (progn
      (load-file
       (path-to-file (list my-site-lisp "tuareg-2.0.4") "tuareg.el"))
      (add-to-list 'auto-mode-alist '("\\.ml$" . tuareg-mode))))

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

(if use-icicles
    (progn
      (require 'icicles)
      (setq icicle-apropos-complete-keys '([tab]))
      (setq icicle-prefix-complete-keys '([S-tab]))
      (icy-mode)))

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

;; QUALITY OF LIFE SETTINGS

;; savehist mode
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(setq savehist-file (concat (file-name-as-directory (concat my-emacsd "tmp")) "savehist"))

;; big ol' windows hacks
(if is-windows
    (progn
      (require 'cygwin-mount)
      (cygwin-mount-activate)
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

;; Find file in project
(require 'project-local-variables)
(require 'find-file-in-repository)
(global-set-key (kbd "C-x C-r") 'find-file-in-repository)

;; Useful Commands

(defun spawn-shell ()
  "Invoke shell test"
  (interactive)
  (let* ((original-window (selected-window))
         (command (read-from-minibuffer "Shell command to execute: "))
         (buffer-name (concat "*" command "*")))
    (progn
      (if (get-buffer buffer-name)
          (kill-buffer buffer-name))
      (let ((spawn-buffer (generate-new-buffer buffer-name)))
        (progn
          (shell spawn-buffer)
          (process-send-string nil (concat command "\n"))
          (select-window original-window))))))

(global-set-key "\M-@" 'spawn-shell)

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

(server-start)


(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (require 'espresso)
  (setq espresso-indent-level 2
        indent-tabs-mode nil
        c-basic-offset 8)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'before-save-hook 'my-delete-trailing-blank-lines)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)]
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
  (if (featurep 'js2-highlight-vars)
      (js2-highlight-vars-mode))
  (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; Ctrl X-Ctrl S button dangerously close to Ctrl X-Ctrl C
(setq confirm-kill-emacs 'yes-or-no-p)

;; Whitespace arguments are stupid
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; death to blinking cursor
(blink-cursor-mode -1)

(defun my-delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))

;; Convert JSUnit tests into Jasmine tests, kind of
(fset 'convert-test-to-spec
   [?\C-s ?f ?u ?n ?\M-b ?i ?t ?\( ?\C-  ?\M-f ?\M-f ?\M-b ?\C-w ?\" ?\M-f ?\" ?, ?  S-insert backspace ?\C-e left ?\C-\M-n ?\) ?\; ?\C-\M-p ?\C-a ?\C-\M-n ?\C-a down down])
