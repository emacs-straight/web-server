;;; org-agenda.el --- display the Org-mode agenda  -*- lexical-binding: t; -*-
;; Copyright (C) 2014-2020  Free Software Foundation, Inc.

(if t (require 'htmlize))               ;Don't require during compilation.

(ws-start
 (lambda (request)
   (with-slots (process headers) request
     (ws-response-header process 200
       '("Content-type" . "text/html; charset=utf-8"))
     (org-agenda nil "a")
     (process-send-string process
       (save-window-excursion
         (let ((html-buffer (htmlize-buffer)))
           (prog1 (with-current-buffer html-buffer (buffer-string))
             (kill-buffer html-buffer)
             (org-agenda-quit)))))))
 9011)
