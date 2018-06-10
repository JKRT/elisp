;Recompile all files that where recently changed for fast loading
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Linux/.") 0)

(load-file "~/.emacs.d/elisp/Linux/settings.elc")
(load-file "~/.emacs.d/elisp/Linux/brackets.elc")
(load-file "~/.emacs.d/elisp/Linux/c++.elc")
(load-file "~/.emacs.d/elisp/Linux/keybindings.elc")
(load-file "~/.emacs.d/elisp/Linux/melpa.elc")
(load-file "~/.emacs.d/elisp/Linux/tags.elc")


;;Setting up Modelica mode
(load-file "~/.emacs.d/elisp/Linux/modelica-mode/modelica-mode.elc")
(autoload 'modelica-mode "modelica-mode" "Modelica Editing Mode" t)
(setq auto-mode-alist (cons '("\.mo$" . modelica-mode) auto-mode-alist))
;Modelica Mode for .mos files.
(setq auto-mode-alist (cons '("\.mos$" . modelica-mode) auto-mode-alist))

;;Loading doremi
(load-file "~/.emacs.d/elisp/Linux/doremi.el/doremi.elc")
