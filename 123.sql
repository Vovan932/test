%%sql
CREATE OR REPLACE FUNCTION reverse_byte_pairs(input_string TEXT) RETURNS TEXT AS $$
DECLARE
    result_string TEXT := '';
    i INT;
BEGIN
    -- Iterate through the string in steps of 2 characters
    FOR i IN REVERSE LENGTH(input_string) - 1 BY 2 .. 0 BY 2 LOOP
        -- Extract a 2-character pair
        -- SUBSTRING(string, start, length)
        result_string := result_string || SUBSTRING(input_string FROM i + 1 FOR 2);
    END LOOP;
    RETURN result_string;
END;
$$ LANGUAGE plpgsql;

-- Test the function with the example provided by the user
SELECT reverse_byte_pairs('40D4FCE9DD32FD57') AS reversed_string;
