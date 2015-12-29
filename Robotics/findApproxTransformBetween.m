% find a "rotation matrix" O s.t. TH*O ~ TR
% precondition: TH, TR are 3x3 rotation matrices
function O = findApproxTransformBetween(TH, TR)

        cvx_begin quiet
            variable epsilon
            variable O(3,3)

            minimize norm(TH*O - TR, 'fro') + epsilon
            subject to
                    norm(O, Inf) <= 1

                    O(:,1)'*O(:,1) - 1 <= epsilon
                    O(:,2)'*O(:,2) - 1 <= epsilon
                    O(:,3)'*O(:,3) - 1 <= epsilon

                    %O(:,1)'*O(:,2) <= epsilon
                    %O(:,1)'*O(:,3) <= epsilon
                    %O(:,2)'*O(:,3) <= epsilon

                    epsilon >= 0

        cvx_end

        Oprev = O;
        

end