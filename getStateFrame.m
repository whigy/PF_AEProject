function  f  =  getStateFrame(frame, window)
f = frame(int16(window(1)) : int16(window(3)), int16(window(2)) : int16(window(4)), :);
end

