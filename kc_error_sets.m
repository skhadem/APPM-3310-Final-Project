function [outliers,noise] = kc_error_sets(prev_points, num_points, with_noise, ...
                                    max_val, max_shift, num_outliers)

% ############ 1. create sets of points ############

% generate k random points
smiley_pts = load('smiley_points.mat');
smiley_pts = smiley_pts.smiley_pts;

% x-axis vectors
outlier_domain = zeros(1, num_points)
noise_domain = zeros(1, num_points)

% y-axis vectors
outlier_error = zeros(1, num_points)
noise_error = zeros(5, num_points)

matrixPoint = zeros(1,5)

noise_thresh = [0.9,0.9,0.9,0.9,0.9,0.8,0.8,0.8,0.8,0.8];

% for loop for noise (outliers held constant)
for i = 1:num_points
    % generate random points with i outliers and noise
    
    for j = 1:5
        % compute kc registration
        validResult = false
        while validResult == false
            [map, pts, rot, shift] = create_point_sets([], 20, i, ...
                                            20, 5, 0);
            kc_results = KCReg(map, pts, 2, 0, 'euclidean', [-20, 20], [-20, 20]);

            if abs(kc_results(4)) > noise_thresh(i)
                validResult = true
            end

        end


        kc_angle = -kc_results(3);
        kc_trans = -[kc_results(1), kc_results(2)];

        % error = modified_rmse(acos(rot(1)), kc_angle, shift(1), kc_trans(1), shift(2), kc_trans(2))

        % add to vector
        noise_domain(i) = i
        %noise_error(i) = error

        center = mean(pts);
        rt = [cos(kc_results(3)) -sin(kc_results(3)); sin(kc_results(3)), cos(kc_results(3))];
        PT = (rt * [pts(:,1)-center(1) pts(:,2)-center(2)]')';
        PT(:,1) = PT(:,1) + center(1) + kc_results(1);
        PT(:,2) = PT(:,2) + center(2) + kc_results(2);

        error = sqrt(sum((map-PT).^2,'all'))/size(map,1);
        matrixPoint(j) = error;

    end
    noise_error(:,i) = matrixPoint
    
end

noise_matrix = [noise_domain; noise_error];
noise = transpose(noise_matrix);

outliers = 0;

end

