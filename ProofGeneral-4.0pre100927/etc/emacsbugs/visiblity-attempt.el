(defvar vis nil)
(defun toggle-invis ()
  (interactive)
  (if vis (add-to-invisibility-spec 'myvis . t))
    (remove-from-invisibility-spec '(myvis . t)))
  (setq vis (not vis)))
(overlay-put (make-overlay (point-min) (point)) 'invisible 'myvis)(defvar vis nil)
(defun toggle-invis ()
  (interactive)
  (if vis (add-to-invisibility-spec '(myvis . t))
    (remove-from-invisibility-spec '(myvis . t)))
  (setq vis (not vis)))
(overlay-put (make-overlay (point-min) (point)) 'invisible 'myvis)

