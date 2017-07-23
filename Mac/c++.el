					; C++ related settings
;BSD like indention
(setq c-default-style "bsd"
      c-basic-offset 8)

					;Can be extended here with more keybindings
(defun my-cpp-config ()
  (auto-complete-mode)
  (yas-minor-mode)
  (yas-reload-all)
  (local-set-key (kbd "<f5>") 'compile)
  (local-set-key (kbd "<f6>") 'yas-insert-snippet)
  ;Make sure that flycheck checks according to the 11 standard for C++
  ;for both GCC and Clang.
  (setq flycheck-clang-language-standard "c++11")
  (setq flycheck-gcc-language-standard "c++11"))
(add-hook 'c++-mode-hook 'my-cpp-config)
;Load company ironmode, and add other configurations for company-mode.
 (eval-after-load 'company
   '(add-to-list
     'company-backends '(company-irony-c-headers company-irony company-yasnippet)))

;Load c++ config functions
(my-cpp-config)
