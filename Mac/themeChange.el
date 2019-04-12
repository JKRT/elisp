(require 'material)		
(defun clocktime()
  "Routine to change theme depending on the time of the day.
  Note that the material package needs to be installed"
(string-to-number
 (car (split-string (nth 3 (split-string (current-time-string) " ") )":"))))

(defun check-if-night()
  (or (> (clocktime) 21) (< (clocktime) 7)))

(defun theme-change-during-night()
  (if (check-if-night)
      (load-theme 'material t)
    (load-theme 'material-light t)))
;Call the function every hour
(run-with-timer 0 3600 'theme-change-during-night) 
