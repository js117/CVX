
/* <* SetOptions[CAssign, 
              AssignMaxSize->2000,
              AssignTemporary->{"tmp", Array}, 
              AssignTrig->True,
              AssignToArray->{q, qdot},
              AssignBreak->False,
              AssignOptimize->False,
              AssignReplace->{"x5dot"->"q[3]", 
                              "x6dot"->"q[4]",
                              "x7dot"->"q[5]",
                              "x5"->"q[0]", 
                              "x6"->"q[1]",
                              "x7"->"q[2]",
                              "Mp"->"params[1]",
                              "M"->"params[0]",
                              "g"->"params[2]",
                              "l"->"params[3]",
                              "w"->"params[4]",
                              "slope"->"params[5]"}]; *> */

<* CAssign[{qdot[3], qdot[4], qdot[5]}, {x5dotdot, x6dotdot, x7dotdot}] *>
