;If we have one .el file and that file does not have a corresponding elc file. Compile it anyway.
(setq-local EMACS-GENERAL (concat EMACS_HOME "General/"))
;;Byte recompile does not seem to work as it should on Windows.
(byte-recompile-directory (expand-file-name (concat EMACS-GENERAL "/.") 0))
;;If we have one .el file and that file does not have a corresponding elc file. Compile it anyway.
(defun byte-compile-file-if-el-but-no-elc (files)
  (dolist (filename files)
	  (if (and
	       (not (file-exists-p (replace-regexp-in-string (regexp-quote ".el") ".elc" filename)))
	       (not (string-match-p
		     (regexp-opt '("~"  "#"))
		     filename)))
	      (byte-compile-file filename))))
;;Force recompile iff we did not succeed before
;(byte-compile-file-if-el-but-no-elc (file-expand-wildcards "*.el"))
(load-file (concat EMACS-GENERAL "commands.elc"))
