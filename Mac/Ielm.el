					;Some local configurations of IELM for the mac
(add-hook 'ielm-mode-hook
	  (lambda () (local-set-key (kbd "<s-up>") 'comint-previous-input)))
(add-hook 'ielm-mode-hook
	  (lambda () (local-set-key (kbd "<s-down>") 'comint-next-input)))
