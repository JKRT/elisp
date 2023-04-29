;Global settings relating to buffers

(menu-bar-mode 1)
(linum-mode 1)
(show-paren-mode 1)
(setq show-paren-delay 0)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))
(cua-mode t)
(tool-bar-mode -1)
(display-time-mode 1)

(defun kill-all-buffers()
  "Kill all open buffers"
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

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


(defun move-region (start end n)
  "Move the current region up or down by N lines."
  (interactive "r\np")
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (let ((start (point)))
      (insert line-text)
      (setq deactivate-mark nil)
      (set-mark start))))

(defun move-region-up (start end n)
  "Move the current line up by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) -1 (- n))))

(defun move-region-down (start end n)
  "Move the current line down by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) 1 n)))


(defun move-line-region-up (&optional start end n)  (interactive "r\np")
  (if (use-region-p) (move-region-up start end n) (move-line-up n)))

(defun move-line-region-down (&optional start end n)
  (interactive "r\np")
  (if (use-region-p) (move-region-down start end n) (move-line-down n)))

(add-hook 'yaml-mode-hook
    '(lambda ()
       (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;My own keybindings.
(global-set-key (kbd "M-p") 'move-line-region-up)
(global-set-key (kbd "M-n") 'move-line-region-down)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "<C-mouse-1>") 'find-tag)
(setq ring-bell-function 'ignore)


;; (require 'julia-mode)
;; (push "/home/johti17/.emacs.d/elpa/lsp-julia-20210329.1551" load-path)
;; (require 'lsp-julia)
;; (require 'lsp-mode)
;; ;; Configure lsp + julia
;; (add-hook 'julia-mode-hook #'lsp-mode)
;; (add-hook 'julia-mode-hook #'lsp)
