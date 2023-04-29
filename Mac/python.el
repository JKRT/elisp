                                        ;Python related settings
                                        ;For python related stuff
(add-hook 'inferior-python-mode-hook
          (lambda () (local-set-key (kbd "s-<up>") 'comint-previous-input)))

(add-hook 'inferior-python-mode-hook
          (lambda () (local-set-key (kbd "<s-up>") 'comint-previous-input)))
(add-hook 'inferior-python-mode-hook
          (lambda () (local-set-key (kbd "<s-down>") 'comint-next-input)))

(add-hook 'python-mode-hook
          (lambda ()
            '(auto-complete-mode)))
