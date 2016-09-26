;But all backup files in the temp dir.
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

(defun kill-all-buffers()
  "Kill all open buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))


(defun insert-double-quotes (&optional arg)
    "Inserts double quotes arround a piece of text"
  (interactive "P")
  (insert-pair arg ?\"  ?\" ))


(defun insert-single-quotes (&optional arg)
    "Inserts single quotes arround a piece of text"
  (interactive "P")
  (insert-pair arg ?\'  ?\' ))


(defun insert-braces (&optional arg)
    "Inserts braces arround a piece of text"
  (interactive "P")
  (insert-pair arg ?\{  ?\} ))

(defun insert-square-brackets (&optional arg)
    "Inserts braces arround a piece of text"
  (interactive "P")
  (insert-pair arg ?\{  ?\} ))


(defun insert-pointy-brackets (&optional arg)
    "Inserts pointy brackets arround  a piece of text"
  (interactive "P")
  (insert-pair arg ?\<  ?\> ))








