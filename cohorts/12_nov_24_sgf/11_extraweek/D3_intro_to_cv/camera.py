import cv2
import sys

s = 0 # Camera device index
if len(sys.argv) > 1:
    s = sys.argv[1]

source = cv2.VideoCapture(s)

# Open a new window
win_name = 'Camera Preview'
cv2.namedWindow(win_name, cv2.WINDOW_NORMAL)

# Wait until the user presses the Escape key
while cv2.waitKey(1) != 27:
    has_frame, frame = source.read()
    if not has_frame:
        break
    cv2.imshow(win_name, frame)

source.release()
cv2.destroyWindow(win_name)