					; Custom settings for rtags
(require 'rtags)
(set-variable 'rtags-path "/usr/local/bin")
(let ((process-connection-type nil))  ;; use pipes
  (setq rtags-process (start-process-shell-command
                       "RTags"            ;process name
                       "*rdm*"            ;buffer
                       (rtags-command)))) ;command
