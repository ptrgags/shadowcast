% given a 1x3 origin and a Nx3 list of points
% compute a unit vector in the direction from the origin
% to each point. The result matrix is Nx3 where each row
% is a unit vector. This calculates many directions at once.
function dirs = calc_directions(origin, points)
    % unit vector is v / |v|
    rays = points - origin;
    % Compute the 2-norm (Euclidean) along the rows (axis 2)
    ray_lengths = vecnorm(rays, 2, 2);
    dirs = rays ./ ray_lengths;
end
