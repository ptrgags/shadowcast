% given a 1x3 light position and a Nx3 list of points
% compute a unit vector in the direction from the light
% to each point. The result matrix is Nx3 where each row
% is a unit vector
function dirs = light_directions(light, points)
    % unit vector is v / |v|
    rays = points - light;
    ray_lengths = vecnorm(rays, 2, 2);
    dirs = rays ./ ray_lengths;
end
