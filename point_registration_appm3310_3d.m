% Authors: Adam Spiers (adam.spiers@colorado.edu)
%          Soroush Khadem (soroush.khadem@colorado.edu)
% Date Created: 8 December 2019
% 
% APPM 3310: Final Project
% Point registration

%% Housekeeping
close all; clc;
%%
% generate k random points
dog_3d_points = load('dog_3d_points.mat');
dog_3d_points = dog_3d_points.dog_3d_pts;
% bunny_pts = [];
[map, pts, rot, shift] = create_point_sets_3d(dog_3d_points, 10, 1, ...
                                    20, 5, 0);
figure;
scatter3(map(:,1), map(:,2), map(:,3), 1, 'k.');
hold;
scatter3(pts(:,1), pts(:,2), pts(:,3), 1, 'r.');
grid on;
title('Point Sets');
legend('Target Points', 'Data Points');
% xlim([-5 20]);
% ylim([-15 15]);
% x_range = xlim;
% y_range = ylim;

%% Least squares registration
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

new_pts_pca = pca_rot\(pts - pca_trans)';
new_pts_pca = new_pts_pca';

figure;
scatter3(map(:,1), map(:,2), map(:,3), 1, 'k.');
hold;
scatter3(new_pts_pca(:,1), new_pts_pca(:,2), new_pts_pca(:,3), 1, 'r.');
title('Least Squares Registration');
legend('Target Points', 'Data Points');
% xlim(x_range);
% ylim(y_range);
grid on;
%% run KC algorithm
% very interesting, the KC algorithm sometimes fails with the smiley
% points. It seems to be a flip issue but I can't figure out where.
kc_results = KCReg(map, pts, 2, 1, 'euclidean', x_range, y_range);
kc_angle = -results(3);
kc_trans = -[results(1), results(2)];
kc_rot = [cos(kc_angle) -sin(kc_angle); sin(kc_angle) cos(kc_angle)];



%% run ICP. Note that the points are assumed to be 3D (on a plane)
% This doesn't work
% map3d = [map, ones(1,size(map,1))'];
% pts3d = [pts, ones(1,size(pts,1))'];
% 
% [s, pca_rot, pca_trans, err, newP] = icp(map3d', pts3d');
% new_pts_icp = newP';
% 
% figure;
% plot(map3d(:,1), map3d(:,2), 'ko');
% hold;
% plot(new_pts_icp(:,1), new_pts_icp(:,2), 'rx');
% title('ICP Registration');
% legend('Target Points', 'Data Points');
% xlim(x_range);
% ylim(y_range);
% grid;
% 
