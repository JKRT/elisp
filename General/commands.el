;For repeating complex commands in a simple way
(global-set-key [(s shift r)]
		(lambda () (interactive)
                  (eval (car command-history))))

;Repeat the last keyboard command.
(global-set-key [(s r)] 'repeat)

;More stuff...
