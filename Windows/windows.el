;;Windows is annoying
(setq EMACS_HOME "~/.emacs.d/elisp/")
;;Make sure to recompile other needed packages. We do this in case a modification has been made.
(byte-recompile-directory (expand-file-name (concat EMACS_HOME "Windows/.") 0))
;;Some common settings. No tool-bar but we keep the menu bar. Standard ctrl z ctrl v ctrl x e.t.c
(tool-bar-mode 0)
(cua-mode t)
(show-paren-mode t)
(display-time-mode 1)
(load-file (concat EMACS_HOME "General/loadGeneral.el"))
;;Good theme. Will crash if immaterial is not installed.
(load-theme 'immaterial t)
;;Because NT-FS is less good then other file systems. You could say that it sucks. Still, that would be mean.
;;It is not as bad as the old mac file system atleast..
(setq directory-free-space-program nil)
(setq w32-get-true-file-attributes nil)
