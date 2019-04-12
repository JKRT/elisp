;BSD like indention
(setq c-default-style "bsd"
      c-basic-offset 4)
					;Can be extended here with more keybindings
(defun my-mac-cpp-config()
  (auto-complete-mode)
  (setq indent-tabs-mode nil)
  (local-set-key (kbd "<f5>") 'compile)
  ;Make sure that flycheck checks according to the C++-11 standard for C++
  ;for both GCC and Clang.
  (setq flycheck-clang-language-standard "c++11")
  (setq flycheck-gcc-language-standard "c++11")
  ;Start rtags for fast navigation (Might fail on antother Macintosh!)
  (rtags-start-process-unless-running)
  ;Keys for convenient navigation.
  (local-set-key (kbd "s-.") 'rtags-find-symbol-at-point)
  (local-set-key (kbd "s-,") 'rtags-find-references-at-point)
  (local-set-key (kbd "s-;") 'rtags-find-references-tree-at-point)
  (local-set-key (kbd "s-r") 'rtags-rename-symbol)
  (local-set-key (kbd "s-h") 'rtags-print-class-hierarchy))

(defun my-flycheck-c++-rtags-setup ()
  "Configure flycheck-rtags for better experience."
  (require 'flycheck-rtags)
  (flycheck-select-checker 'rtags)
  (flycheck-mode)
  (setq-local flycheck-check-syntax-automatically nil)
  (setq-local flycheck-highlighting-mode nil))

(add-hook 'c++-mode-hook 'my-mac-cpp-config)
(add-hook 'c++-mode-hook 'my-flycheck-rtags-setup)
