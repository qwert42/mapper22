function arrange()
%ARRANGE
global BOUNDARY
global DIAMETER
global START
global END
diff=0.15;
tolerence=0.07;
SORT=sortrows(BOUNDARY,2); % sort boundary with x
l=length(SORT); % number of points
count=floor((SORT(l,2)-SORT(1,2))/DIAMETER); %number of grids
flag=0; % upper bound or lower bound
START(1,2)=SORT(1,2);  % first point of START
temp=9999;
for j=1:l
    if abs(SORT(j,2)-START(1,2))<=tolerence %max
        temp(end+1)=SORT(j,1);
    end
end
START(1,1)=min(temp);

for i=1:(count+1) % calculate points coordinates
    if flag==0
        temp=START(i,1);        
        for j=1:l
            if abs(SORT(j,2)-START(i,2))<=tolerence %max
                temp(end+1)=SORT(j,1);
            end
        end
        [~,max_position]=max(temp);
        temp(max_position)=min(temp);
        END(i,2)=START(i,2);
        END(i,1)=max(temp)-diff;
        if (START(i,2)+DIAMETER)>SORT(l,2)
            break
        end
        if i<count+1
            START(i+1,2)=START(i,2)+DIAMETER;
            temp=-9999;
            for j=1:l
                if abs(SORT(j,2)-START(i+1,2))<=tolerence
                    temp(end+1)=SORT(j,1);
                end
            end
            [~,max_position]=max(temp);
            temp(max_position)=min(temp);
            START(i+1,1)=max(temp)-diff;
        end
        flag=1;
    else
        temp=START(i,1);
        for j=1:l
            if abs(SORT(j,2)-START(i,2))<=tolerence %min
                temp(end+1)=SORT(j,1);
            end
        end
        [~,min_position]=max(temp);
        temp(min_position)=max(temp);
        END(i,2)=START(i,2);
        END(i,1)=min(temp)+diff;
        if (START(i,2)+DIAMETER)>SORT(l,2)
            break
        end
        if i<count+1
            START(i+1,2)=START(i,2)+DIAMETER;
            temp=9999;
            for j=1:l
                if abs(SORT(j,2)-START(i+1,2))<=tolerence
                    temp(end+1)=SORT(j,1);
                end
            end
            [~,min_position]=min(temp);
            temp(min_position)=max(temp);
            START(i+1,1)=min(temp)+diff;
        end
        flag=0;
    end   
end
START(1,2)=START(1,2)+diff;
END(1,2)=END(1,2)+diff;
START(count+1,2)=START(count+1,2)-diff;
END(count+1,2)=END(count+1,2)-diff;
end
