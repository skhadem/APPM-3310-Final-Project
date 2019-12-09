function [ptset1,ptset2,R,shift] = create_point_sets(num_points, with_noise, ...
                                    max_val, max_shift, num_outliers)
%CREATE_POINT_SETS Generate random points and transform them
%   Detailed explanation goes here
ptset1 = rand(num_points, 2)*(max_val);
center = mean(ptset1);

% random shift
shift = [randn*max_shift, randn*max_shift];

% random rotation
r = randn*90; % degrees
R = [cos(r) -sin(r); sin(r) cos(r)];
ptset2 = (R * [ptset1(:,1)-center(1) ptset1(:,2)-center(2)]')';
ptset2 = ptset2 + shift + center;

if (with_noise)
    ptset2 = ptset2 + rand(num_points, 2)*0.4;
end

if (num_outliers > 0)
    outlier_indexes = randi([1, num_points], 1, num_outliers);
    for ii = 1:length(outlier_indexes)
        ptset2(ii, :) = (ptset2(ii, :)) + 20;
    end
end

end

