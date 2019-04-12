					; Configuration that is used when writing Emacs Lisp
(defun general-settings-emacs-lisp-mode()
  (auto-complete-mode)
  (local-set-key (kbd "s-e") 'eval-region))
(defun rtags-config-for-emacs-lisp-mode()
  (rtags-start-process-unless-running)
  (local-set-key (kbd "s-.") 'rtags-find-symbol-at-point)
  (local-set-key (kbd "s-,") 'rtags-find-references-at-point)
  (local-set-key (kbd "s-;") 'rtags-find-references-tree-at-point)
  (local-set-key (kbd "s-r") 'rtags-rename-symbol)
  (local-set-key (kbd "s-h") 'rtags-print-class-hierarchy))
;Boot it up
(add-hook 'emacs-lisp-mode-hook 'general-settings-emacs-lisp-mode)
(add-hook 'emacs-lisp-mode-hook 'rtags-config-for-emacs-lisp-mode)
