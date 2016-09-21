					; C++ related settings

(setq c-default-style "bsd"
      c-basic-offset 8)

(defun my-cpp-config ()
  (auto-complete-mode)
  (yas-minor-mode)
  (yas-reload-all)
  (local-set-key (kbd "<f5>") 'compile)
  (local-set-key (kbd "<f6>") 'yas-insert-snippet)
					;Extend here
  )


(add-hook 'c++-mode-hook 'my-cpp-config)


(custom-set-variables
 '(irony-additional-clang-options
   '("-I/Library/Developer/CommandLineTools/usr/include/c++/v1")))

