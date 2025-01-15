CREATE TABLE games (
    uuid CHAR(36) NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL,
    "updatedAt" DATETIME NOT NULL,
    name TEXT NOT NULL,
    difficulty TEXT CHECK (difficulty IN (
        'beginner',
        'easy',
        'medium',
        'hard',
        'extreme'
    )) NOT NULL,
    "gameState" TEXT CHECK ("gameState" IN (
        'opening',
        'midgame',
        'endgame',
        'unknown'
    )) NOT NULL DEFAULT 'unknown',
    board BLOB NOT NULL
);
