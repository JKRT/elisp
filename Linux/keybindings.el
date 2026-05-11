;; -*- lexical-binding: t; -*-

                                        ;Global keybindings
(global-set-key (kbd "<kp-insert>") 'other-window)
(global-set-key (kbd "<kp-begin>")  'list-buffers)
(global-set-key (kbd "<kp-right>") 'next-buffer)
(global-set-key (kbd "<kp-left>")  'previous-buffer)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-c") 'copy-region-as-kill)
(global-set-key (kbd "s-v") 'yank)
(global-set-key (kbd "s-x") 'kill-region)
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "s-a") 'mark-whole-buffer)
(global-set-key (kbd "s-j") 'ace-jump-mode)
(global-set-key (kbd "<mouse-8>") 'clipboard-yank)
(global-set-key (kbd "<mouse-9>") 'company-complete-common-or-cycle)

(defun activate-company-if-not-active ()
  (unless (symbol-value (package-installed-p 'company-mode))
    (global-company-mode 1)))

(when (package-installed-p 'company)
  (activate-company-if-not-active)
  (global-set-key (kbd "<f12>") 'company-complete))


; Settings for Emacs copilot
;Define and set keybindings for copilot if installed. Use Ctrl+Tab to accept completions.
(if (package-installed-p 'copilot)
    (global-set-key (kbd "<C-tab>") 'copilot-accept-completion))
