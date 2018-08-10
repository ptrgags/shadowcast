% trace rays from a light to the points, and mark where
% they intersect a quad. If the quad is behind the points,
% this is a shadow. If the quad is in front of the points, 
% this is the preimage of the shadow.
%
% This really just computes a ray plane intersection.
function image = shadowcast(light, points, plane)
    light_dirs = calc_directions(light, points);
    
    light_to_wall = plane.center - light;
    
    % Compute the t values along the light rays where they intersect
    % the quad
    top = dot(light_to_wall, plane.normal);
    N = size(light_dirs, 1);
    norms = repmat(plane.normal, N, 1);
    bottom = dot(light_dirs, norms, 2);
    t = top ./ bottom;

    % Calculate the points in world space by traversing the rays
    image = light + t .* light_dirs;
end