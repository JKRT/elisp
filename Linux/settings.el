;Global settings relating to buffers 

(menu-bar-mode 0)
(linum-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(cua-mode t)
(tool-bar-mode -1)



(defun kill-all-buffers()
  "Kill all open buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))


(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

;To move lines around
(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))
;;My own keybindings.
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "<f5>") 'smart-compile) ; clever compiling.
(global-set-key (kbd "<f6>") 'shell) ; Open cmd
(global-set-key (kbd "<f7>") 'find-file) ;; f7 to find files.
(global-set-key (kbd "<C-mouse-1>") 'find-tag)
