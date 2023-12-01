(defun is_digit (char)
  (and (char>= char #\0)
       (char<= char #\9))
)

(defun first_digit (str)
  (let ((char (aref str 0)))
    (if (is_digit char)
      char
      (first_digit (subseq str 1))
    )
  )
)

(defun last_digit (str)
  (let* ((len (length str))
         (char (aref str (- len 1))))
    (if (is_digit char)
      char
      (last_digit (subseq str 0 (- len 1)))
    )
  )
)

(defun first_last_digits (str)
  (parse-integer
    (coerce
      (list (first_digit str) (last_digit str))
      'string
    )
  )
)

(format t "Part 1: ~a~%"
  (reduce '+
    (with-open-file (in "/data/input.txt")
      (loop for line = (read-line in nil)
        while line
        collect (first_last_digits line))
    )
  )
)

(sb-ext:exit)