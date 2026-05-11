;;; xwidget.el --- Linux xwidget helpers -*- lexical-binding: t; -*-

(require 'browse-url)
(require 'url-parse)
(require 'url-util)
(require 'xwidget nil t)

(defgroup my-xwidget nil
  "Local xwidget browser integration."
  :group 'convenience)

(defcustom my/html-xwidget-auto-view t
  "When non-nil, opening a local HTML file also opens a rich xwidget view."
  :type 'boolean
  :group 'my-xwidget)

(defcustom my/xwidget-use-as-browser t
  "When non-nil, use xwidget WebKit for `browse-url' on graphical Linux frames."
  :type 'boolean
  :group 'my-xwidget)

(defconst my/html-xwidget-file-regexp "\\.\\(?:x?html?\\)\\'"
  "File name regexp for HTML files rendered by xwidget WebKit.")

(defvar-local my/html-xwidget-source-file nil
  "Source file displayed by the current xwidget WebKit buffer.")

(defvar my/html-xwidget--suppress-auto-view nil
  "Non-nil while opening HTML source without switching back to rich view.")

(defun my/xwidget-available-p ()
  "Return non-nil when xwidget WebKit can be used in the current frame."
  (and (eq system-type 'gnu/linux)
       (display-graphic-p)
       (featurep 'xwidget-internal)
       (fboundp 'xwidget-webkit-browse-url)))

(defun my/xwidget--ensure-available ()
  "Signal a user error unless xwidget WebKit is available."
  (unless (my/xwidget-available-p)
    (user-error "xwidget WebKit is not available in this Emacs frame")))

(defun my/html-xwidget--html-file-p (file)
  "Return non-nil when FILE is a local HTML file."
  (and file
       (not (file-remote-p file))
       (string-match-p my/html-xwidget-file-regexp file)))

(defun my/html-xwidget--file-url (file)
  "Return the local file URL for FILE."
  (browse-url-file-url (expand-file-name file)))

(defun my/html-xwidget--file-url-to-file (url)
  "Return a local file name from file URL, or nil if URL is not local."
  (when (and url (string-prefix-p "file:" url))
    (let* ((parsed (url-generic-parse-url url))
           (host (url-host parsed))
           (filename (url-filename parsed)))
      (when (and filename
                 (or (not host) (string= host "") (string= host "localhost")))
        (expand-file-name (url-unhex-string filename))))))

(defun my/html-xwidget-current-source-file ()
  "Return the source file associated with the current rich HTML view."
  (or (when (and (derived-mode-p 'xwidget-webkit-mode)
                 (fboundp 'xwidget-webkit-current-session))
        (let ((session (xwidget-webkit-current-session)))
          (when session
            (my/html-xwidget--file-url-to-file
             (xwidget-webkit-uri session)))))
      my/html-xwidget-source-file))

(defun my/html-xwidget-reload (&rest _ignore)
  "Reload the current xwidget WebKit buffer."
  (interactive)
  (if (derived-mode-p 'xwidget-webkit-mode)
      (xwidget-webkit-reload)
    (my/html-xwidget-view-current-file))
  t)

(defun my/html-xwidget--remember-source (file)
  "Remember FILE as the local source for the current xwidget buffer."
  (setq-local my/html-xwidget-source-file (expand-file-name file))
  (setq-local revert-buffer-function #'my/html-xwidget-reload))

(defun my/html-xwidget-view-file (file &optional reuse-session)
  "Open local HTML FILE in an xwidget WebKit buffer.

With prefix argument REUSE-SESSION, reuse the current xwidget WebKit session
instead of creating a new one."
  (interactive "fHTML file: \nP")
  (my/xwidget--ensure-available)
  (let ((expanded (expand-file-name file)))
    (when (file-remote-p expanded)
      (user-error "xwidget local HTML view does not support remote files"))
    (unless (file-exists-p expanded)
      (user-error "No such file: %s" expanded))
    (xwidget-webkit-browse-url
     (my/html-xwidget--file-url expanded)
     (not reuse-session))
    (when (derived-mode-p 'xwidget-webkit-mode)
      (my/html-xwidget--remember-source expanded))
    (current-buffer)))

(defun my/html-xwidget-view-current-file (&optional reuse-session)
  "Open the current buffer's file in an xwidget WebKit buffer.

With prefix argument REUSE-SESSION, reuse the current xwidget WebKit session
instead of creating a new one."
  (interactive "P")
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))
  (my/html-xwidget-view-file buffer-file-name reuse-session))

(defun my/html-xwidget-edit-source ()
  "Open the source file for the current rich HTML view."
  (interactive)
  (let ((file (or (my/html-xwidget-current-source-file)
                  buffer-file-name)))
    (unless file
      (user-error "No local HTML source file is associated with this buffer"))
    (let ((my/html-xwidget--suppress-auto-view t))
      (find-file file))))

(defun my/html-xwidget--maybe-auto-view ()
  "Open a rich xwidget view for local HTML files."
  (when (and my/html-xwidget-auto-view
             (not my/html-xwidget--suppress-auto-view)
             (my/html-xwidget--html-file-p buffer-file-name))
    (if (my/xwidget-available-p)
        (my/html-xwidget-view-current-file)
      (message "xwidget WebKit unavailable; using html-mode for %s"
               (file-name-nondirectory buffer-file-name)))))

(defalias 'my/xwidget-browse-file #'my/html-xwidget-view-file)
(defalias 'my/xwidget-browse-current-file #'my/html-xwidget-view-current-file)

(add-to-list 'auto-mode-alist (cons my/html-xwidget-file-regexp #'html-mode))
(add-hook 'find-file-hook #'my/html-xwidget--maybe-auto-view)

(when (and my/xwidget-use-as-browser (my/xwidget-available-p))
  (setq browse-url-browser-function #'xwidget-webkit-browse-url))

(global-set-key (kbd "C-c x f") #'my/html-xwidget-view-file)
(global-set-key (kbd "C-c x c") #'my/html-xwidget-view-current-file)
(global-set-key (kbd "C-c x e") #'my/html-xwidget-edit-source)

(with-eval-after-load 'xwidget
  (define-key xwidget-webkit-mode-map (kbd "C-c C-e")
              #'my/html-xwidget-edit-source)
  (define-key xwidget-webkit-mode-map (kbd "C-c C-r")
              #'my/html-xwidget-reload))

(provide 'my-xwidget)

;;; xwidget.el ends here
