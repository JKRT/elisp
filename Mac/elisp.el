(add-hook 'emacs-lisp-mode-hook
	  (lambda ()  '(auto-complete-mode)))


(add-hook 'emacs-lisp-mode-hook
	  (lambda ()  '(auto-complete-mode)))


(add-hook 'emacs-lisp-mode-hook
	  (lambda () (local-set-key [(s e)] 'eval-region)))
