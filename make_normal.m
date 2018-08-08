function vec = make_normal(azimuth, elevation)
    x = cos(elevation) * cos(azimuth);
    y = cos(elevation) * sin(azimuth);
    z = sin(elevation);
    vec = [x, y, z];
end