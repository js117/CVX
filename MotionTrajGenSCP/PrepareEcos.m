% As in 'ecos_testing.m'
function [G, h] = PrepareEcos(Bk0_mat, dk0_vec, Bk1_vec, dk1_scalar, mi_vec, r, n)

    % Construct h and G as per slide 14-7, http://www.seas.ucla.edu/~vandenbe/236C/lectures/conic.pdf
    numRows = 0;
    for i=1:r
        numRows = numRows + (mi_vec(i) - 1) + 1; % useless algebra meant to be symbolic of what we're actually doing
    end

    h = zeros(numRows,1);
    G = zeros(numRows,n);

    % Now fill 'em:
    jStart = 1;
    for i=1:r
       % oh lord the indexing
       mi = mi_vec(i);
       % Compute end for current concat:
       jStop = jStart + mi - 2;

       %h(jStart : jStop) = dk0_vec{i};
       %h(jStop + 1) = dk1_scalar{i};
       h(jStart) = dk1_scalar{i};
       h(jStart + 1 : jStop + 1) = dk0_vec{i};

       %G(jStart : jStop, :) = -Bk0_mat{i};
       %G(jStop + 1, :) = -Bk1_vec{i}; 
       G(jStart, :) = -Bk1_vec{i};
       G(jStart + 1 : jStop + 1, :) = -Bk0_mat{i};


       % Compute start for the next concat:
       jStart = jStop + 2;
    end

end