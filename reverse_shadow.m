% Reverse shadowcasting. Given a desired
% shadow, cast rays backwards from the vertices

% Shadow vertices
% Square on the table
%{
shape = [
    -1, 2, 0;
    -1, 4, 0;
    1, 4, 0;
    1, 2, 0];
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

% H shape
%{
shape = [
    -1.25, 5.75, 0;
    -1.25, 6.25, 0;
    -0.25, 6.25, 0;
    -0.25, 6.5, 0;
    -1.25, 6.5, 0;
    -1.25, 7, 0;
    1.25, 7, 0;
    1.25, 6.5, 0;
    0.25, 6.5, 0;
    0.25, 6.25, 0;
    1.25, 6.25, 0;
    1.25, 5.75, 0;
];
%}

shape = [
    -1.25, 7.5, 0;
    -1.25, 8.75, 0;
    -0.75, 8.75, 0;
    -0.75, 8.25, 0;
    0.75, 8.25, 0;
    0.75, 8.75, 0;
    1.25, 8.75, 0;
    1.25, 7.5, 0;
    0.75, 7.5, 0;
    0.75, 8, 0;
    -0.75, 8, 0;
    -0.75, 7.5, 0;
];

% vertical art trading card facing down the Y-axis with the base
% centered at the origin. Everything is measured in inches
ATC_DIMS = [2.5, 3.5];
INDEX_CARD_DIMS = [3, 5];
card = Quad([0, 5, 5 / 2], [pi / 2, 0], INDEX_CARD_DIMS);

% The light is a little bit behind and above the card
light = [0, 0, 11.25];

table = Quad([0, 0, 0], [0, pi / 2], [20, 20]);
shadow = shadowcast(light, card.vertices, table);

% Calculate the shape of the needed cutout
cutout = shadowcast(light, shape, card);

%%

% Display the setup
figure;
view(3);
axis equal;
rotate3d on;
hold on;
xlabel('X');
ylabel('Y');
zlabel('Z');
set(gca, 'Color', [0.1, 0.1, 0.1]);

% Shadow
fill3(shadow(:, 1), shadow(:, 2), shadow(:, 3), 'b');

% Draw the setup in 3D
% desired shape
fill3(shape(:, 1), shape(:, 2), shape(:, 3), 'w');

% Light
plot3(light(1), light(2), light(3), 'ro');

% Rays of light
N = size(shape, 1);
% We're going to plot N line segments in 3D with 2 points each
% but we need to rearrange the data for a call to plot3
rays = zeros(2 * 3, N);
% Put the shadow points in every other row. Note that
% each point is now a spaced out column vector.
rays(1:2:5, :) = shape';
% interleave the light coordinates so every line is drawn
% to the light source.
rays(2:2:6, :) = repmat(light', 1, N);
% now plot the rays as line segments
plot3(rays(1:2, :), rays(3:4, :), rays(5:6, :), 'r');

% Card
C = card.vertices;
fill3(C(:, 1), C(:, 2), C(:, 3), 'w');

% Cutout
fill3(cutout(:, 1), cutout(:, 2), cutout(:, 3), [0.7, 0.7, 0.7]);