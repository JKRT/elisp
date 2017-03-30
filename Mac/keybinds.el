; Some global keybindings for my mac config

(setq mac-option-key-is-meta nil)
(setq mac-option-modifier nil)

(global-set-key (kbd "s-\\") 'set-mark-command) 
(global-set-key [(s backspace )] 'backward-kill-word)
(global-set-key [(shift s backspace)] 'kill-word) 
