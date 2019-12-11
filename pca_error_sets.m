function [outliers,noise] = pca_error_sets(prev_points, num_points, with_noise, ...
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

matrixPoint = zeros(1, 5)


for i = 1:num_points
    for j = 1:5
        % PCA COMPUTATION
        [map, pts, rot, shift] = create_point_sets([], 10, i, ...
                                                20, 5, 0);

        centroid_map = mean(map);
        centroid_pts = mean(pts);

        map_n = map - centroid_map;
        pts_n = pts - centroid_pts;

        covariance_mat = map_n'*pts;

        [U,S,V] = svd(covariance_mat);
        pca_rot = V*U';

        if (det(pca_rot)) < 0
            V(:,size(V,1)) = V(:,size(V,1))*-1;
            pca_rot = V*U';
        end

        pca_trans = -pca_rot*centroid_map' + centroid_pts';
        pca_trans = pca_trans';

        new_pts = pca_rot\(pts - pca_trans)';
        new_pts = new_pts';

        % END PCA COMPUTATION
        error = sqrt(sum((map-new_pts).^2,'all'))/size(map,1);
        matrixPoint(j) = error;
        
    end
    noise_error(:,i) = matrixPoint;
    noise_domain(i) = i;
end


noise_matrix = [noise_domain; noise_error];
noise = transpose(noise_matrix);
  % error = sqrt(sum((map-PT).^2,'all'))/size(map,1);
outliers = 0;

end

