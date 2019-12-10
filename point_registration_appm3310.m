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
smiley_pts = load('smiley_points.mat');
smiley_pts = smiley_pts.smiley_pts;
% smiley_pts = [];
[map, pts, rot, shift] = create_point_sets(smiley_pts, 20, 1, ...
                                    10, 5, 0);
figure;
plot(map(:,1), map(:,2), 'ko');
hold;
plot(pts(:,1), pts(:,2), 'rx');
title('Point Sets');
legend('Target Points', 'Data Points');
grid;
% xlim([-5 20]);
% ylim([-15 15]);
x_range = xlim;
y_range = ylim;

%% PCA registration
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

figure;
plot(map(:,1), map(:,2), 'ko');
hold;
plot(new_pts(:,1), new_pts(:,2), 'rx');
title('PCA Registration');
legend('Target Points', 'Data Points');
xlim(x_range);
ylim(y_range);

grid;
%% run KC algorithm
% very interesting, the KC algorithm sometimes fails with the smiley
% points. It seems to be a flip issue but I can't figure out where.
kc_results = KCReg(map, pts, 2, 1);
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
