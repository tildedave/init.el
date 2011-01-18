(setq geiser-elisp-dir (file-name-directory load-file-name))
(add-to-list 'load-path geiser-elisp-dir)

(require 'geiser)

(setq geiser-scheme-dir "/cygdrive/c/emacs/.emacs.d/geiser/build/../scheme")

(provide 'geiser-load)
