(byte-recompile-directory (expand-file-name "~/.emacs.d/elisp/Linux/.") 0)

;UI minor ui settings
(tool-bar-mode 0)
(show-paren-mode t)


(defadvice text-scale-increase (around all-buffers (arg) activate)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      ad-do-it)))


(load-file "~/.emacs.d/elisp/Linux/brackets.elc")
(load-file "~/.emacs.d/elisp/Linux/c++.elc")
(load-file "~/.emacs.d/elisp/Linux/keybindings.elc")
(load-file "~/.emacs.d/elisp/Linux/melpa.elc")
