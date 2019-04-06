					; C++ related settings
;BSD like indention
(setq c-default-style "bsd"
      c-basic-offset 8)

					;Can be extended here with more keybindings
(defun my-mac-cpp-config ()
  (auto-complete-mode)
  (local-set-key (kbd "<f5>") 'compile)
  ;Make sure that flycheck checks according to the C++-11 standard for C++
  ;for both GCC and Clang.
  (setq flycheck-clang-language-standard "c++11")
  (setq flycheck-gcc-language-standard "c++11")
  ;Start rtags for fast navigation (Might fail on antother Macintosh!)
  (rtags-start-process-unless-running)
  (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
  (flycheck-mode))

(add-hook 'c++-mode-hook 'my-mac-cpp-config)
;Load company ironmode, and add other configurations for company-mode.
 (eval-after-load 'company
   '(add-to-list≥
     'company-backends '(company-irony-c-headers company-irony company-yasnippet)))
