
;Make sure to recompile the essential emacs libraries.
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Mac/.") 0)


(tool-bar-mode 0)
(show-paren-mode t)
;turn of annoying sound when switching between buffers using touchpad.el
(setq ring-bell-function 'ignore)

					;Load other configuration files

