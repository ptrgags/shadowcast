% large horizontal plane at z = 0 to represent
% the table
table = Quad([0, 0, 0], [0, pi / 2], [20, 20]);

CARD_WIDTH = 2.5;
CARD_HEIGHT = 3.5;

% far card is how many inches from the origin
FAR_END = 10;

near_card = Quad(...
    [0, 0, CARD_HEIGHT / 2],... 
    [pi / 2, 0],...
    [CARD_WIDTH, CARD_HEIGHT]);

far_card = Quad(...
    [0, FAR_END, CARD_HEIGHT / 2],...
    [pi / 2, 0], ...
    [CARD_WIDTH, CARD_HEIGHT]);

DIST_BEHIND = 4;
LIGHT_HEIGHT = 5;
near_light = [0, -DIST_BEHIND, LIGHT_HEIGHT];
far_light = [0, FAR_END + DIST_BEHIND, LIGHT_HEIGHT];

vis = ShadowVisualizer;
L1 = vis.add_light(near_light);
L2 = vis.add_light(far_light);
C1 = vis.add_surface(near_card, true);
C2 = vis.add_surface(far_card, true);
T = vis.add_surface(table, false);
vis.add_card_shadow(L1, C1, T);
vis.add_card_shadow(L2, C2, T);

vis.plot