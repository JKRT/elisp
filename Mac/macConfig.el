
;Make sure to recompile the essential emacs libraries.
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Mac/.") 0)

;Some general settings
(tool-bar-mode 0)
(show-paren-mode t)
;turn of annoying sound when switching between buffers using touchpad.el
(setq ring-bell-function 'ignore)
(display-time-mode 1)
;Load other configuration files
(load-file "~/.emacs.d/elisp/Mac/Ielm.elc")
(load-file "~/.emacs.d/elisp/Mac/brackets.elc")
(load-file "~/.emacs.d/elisp/Mac/elisp.elc")
(load-file "~/.emacs.d/elisp/Mac/keybinds.elc")
(load-file "~/.emacs.d/elisp/Mac/c++.elc")
(load-file "~/.emacs.d/elisp/Mac/python.elc")
(load-file "~/.emacs.d/elisp/Mac/themeChange.elc")
(load-file "~/.emacs.d/elisp/Mac/melpa.elc")
(load-file "~/.emacs.d/elisp/Mac/modelica-mode/modelica-mode.elc")
;For thesis writing..
(load-file "~/.emacs.d/elisp/Mac/emacs-grammarly/emacs-grammarly.elc")
