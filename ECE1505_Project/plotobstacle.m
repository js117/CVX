function plotobstacle(obs)

    for i=1:length(obs)
        switch obs{i}.type
            case 'cyl'
                r = obs{i}.R;
                c = obs{i}.c;
                h = obs{i}.h;
                [x,y,z] = cylinder(r,20);
                x = x + c(1)*ones(size(x));
                y = y + c(2)*ones(size(y));
                z = z*h;
                surf(x,y,z);
            case 'sph'
                r = obs{i}.R;
                c = obs{i}.c;
                [x,y,z] = sphere;
                x = r*x + c(1)*ones(size(x));
                y = r*y + c(2)*ones(size(y));
                z = r*z + c(3)*ones(size(z));
                surf(x,y,z);
        end
    end

end