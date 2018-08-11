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

letter_cell = [
    0, 0, 0;
    0, 0.5, 0;
    0.75, 0.5, 0;
    0.75, 0, 0;
];

% Cells for "Hello"
l1 = letter_cell + [-1, 2, 0];
l2 = letter_cell + [-1, 3, 0];
l3 = letter_cell + [-1, 4, 0];
l4 = letter_cell + [-1, 5, 0];
l5 = letter_cell + [-1, 6, 0];

l6 = letter_cell + [0.25, 3.5, 0];
l7 = letter_cell + [0.25, 4.5, 0];
l8 = letter_cell + [0.25, 5.5, 0];
l9 = letter_cell + [0.25, 6.5, 0];
l10 = letter_cell + [0.25, 7.5, 0];

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
T = vis.add_surface(table, false);

% Cast card shadows
vis.add_card_shadow(L1, C1, T);
vis.add_card_shadow(L2, C2, T);

% Add cutouts
vis.add_cutout(L1, C1, l1);
vis.add_cutout(L1, C1, l3);
vis.add_cutout(L1, C1, l5);
vis.add_cutout(L1, C1, l7);
vis.add_cutout(L1, C1, l9);

vis.add_cutout(L2, C2, l2);
vis.add_cutout(L2, C2, l4);
vis.add_cutout(L2, C2, l6);
vis.add_cutout(L2, C2, l8);
vis.add_cutout(L2, C2, l10);

% Basic setup before adding designs
vis.plot

printer = ShadowPrinter(vis.shadows, table);
printer.print('hello_base.ps')

% Make the cutouts
near_caster = ShadowCaster(near_light, near_card, table);
near_caster.begin_cutouts('hello_near.ps');
near_caster.add_cutout(l1, 'H cell');
near_caster.add_cutout(l3, 'L cell');
near_caster.add_cutout(l5, 'O cell');
near_caster.add_cutout(l7, 'O cell');
near_caster.add_cutout(l9, 'L cell');
near_caster.finish_cutouts;

far_caster = ShadowCaster(far_light, far_card, table);
far_caster.begin_cutouts('hello_far.ps');
far_caster.add_cutout(l2, 'E cell');
far_caster.add_cutout(l4, 'L cell');
far_caster.add_cutout(l6, 'W cell');
far_caster.add_cutout(l8, 'R cell');
far_caster.add_cutout(l10, 'D cell');
far_caster.finish_cutouts;