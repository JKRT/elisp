;;; gptel.el --- Local LLM integration via gptel -*- lexical-binding: t; -*-

;; ============================================================
;; 1. Backend and default model
;; ============================================================

(setq gptel-backend (gptel-make-openai "Qwen3-local"
                      :host "localhost:8080"
                      :protocol "http"
                      :stream t
                      :models '(qwen3-14b)))

(setq gptel-model 'qwen3-14b)

;; Use org-mode for chat buffers (nicer formatting than markdown)
(setq gptel-default-mode 'org-mode)

;; ============================================================
;; 2. Directives (system prompts)
;; ============================================================

(setq gptel-directives
      '((default    . "You are a helpful assistant. Be concise and direct.")
        (code       . "You are a programming assistant. Write clean, correct code. Explain only when asked.")
        (writing    . "You are a writing assistant. Improve clarity and flow while preserving the author's voice.")
        (explain    . "You are a teacher. Explain concepts clearly with examples. Assume the reader is technical.")
        (translate  . "You are a translator. Translate the given text accurately, preserving tone and meaning.")))

;; ============================================================
;; 3. Quick ask: prompt from minibuffer, response in temp buffer
;; ============================================================

(defun my/quick-local-ask (prompt)
  "Ask the local LLM a quick question. Response appears in *LLM Response* buffer."
  (interactive "sAsk LLM: ")
  (gptel-request prompt
    :callback (lambda (response _info)
                (if response
                    (with-current-buffer (get-buffer-create "*LLM Response*")
                      (erase-buffer)
                      (insert response)
                      (goto-char (point-min))
                      (org-mode)
                      (display-buffer (current-buffer)))
                  (message "gptel: No response received.")))))

;; ============================================================
;; 4. Send region to LLM with a question about it
;; ============================================================

(defun my/ask-about-region (question)
  "Send the selected region to the LLM with a QUESTION about it.
Response appears in *LLM Response* buffer."
  (interactive "sQuestion about selection: ")
  (unless (use-region-p)
    (user-error "No region selected"))
  (let ((text (buffer-substring-no-properties (region-beginning) (region-end))))
    (gptel-request (format "Context:\n```\n%s\n```\n\n%s" text question)
      :callback (lambda (response _info)
                  (if response
                      (with-current-buffer (get-buffer-create "*LLM Response*")
                        (erase-buffer)
                        (insert response)
                        (goto-char (point-min))
                        (org-mode)
                        (display-buffer (current-buffer)))
                    (message "gptel: No response received."))))))

;; ============================================================
;; 5. Inline rewrite: replace region with LLM output
;; ============================================================

(defun my/rewrite-region (instruction)
  "Replace the selected region based on INSTRUCTION.
The LLM rewrites the text according to your instructions."
  (interactive "sRewrite instruction: ")
  (unless (use-region-p)
    (user-error "No region selected"))
  (let ((text (buffer-substring-no-properties (region-beginning) (region-end)))
        (beg (region-beginning))
        (end (region-end))
        (buf (current-buffer)))
    (gptel-request
        (format "Rewrite the following text according to this instruction: %s\n\nReturn ONLY the rewritten text, no explanation.\n\nText:\n%s" instruction text)
      :callback (lambda (response _info)
                  (if response
                      (with-current-buffer buf
                        (save-excursion
                          (delete-region beg end)
                          (goto-char beg)
                          (insert response)))
                    (message "gptel: No response received."))))))

;; ============================================================
;; 6. Keybindings
;; ============================================================

(global-set-key (kbd "C-c l l") #'gptel)              ; open chat buffer
(global-set-key (kbd "C-c l s") #'gptel-send)          ; send in any buffer
(global-set-key (kbd "C-c l q") #'my/quick-local-ask)  ; quick question
(global-set-key (kbd "C-c l a") #'my/ask-about-region) ; ask about selection
(global-set-key (kbd "C-c l r") #'my/rewrite-region)   ; rewrite selection
(global-set-key (kbd "C-c l m") #'gptel-menu)          ; transient menu

(provide 'gptel-config)
;;; gptel.el ends here
