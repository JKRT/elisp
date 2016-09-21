;But all backup files in the temp dir.
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

(defun kill-all-buffers()
  "Kill all open buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
