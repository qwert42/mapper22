function find_boundary(r)
    global boundary_done
    global BOUNDARY
    
    boundary_done = false;
    BOUNDARY = [];


    global circumnavigate_ok

    %origin = se(0,0,0);
    endpose = se(2000000,0,0);

    global goal_coord
    goal_coord = pos_from_ht(endpose);

    pose=se(DistanceSensorRoomba(r), 0, AngleSensorRoomba(r));

    while boundary_done == false
        pose=turn_towards_dest(r,pose);
        display(pose)

        CALIBRATE_COUNTER = 5;
        counter = 0;

        %move forward until bump
        bump=bump_test(r);
        while bump==NO_BUMP
            if counter > CALIBRATE_COUNTER
                % Because it cannot be guaranteed that we exit circumnavigation
                % mode with perfect orientation towards goal. And a small error
                % in orientation most often turns out to be disastrous. So the
                % orientation must be calibrated before it's too late.
                % We calibrate our orientation every 2 steps.
                display('calibrating-----------------------')
                pose = calibrate(r, pose);
                boundary_new_row = pos_from_ht(pose);
                BOUNDARY(end+1,:) = boundary_new_row;
                counter = 0;
            end
            counter = counter + 1;

            display(norm(pos_from_ht(pose) - goal_coord))

            dist = move_forward(r, WALK_VEL, WALK_TIME);
            pose = pose * se(dist, 0, 0);
            
            boundary_new_row = pos_from_ht(pose);
            BOUNDARY(end+1,:) = boundary_new_row;

            %trplot2(pose);
            %hold on

%             if norm(pose(:, 3) - endpose(:,3)) < tolerance
%                 display('SUCCEED')
%                 SetFwdVelRadiusRoomba(r, 0, inf);
%                 return;
%             end
            bump = bump_test(r);
        end

        
        %circumnavigate
        %if arrive end point--exit
        %if arrive last bump point--exit,failure
        %if meet the intersected line, break and turn towards end point

        pose = circumnavigate(r, pose);
        if circumnavigate_ok == 0 % We finished circumnavigation, and need to
                                  % go forward, so dicard previous BOUNDARY
            BOUNDARY = [];
        elseif circumnavigate_ok == -1
            display('Boundary founded')
            SetFwdVelRadiusRoomba(r, 0, inf); % stop iCreate
            boundary_done = true;
        end
    end
end

    
    
    
    
    