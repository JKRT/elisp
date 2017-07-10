					;Routine to change theme depending on the time of the day.
					;Not that the material package needs to be installed


(defun check-if-night()
					;Returns true if the time is deemed being night.
  (or (> (clocktime) 21) (< (clocktime) 7)))

(defun check-if-day()
					;Returns true if the time is deemed being day.
  (or (< (clocktime) 21) (> (clocktime) 7)))


(defun theme-change-during-night ()
					;Set color theme depending on the time of the day
  (cond (
	 (check-if-night  (load-theme 'material t))
	 (check-if-day (load-theme 'material-light t )))))

