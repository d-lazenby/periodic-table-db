ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;
ALTER TABLE elements ADD UNIQUE(name);
ALTER TABLE elements ADD UNIQUE(symbol);
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;
ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);
CREATE TABLE types();
ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY;
ALTER TABLE types ADD COLUMN type VARCHAR(20) NOT NULL;
INSERT INTO types(type) VALUES('metal'), ('metalloid'), ('nonmetal');
ALTER TABLE properties ADD COLUMN type_id INT;

-- Update the properties table with the corresponding type_id from types
UPDATE properties AS p
SET   type_id = t.type_id
FROM   types AS t
WHERE  p.type = t.type;

ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;
ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);

-- Make the first letter of symbol uppercase
UPDATE elements SET symbol = INITCAP(symbol);

INSERT INTO elements(atomic_number, symbol, name)
VALUES
  (9, 'F', 'Fuorine'),
  (10, 'Ne', 'Neon');

INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
VALUES
  (9, 18.998, -220, -188.1, 3),
  (10, 20.18, -248.6, -246.1, 3);

-- To remove trailing zeros from atomic_mass, first convert to DECIMAL, then use TRIM()
ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;
UPDATE properties SET atomic_mass = TRIM(TRAILING '0' FROM CAST(atomic_mass AS TEXT))::DECIMAL;

-- TESTING
SELECT TRIM(TRAILING '0' FROM CAST(atomic_mass AS TEXT)) FROM properties;

UPDATE properties SET atomic_mass = TRIM(TRAILING '0' FROM CAST(atomic_mass AS TEXT))::DECIMAL;