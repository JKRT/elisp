;Global settings relating to buffers 

(menu-bar-mode 0)
(linum-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(cua-mode t)
(tool-bar-mode -1)
;;My own keybindings.
(global-set-key (kbd "<f5>") 'smart-compile) ; clever compiling.
(global-set-key (kbd "<f6>") 'shell) ; Open cmd
(global-set-key (kbd "<f7>") 'find-file) ;; f7 to find files.

(defun kill-all-buffers()
  "Kill all open buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))


(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))
