classdef ShadowCaster < handle
    properties
        card Quad;
        wall Quad;
        light double;
        writer ShapeWriter;
    end
    
    methods
        function obj = ShadowCaster(light, card, wall)
            obj.light = light;
            obj.card = card;
            obj.wall = wall;
        end
        
        % TODO: Plan how to fit the card shadow
        % on the page.
        
        % Card cutouts ==============================================
        
        % Open a file for making a card cutout and write a postscript
        % preamble
        function begin_cutouts(obj, fname)
            obj.writer = ShapeWriter(fname);
            
            % Draw the outline of the card
            obj.writer.write_shape(obj.card.vertices_uv, 'Card outline');
        end
        
        % Shadowcast a single shape and write the result to the file
        function add_cutout(obj, shape, description)
            % Cast the shape backwards onto the card
            cutout = shadowcast(obj.light, shape, obj.card);
            
            % Project the cutout from 3D to 2D in the coordinate
            % space of the card.
            cutout_uv = obj.card.to_uv(cutout);
            
            obj.writer.write_shape(cutout_uv, description);
        end
        
        % When done, write a postamble and close the file
        function finish_cutouts(obj)
            obj.writer.finish
        end
    end
end