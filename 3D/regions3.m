
xrand = [-.5+rand(1) xi(2) xi(3) -.5+rand(1) xi(5) xi(6)]
walk3(xrand, 6, 1)
for i=1:19
    xrand = [xi(1)-.5+rand(1) xi(2) xi(3) xi(4)-.5+rand(1) xi(5) xi(6)]
    walk3(xrand, 6, 3)
end