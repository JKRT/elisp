					;General settings
(defun setting-according-to-os(nix-setting win-setting)
  (if (not (string-equal system-type "windows-nt"))
      (eval nix-setting)
    (eval win-setting)))
;;For repeating complex commands in a simple way
(setq-local nix-repeat-complex '(global-set-key [(s shift r)]
				       (lambda () (interactive)
					 (eval (car command-history)))))
(setq-local win-repeat-complex (global-set-key [(s shift r)]
				       (lambda () (interactive)
					 (eval (car command-history)))))
;;Repeat the last keyboard command.
(setq-local nix-repeat '(global-set-key [(s r)] 'repeat))
(setq-local win-repeat '(global-set-key [(s r)] 'repeat))
;Set settings
(setting-according-to-os nix-repeat win-repeat)
(setting-according-to-os nix-repeat win-repeat)
