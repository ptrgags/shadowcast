% Class to write shapes to a PostScript file.
classdef ShapeWriter
    properties(Constant)
        % How many points in an inch
        % for scaling the coordinates
        POINTS_PER_INCH = 72;
    end
    
    properties
        % The file handle for the PostScript file.
        ps_file;
    end
    
    methods
        function obj = ShapeWriter(fname)
            ps_file = fopen(fname, 'w');
            
            % Write the preamble 
            fprintf(ps_file, '%%!PS\n');
            fprintf(ps_file, '/inch {72 mul} def\n');
            fprintf(ps_file, '1 inch 1 inch translate\n');
            
            obj.ps_file = ps_file;
        end
        
        function write_shape(obj, shape, comment)
            % write the comment before the shape
            fprintf(obj.ps_file, '\n%% %s\n', comment);
            
            % scale the points to be in points, not inches.
            ps_coords = shape * obj.POINTS_PER_INCH;
            
            % loop over each point in the shape.
            for i = 1:size(ps_coords, 1)
                % In the postscript code, we move to the first point,
                % and draw lines to all the other points.
                if i == 1
                    cmd = 'moveto';
                else
                    cmd = 'lineto';
                end
                
                % Draw the points
                x = ps_coords(i, 1);
                y = ps_coords(i, 2);
                fprintf(obj.ps_file, '%f %f %s\n', x, y, cmd);
            end
            
            % Finish the shape
            fprintf(obj.ps_file, 'closepath\nstroke\n');
        end
        
        %
        function finish(obj)
            % Write the final showpage command
            fprintf(obj.ps_file, '\nshowpage\n');
            
            % Close the file
            fclose(obj.ps_file);
        end
    end
end

