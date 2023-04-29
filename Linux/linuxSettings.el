(setq EMACS_HOME "~/.emacs.d/elisp/")
;Recompile all files that where recently changed for fast loading
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Linux/.") 0)
(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/General/.") 0)
(native-compile-async (expand-file-name "~/.emacs.d/elisp/Linux/.") 'recursively)
(while (or comp-files-queue
               (> (comp-async-runnings) 0))
      (sleep-for 1))
;Load settings for other modes Linux specific
(load-file "~/.emacs.d/elisp/Linux/settings.elc")
(load-file "~/.emacs.d/elisp/Linux/brackets.elc")
(load-file "~/.emacs.d/elisp/Linux/c++.elc")
(load-file "~/.emacs.d/elisp/Linux/keybindings.elc")
(load-file "~/.emacs.d/elisp/Linux/melpa.elc")
(load-file "~/.emacs.d/elisp/Linux/tags.elc")
(load-file "~/.emacs.d/elisp/Linux/tablegenmode.elc")
(load-file "~/.emacs.d/elisp/Linux/susan-mode/susanMode.elc")
(load-file "~/.emacs.d/elisp/Linux/modelica-mode/modelica-mode.elc")
;Load things from General
(load-file "~/.emacs.d/elisp/General/loadGeneral.elc")
;;Setting up Modelica mode
(autoload 'modelica-mode "modelica-mode" "Modelica Editing Mode" t)
(setq auto-mode-alist (cons '("\.mo$" . modelica-mode) auto-mode-alist))
;Modelica Mode for .mos files.
(setq auto-mode-alist (cons '("\.mos$" . modelica-mode) auto-mode-alist))
;;Loading doremi
(load-file "~/.emacs.d/elisp/Linux/doremi.el/doremi.elc")
;;Turn of tabs
(setq-default indent-tabs-mode nil)
;Please be quiet emacs :)
(setq visible-bell t)
(setq auto-save-default nil)
;; Backup and Autosave Directories
(setq temporary-file-directory "~/.tmp/")
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(load-theme 'modus-vivendi)
