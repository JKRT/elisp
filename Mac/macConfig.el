

;Make sure to recompile the essential emacs libraries.
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Mac/.") 0)


(defun clocktime()
  (string-to-number
	   (car
	    (split-string (nth 3

			       (split-string (current-time-string) " ") )":"))) )

;Set color theme depending on the time of the day
(cond
 ((> 21 (clocktime)) (load-theme 'material t ))
 ((< 7 (clocktime)) (load-theme 'material t ))
 ((> 7 (clocktime)) (load-theme 'material-light t )))


(tool-bar-mode 0)
(show-paren-mode t)
;turn of annoying sound
(setq ring-bell-function 'ignore)

(load-file "./elisp/General/commands.elc")
(load-file "./elisp/Mac/melpa.elc")
(load-file "./elisp/Mac/brackets.elc")
(load-file "./elisp/Mac/touchPad.elc")
(load-file "./elisp/Mac/otherSettings.elc")
(load-file "./elisp/Mac/swift.elc")
(load-file "./elisp/Mac/c++.elc")




(package-initialize)
(elpy-enable)
