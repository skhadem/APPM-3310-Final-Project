function [ptset1,ptset2,R,shift] = create_point_sets(prev_points, num_points, with_noise, ...
                                    max_val, max_shift, num_outliers)
%CREATE_POINT_SETS Generate random points and transform them
%   Detailed explanation goes here
if (isempty(prev_points))
    ptset1 = rand(num_points, 2)*(max_val);
else
    ptset1 = prev_points;
    num_points = size(ptset1, 1);
end
center = mean(ptset1);

% random shift
shift = [randn*max_shift, randn*max_shift];

% random rotation
r = randn*pi; % degrees
R = [cos(r) -sin(r); sin(r) cos(r)];
ptset2 = (R * [ptset1(:,1)-center(1) ptset1(:,2)-center(2)]')';
ptset2 = ptset2 + shift + center;

% scale noise by the function parameter
if (with_noise)
    noise_mat = [];
    for ii = 1:num_points
        noise_mat = [noise_mat; [randi([1, with_noise]),  randi([1, with_noise])]];
    end
    ptset2 = ptset2 + noise_mat;
end

% scale outliers by the function parameter
if (num_outliers > 0)
    outlier_indexes = randi([1, num_points], 1, num_outliers);
    for ii = 1:length(outlier_indexes)
        ptset2(outlier_indexes(ii), :) = (ptset2(outlier_indexes(ii), :)) + 15 + num_outliers;
    end
end

end

