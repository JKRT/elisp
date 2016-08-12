					; C++ related settings

(setq c-default-style "bsd"
      c-basic-offset 8)

(add-hook 'c++-mode-hook
	  (lambda () '(local-set-key (kbd "f5") 'compile)))

(add-hook 'c++-mode-hook
	  (lambda () '(auto-complete-mode)))

(add-hook 'c++-mode-hook
	  (lambda () '(yas-minor-mode)))

(add-hook 'c++-mode-hook
	  (lambda () '(local-set-key (kbd "f6") 'yas-insert-snippet)))
