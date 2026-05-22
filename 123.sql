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


### MSSQL Equivalent Function

This T-SQL function replicates the logic of the PostgreSQL `reverse_byte_pairs` function for MSSQL. It processes the input string from right to left, taking two characters at a time and appending them to the result.


CREATE OR ALTER FUNCTION reverse_byte_pairs_mssql(@input_string NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @result_string NVARCHAR(MAX) = '';
    DECLARE @current_idx INT;
    DECLARE @len INT = LEN(@input_string);

    -- Start from the last character's index (0-based for internal calculation, but SUBSTRING is 1-based)
    -- The PostgreSQL loop 'FOR i IN REVERSE LENGTH(input_string) - 1 BY 2 .. 0 BY 2' means 'i' will be the 0-based index
    -- of the starting character for each 2-char segment, stepping backwards by 2.
    SET @current_idx = @len - 1; 

    WHILE @current_idx >= 0
    BEGIN
        -- Extract 2 characters starting from the 1-based index @current_idx + 1
        -- If only one character remains (e.g., at the very beginning or end of an odd-length string), 
        -- SUBSTRING will correctly return only that character.
        SET @result_string = @result_string + SUBSTRING(@input_string, @current_idx + 1, 2);
        SET @current_idx = @current_idx - 2;
    END;

    RETURN @result_string;
END;
