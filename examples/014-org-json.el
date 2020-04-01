;;; org-json.el --- Serve Org-mode pages as json  -*- lexical-binding: t; -*-
;; suggested by nicferrier
;; Copyright (C) 2014-2020  Free Software Foundation, Inc.

(require 'json)
(let ((docroot "/tmp/"))
  (ws-start
   (lambda (request)
     (with-slots (process headers) request
       (let ((path (ws-in-directory-p
                    docroot (substring (cdr (assoc :GET headers)) 1))))
         (unless (and path (file-exists-p path))
           (ws-send-404 process))
         (save-window-excursion
           (find-file path)
           (ws-response-header process 200
             '("Content-type" . "application/json"))
           (process-send-string process
             (let ((tree (org-element-parse-buffer)))
               (org-element-map tree
                   (append org-element-all-objects org-element-all-elements)
                 (lambda (el)
                   (org-element-put-property el :parent "none")
                   (org-element-put-property el :structure "none")))
               (json-encode tree)))))))
   9014))
