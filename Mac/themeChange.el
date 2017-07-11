					;Routine to change theme depending on the time of the day.
					;Not that the material package needs to be installed


					;Routine to extract the clocktime
(defun clocktime()
					;Extract the hour from the current time
  (string-to-number
	   (car
	    (split-string (nth 3
			       (split-string (current-time-string) " ") )":"))) )


(defun check-if-night()
					;Returns true if the time is deemed being night.
  (or (> (clocktime) 21) (< (clocktime) 7)))

(defun theme-change-during-night ()
					;Set color theme depending on the time of the day
  (if  (check-if-night )
      (load-theme 'material t)
    (load-theme 'material-light t )))

					;Call the function every hour
(run-with-timer 0 3600 'theme-change-during-night)
  
