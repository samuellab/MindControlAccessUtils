function x=walk(a,b)
%given to integers a & b the 1dwalker walks integer values between them
if (b>a)
    x=a:b;
else
    x=fliplr([b:a]);
end