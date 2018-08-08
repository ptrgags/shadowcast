% Reverse shadowcasting. Given a desired
% shadow, cast rays backwards from the vertices

% Shadow vertices
% Square on the table
%
shadow = [
    1, 7, 0;
    3, 7, 0;
    3, 5, 0;
    1, 5, 0];
%}

% M shape
%{
shadow = [
    0.5, 3.5, 0;
    1, 6.5, 0;
    1.5, 6.5, 0;
    2, 4, 0;
    2.5, 6.5, 0;
    3, 6.5, 0;
    3.5, 3.5, 0;
    3, 3.5, 0;
    2.75, 5.5, 0;
    2.25, 3.5, 0;
    1.75, 3.5, 0;
    1.25, 5.5, 0;
    1, 3.5, 0];
%}

% vertical art trading card facing down the Y-axis with the base
% centered at the origin. Everything is measured in inches
CARD_DIMS = [2.5, 3.5];
card = Quad([0, 0, 3.5 / 2], [pi / 4, pi / 4], CARD_DIMS);
%{
card = [
    0, 2, 8;
    0, 2, 0;
    4, 2, 0;
    4, 2, 8];
%}
%{
card = [
    0, 4, 0;
    0, 4, 8;
    4, 0, 8;
    4, 0, 0;
];
%}
%card_center = [2, 2, 3.5];
%card_center = [2, 1, 3.5];
%card_normal = [cos(pi / 6), sin(pi / 6), 0];
%card_normal = [0, 1, 0];
%card_normal = [sqrt(2), sqrt(2), 0];

% The light is a little bit behind and above the card
light = [0, -4, 4];

% Calculate the direction from light to
% the shadow vertices
light_rays = shadow - light;
ray_lengths = vecnorm(light_rays, 2, 2);
light_dirs = light_rays ./ ray_lengths;

% Calculate where the light rays intersect the card
light_to_card = card.center - light;
top = dot(light_to_card, card.normal);
rep = repmat(card.normal, size(light_dirs, 1), 1);
bottom = dot(light_dirs, rep, 2);
t = top ./ bottom;

preimage = light + t .* light_dirs;

%%
figure;
view(3);
axis equal;
rotate3d on;
hold on;
xlabel('X');
ylabel('Y');
zlabel('Z');
set(gca, 'Color', [0.1, 0.1, 0.1]);

% Draw the setup in 3D
% Shadow
fill3(shadow(:, 1), shadow(:, 2), shadow(:, 3), 'w');

% Light
plot3(light(1), light(2), light(3), 'ro');

% Rays of light
N = size(shadow, 1);
% We're going to plot N line segments in 3D with 2 points each
% but we need to rearrange the data for a call to plot3
rays = zeros(2 * 3, N);
% Put the shadow points in every other row. Note that
% each point is now a spaced out column vector.
rays(1:2:5, :) = shadow';
% interleave the light coordinates so every line is drawn
% to the light source.
rays(2:2:6, :) = repmat(light', 1, N);
% now plot the rays as line segments
plot3(rays(1:2, :), rays(3:4, :), rays(5:6, :), 'r');


% Card
C = card.vertices;
fill3(C(:, 1), C(:, 2), C(:, 3), 'w');

% Cutout
fill3(preimage(:, 1), preimage(:, 2), preimage(:, 3), [0.7, 0.7, 0.7]);