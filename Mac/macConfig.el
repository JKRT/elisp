

;Make sure to recompile the essential emacs libraries.
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Mac/.") 0)


(defun clocktime()
  ;Extract the hour from the current time
  (string-to-number
	   (car
	    (split-string (nth 3
			       (split-string (current-time-string) " ") )":"))) )
(tool-bar-mode 0)
(show-paren-mode t)
;turn of annoying sound
(setq ring-bell-function 'ignore)

;Load other configuration files
(load-file "./elisp/General/commands.elc")
(load-file "./elisp/Mac/melpa.elc")
(load-file "./elisp/Mac/brackets.elc")
(load-file "./elisp/Mac/touchPad.elc")
(load-file "./elisp/Mac/otherSettings.elc")
(load-file "./elisp/Mac/swift.elc")
(load-file "./elisp/Mac/c++.elc")
(load-file "./elisp/Mac/themeChange.elc"


;Todo add code that initilizes the libraries that I use, if they are not installed



(package-initialize)
(elpy-enable)
