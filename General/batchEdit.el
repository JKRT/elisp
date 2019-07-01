                                        ;Replaces several strings in batches

;; Thanks to Trey Jackson for the first two functions :)

(defun batch-replace-strings (replacement-alist)
  "Prompt user for pairs of strings to search/replace, then do so in the current buffer"
  (interactive (list (batch-replace-strings-prompt)))
  (dolist (pair replacement-alist)
    (save-excursion
      (replace-string (car pair) (cdr pair)))))

(defun batch-replace-strings-prompt ()
  "prompt for string pairs and return as an association list"
  (let (from-string
        ret-alist)
    (while (not (string-equal "" (setq from-string (read-string "String to search (RET to stop): "))))
      (setq ret-alist
            (cons (cons from-string (read-string (format "Replace %s with: " from-string)))
                  ret-alist)))
    ret-alist))
