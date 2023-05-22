function move_multiple(field, OC, n)
    
    for i = 1:n
        [field, OC] = moveObjectsOnce(field, OC);
    end

    imshow(uint8(field));
end