;;; omjledit.el --- OMJLEdit browser helpers -*- lexical-binding: t; -*-

(require 'browse-url)
(require 'xwidget nil t)

(defgroup omjledit nil
  "Local OMJLEdit browser integration."
  :group 'applications)

(defcustom omjledit-url "http://127.0.0.1:8080/"
  "Default URL for the local OMJLEdit server."
  :type 'string
  :group 'omjledit)

(defcustom omjledit-prefer-xwidget t
  "When non-nil, open OMJLEdit inside Emacs when xwidget WebKit is supported."
  :type 'boolean
  :group 'omjledit)

(defvar omjledit-xwidget-supported nil
  "Non-nil when OMJLEdit can currently be opened with xwidget WebKit.")

(defun omjledit-xwidget-supported-p (&optional frame)
  "Return non-nil when xwidget WebKit can display OMJLEdit in FRAME.

When FRAME is nil, check the currently selected frame."
  (let ((target-frame (or frame (selected-frame))))
    (and (eq system-type 'gnu/linux)
         (display-graphic-p target-frame)
         (fboundp 'xwidget-webkit-browse-url)
         (or (featurep 'xwidget-internal)
             (featurep 'xwidget)))))

(defun omjledit-refresh-xwidget-support (&optional frame)
  "Refresh and return `omjledit-xwidget-supported' for FRAME.

When called interactively, also report the current support state."
  (interactive)
  (setq omjledit-xwidget-supported
        (omjledit-xwidget-supported-p frame))
  (when (called-interactively-p 'interactive)
    (message "OMJLEdit xwidget support: %s"
             (if omjledit-xwidget-supported "available" "unavailable")))
  omjledit-xwidget-supported)

(defun omjledit--open-url (url &optional external-browser)
  "Open URL using xwidget WebKit when available, unless EXTERNAL-BROWSER is non-nil."
  (setq omjledit-xwidget-supported
        (omjledit-xwidget-supported-p))
  (if (and (not external-browser)
           omjledit-prefer-xwidget
           omjledit-xwidget-supported)
      (condition-case err
          (xwidget-webkit-browse-url url)
        (error
         (setq omjledit-xwidget-supported nil)
         (message "xwidget WebKit failed (%s); opening OMJLEdit externally"
                  (error-message-string err))
         (browse-url-default-browser url)))
    (browse-url-default-browser url)))

(defun omjledit-open (&optional external-browser)
  "Open the local OMJLEdit GUI.

With prefix argument EXTERNAL-BROWSER, use the system default browser even when
xwidget WebKit is supported."
  (interactive "P")
  (omjledit--open-url omjledit-url external-browser))

(defun omjledit-open-external ()
  "Open the local OMJLEdit GUI in the system default browser."
  (interactive)
  (omjledit--open-url omjledit-url t))

(defun omjledit-open-with-xwidget ()
  "Open the local OMJLEdit GUI with xwidget WebKit.

Signal a user error when this Emacs build or frame cannot use xwidget WebKit."
  (interactive)
  (unless (omjledit-refresh-xwidget-support)
    (user-error "xwidget WebKit is not available in this Emacs frame"))
  (xwidget-webkit-browse-url omjledit-url))

(omjledit-refresh-xwidget-support)
(add-hook 'after-make-frame-functions #'omjledit-refresh-xwidget-support)

(provide 'omjledit)
