INSERT INTO admin_ranks
    (rank, flags, exclude_flags, can_edit_flags)
VALUES
    ('Host', 65535, 0, 65535),
    ('Head Admin', 65535, 0, 65535),
    ('Game Master', 65535, 0, 65535),
    ('Moderator', 8192, 0, 0),
    ('Game Admin', 8191, 0, 0),
    ('Dev Mod', 13937, 0, 0),
    ('Developer', 5745, 0, 0),
    ('Badmin', 5727, 0, 0),
    ('Trial Admin', 5638, 0, 0),
    ('Admin Candidate', 2, 0, 0),
    ('Retired Admin', 258, 0, 0),
    ('Admin Observer', 0, 0, 0);
