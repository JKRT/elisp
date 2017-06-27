



(if ( > 21 (string-to-number
	    (car
	     (split-string (nth 3
				(split-string (current-time-string) " ") )":"))))
					;if bedtime use a darker theme
    (load-theme 'material t )
  
					;Else sunshine and rainbows
  (load-theme 'material-light t))


(load-file "./elisp/General/commands.elc")
(load-file "./elisp/Mac/melpa.elc")
(load-file "./elisp/Mac/brackets.elc")
(load-file "./elisp/Mac/touchPad.elc")
(load-file "./elisp/Mac/otherSettings.elc)
(load-file "./elisp/Mac/swift.elc")
(load-file "./elisp/Mac/c++.elc")
