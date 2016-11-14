;Linux related C++ configurations 
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;Setting up Ctags
(setq path-to-ctags "/opt/local/bin/ctags") ;
