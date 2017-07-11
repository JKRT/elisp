

;Make sure to recompile the essential emacs libraries.
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Mac/.") 0)


(tool-bar-mode 0)
(show-paren-mode t)
;turn of annoying sound
(setq ring-bell-function 'ignore)

;Load other configuration files
(load-file "./melpa.elc")
(load-file "./brackets.elc")
(load-file "./touchPad.elc")
(load-file "./otherSettings.elc")
(load-file "./swift.elc")
(load-file "./c++.elc")
(load-file "./themeChange.elc")


;Todo add code that initilizes the libraries that I use, if they are not installed



(package-initialize)
(elpy-enable)
