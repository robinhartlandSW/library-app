
INSERT INTO copies(editionID) VALUES(SELECT ID FROM editions WHERE author == 'J.K. Rowling' ORDER BY LIMIT 1);