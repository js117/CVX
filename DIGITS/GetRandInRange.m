function y = GetRandInRange(a,b)
    y = round((b-a).*rand(1,1) + a);
end