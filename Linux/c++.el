;Linux related C++ configurations 

;C++ related hooks
(when (fboundp 'lsp)
  (add-hook 'c++-mode-hook #'lsp))

