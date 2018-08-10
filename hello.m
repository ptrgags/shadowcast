CARD_WIDTH = 2.5;
CARD_HEIGHT = 3.5;

% far card is how many inches from the origin
FAR_END = 10;


% large horizontal plane at z = 0 to represent
% the table
PAPER_WIDTH = 8.5;
PAPER_HEIGHT = 11;
table = Quad(...
    [0, FAR_END / 2, 0],...
    [pi / 2, pi / 2],...
    [PAPER_WIDTH, PAPER_HEIGHT]);



near_card = Quad(...
    [0, 0, CARD_HEIGHT / 2],... 
    [pi / 2, 0],...
    [CARD_WIDTH, CARD_HEIGHT]);

far_card = Quad(...
    [0, FAR_END, CARD_HEIGHT / 2],...
    [pi / 2, 0], ...
    [CARD_WIDTH, CARD_HEIGHT]);

DIST_BEHIND = 5;
LIGHT_HEIGHT = 5;
near_light = [0, -DIST_BEHIND, LIGHT_HEIGHT];
far_light = [0, FAR_END + DIST_BEHIND, LIGHT_HEIGHT];

vis = ShadowVisualizer;
% Add the basic scene geometry
L1 = vis.add_light(near_light);
L2 = vis.add_light(far_light);
C1 = vis.add_surface(near_card, true);
C2 = vis.add_surface(far_card, true);
T = vis.add_surface(table, true);

% Cast card shadows
vis.add_card_shadow(L1, C1, T);
vis.add_card_shadow(L2, C2, T);

% Basic setup before adding designs
vis.plot

printer = ShadowPrinter(vis.shadows, table);
printer.print('hello_base.ps')