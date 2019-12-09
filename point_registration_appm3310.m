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
[map, pts, rot, shift] = create_point_sets(20, 1, ...
                                    10, 5, 2);
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

%% SVD registration
centroid_map = mean(map);
centroid_pts = mean(pts);

map_n = map - centroid_map;
pts_n = pts - centroid_pts;

covariance_mat = map_n'*pts;

[U,S,V] = svd(covariance_mat);
R = V*U';

if (det(R)) < 0
    V(:,3) = V(:,3)*-1;
    R = V*U';
end

t = -R*centroid_map' + centroid_pts';
t = t';

new_pts = R\(pts - t)';
new_pts = new_pts';

figure;
plot(map(:,1), map(:,2), 'ko');
hold;
plot(new_pts(:,1), new_pts(:,2), 'rx');
title('SVD Registration');
legend('Target Points', 'Data Points');
xlim(x_range);
ylim(y_range);

grid;
%% run KC algorithm

KCReg(map, pts, 2, 1);
