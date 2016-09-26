
;Some utility functions to enclose text in different brackets

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
  (insert-pair arg ?\[  ?\] ))


(defun insert-pointy-brackets (&optional arg)
    "Inserts pointy brackets arround  a piece of text"
  (interactive "P")
  (insert-pair arg ?\<  ?\> ))

