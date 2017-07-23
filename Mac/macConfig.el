

;Make sure to recompile the essential emacs libraries.
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Mac/.") 0)


(tool-bar-mode 0)
(show-paren-mode t)
;turn of annoying sound when switching between buffers using touchpad.el
(setq ring-bell-function 'ignore)

					;Load other configuration files

(load-file "~/.emacs.d/elisp/Mac/melpa.elc")
(load-file "~/.emacs.d/elisp/Mac/brackets.elc")
(load-file "~/.emacs.d/elisp/Mac/touchPad.elc")
(load-file "~/.emacs.d/elisp/Mac/otherSettings.elc")
(load-file "~/.emacs.d/elisp/Mac/swift.elc")
(load-file "~/.emacs.d/elisp/Mac/c++.elc")
(load-file "~/.emacs.d/elisp/Mac/themeChange.elc")


;Todo add code that initilizes the libraries that I use, if they are not installed
(package-initialize)
(elpy-enable)
					;Some new global keybinds

(global-set-key (kbd "s-\\" ) 'query-replace-regexp)

