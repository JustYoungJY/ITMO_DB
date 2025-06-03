CREATE OR REPLACE FUNCTION trg_update_group_quantity()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Added a new fish
    IF TG_OP = 'INSERT' THEN
        UPDATE groups
        SET    quantity = quantity + 1
        WHERE  id_group = NEW.group_id;

    -- The fish was removed
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE groups
        SET    quantity = quantity - 1
        WHERE  id_group = OLD.group_id;

    -- Changed the fish's group
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.group_id <> OLD.group_id THEN
            UPDATE groups
            SET    quantity = quantity - 1
            WHERE  id_group = OLD.group_id;

            UPDATE groups
            SET    quantity = quantity + 1
            WHERE  id_group = NEW.group_id;
        END IF;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS trg_fish_group_quantity ON fish;

CREATE TRIGGER trg_fish_group_quantity
    AFTER INSERT OR DELETE OR UPDATE OF group_id
    ON fish
    FOR EACH ROW
EXECUTE FUNCTION trg_update_group_quantity();

