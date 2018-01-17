;Linux related C++ configurations 

;C++ related hoooks
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook 'auto-complete-mode)

;Setting up Ctags
(setq path-to-ctags "/usr/bin/ctags") ;

 (defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f TAGS -e -R %s" path-to-ctags 
	     (directory-file-name dir-name))))
