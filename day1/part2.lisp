(ql:quickload "str")

(defparameter all_words '(
  ("one" . #\1)
  ("two" . #\2)
  ("three" . #\3)
  ("four" . #\4)
  ("five" . #\5)
  ("six" . #\6)
  ("seven" . #\7)
  ("eight" . #\8)
  ("nine" . #\9)
))

(defun is_digit (char)
  (and (char>= char #\0)
       (char<= char #\9))
)

(defun first_digit (str &optional (words all_words))
  (if words
    (if (str:starts-with-p (car (car words)) str)
      (cdr (car words))
      (first_digit str (cdr words))
    )
    (let ((char (aref str 0)))
      (if (is_digit char)
        char
        (first_digit (subseq str 1))
      )
    )
  )
)

(defun last_digit (str  &optional (words all_words))
  (if words
    (if (str:ends-with-p (car (car words)) str)
      (cdr (car words))
      (last_digit str (cdr words))
    )
    (let* ((len (length str))
           (char (aref str (- len 1))))
      (if (is_digit char)
        char
        (last_digit (subseq str 0 (- len 1)))
      )
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

(format t "Part 2: ~a~%"
  (reduce '+
    (with-open-file (in "/data/input.txt")
      (loop for line = (read-line in nil)
        while line
        collect (first_last_digits line))
    )
  )
)

(sb-ext:exit)