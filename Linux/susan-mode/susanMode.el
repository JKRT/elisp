;;Author: John Tinnerholm
(defconst susan-mode-version "1.0.0")
(defvar susan-font-lock-keywords nil
  "Keywords for Susan `font-lock-keywords'.")
(if susan-font-lock-keywords
    ()
  (setq susan-font-lock-keywords
	(list
	 (list (concat "\\<"
                       (regexp-opt
                        '("case" "match" "matchcontinue" "local" "template") t)
                       "\\>")
               0 'font-lock-keyword-face)
	 (list (concat "\\<"
                       (regexp-opt
                        '(
                          "public" "protected" "input" "output" "external"
                          "package" "record" "type"
                          "end" "uniontype" "import" "within" "extends"
                          "for" "while" "in" "loop" "when"
                          "if" "then" "else" "elseif" "elsewhen" "let" "list" "as" "|>" "=>") t) "\\>")
               0 'font-lock-type-face)
	 (list (concat "\\<"
                       (regexp-opt
                        '("assert" "terminate") t)
                       "\\>")
               0 'font-lock-warning-face)
	 (list (concat "\\<"
                       (regexp-opt
                        '("false" "true") t)
                       "\\>")
               0 
               (identity 'font-lock-constant-face)))))

(defvar susan-basic-offset 2
  "*basic offset for indentation in Susan Mode")

(defun susan-mode ()
  "Major mode for editing Susan files."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'susan-mode)
  (setq mode-name "Susan")
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(susan-font-lock-keywords nil nil))
  (setq tab-width susan-basic-offset)
  (setq tab-stop-list '(2)))
(provide 'susan-mode)
