;;; This code has been placed in the Public Domain.  All warranties are disclaimed.

                            \\  "\\\\"}]
    (do (.append w \")
      (dotimes [n (count s)]
        (let [c (.charAt s n)
              e (char-escape-string c)]
          (if e (.write w e) (.append w c))))
      (.append w \"))
  nil))