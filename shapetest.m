H = [
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

I = [
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

caster = ShadowCaster(light, card, table);
caster.begin_cutouts('hi.ps');
caster.add_cutout(H, 'H shape');
caster.add_cutout(I, 'I shape');
caster.finish_cutouts;
