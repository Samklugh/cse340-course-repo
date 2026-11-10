-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);



-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');


-- ========================================
-- Service Projects Table
-- ========================================
CREATE TABLE service_project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id) ON DELETE RESTRICT,
    title VARCHAR(150) NOT NULL CHECK (LENGTH(TRIM(title)) > 0),
    description TEXT NOT NULL CHECK (LENGTH(TRIM(description)) > 0),
    location VARCHAR(255) NOT NULL CHECK (LENGTH(TRIM(location)) > 0),
    date DATE NOT NULL
);

-- Match sponsors by name so their generated IDs do not need to be hard-coded.
INSERT INTO service_project (organization_id, title, description, location, date)
SELECT organization.organization_id, sample.title, sample.description, sample.location, sample.date
FROM organization
JOIN (VALUES
    ('BrightFuture Builders', 'Community Playground Repair', 'Repair benches and playground equipment for neighborhood families.', 'Provo Community Park', DATE '2027-03-06'),
    ('BrightFuture Builders', 'Accessible Ramp Build', 'Build an accessible entrance ramp at the community center.', 'Provo Community Center', DATE '2027-03-13'),
    ('BrightFuture Builders', 'Shelter Painting Day', 'Paint common rooms at a local shelter.', 'Orem Community Shelter', DATE '2027-03-20'),
    ('BrightFuture Builders', 'Library Shelf Installation', 'Assemble and install shelves for donated books.', 'Springville Community Library', DATE '2027-03-27'),
    ('BrightFuture Builders', 'Neighborhood Fence Repair', 'Repair damaged fencing around a neighborhood gathering space.', 'Provo Neighborhood Garden', DATE '2027-04-03'),
    ('GreenHarvest Growers', 'Spring Garden Planting', 'Prepare garden beds and plant seasonal vegetables.', 'Orem Community Garden', DATE '2027-03-06'),
    ('GreenHarvest Growers', 'Composting Workshop', 'Teach residents how to turn food scraps into compost.', 'Provo Learning Garden', DATE '2027-03-13'),
    ('GreenHarvest Growers', 'Seedling Distribution', 'Distribute vegetable seedlings and growing instructions to families.', 'Springville Farmers Market', DATE '2027-03-20'),
    ('GreenHarvest Growers', 'School Garden Preparation', 'Prepare raised beds for a school gardening program.', 'Orem School Garden', DATE '2027-03-27'),
    ('GreenHarvest Growers', 'Food Pantry Harvest', 'Harvest and package fresh produce for a community food pantry.', 'Provo Urban Farm', DATE '2027-08-14'),
    ('UnityServe Volunteers', 'Food Pantry Sorting', 'Sort donated food and prepare grocery packages for families.', 'Provo Community Food Pantry', DATE '2027-03-06'),
    ('UnityServe Volunteers', 'Winter Clothing Drive', 'Collect and organize warm clothing for shelter residents.', 'Orem Volunteer Center', DATE '2027-01-16'),
    ('UnityServe Volunteers', 'Senior Center Activity Day', 'Help run games and social activities for older adults.', 'Springville Senior Center', DATE '2027-03-20'),
    ('UnityServe Volunteers', 'River Trail Cleanup', 'Collect litter and sort recyclable materials along the trail.', 'Provo River Trail', DATE '2027-03-27'),
    ('UnityServe Volunteers', 'School Supply Packing', 'Pack donated school supplies into backpacks for students.', 'Orem Community Hall', DATE '2027-08-07')
) AS sample (organization_name, title, description, location, date)
    ON organization.name = sample.organization_name;

-- Verify the inserted details and the number of projects per sponsor.
SELECT project.project_id, project.organization_id, organization.name AS organization_name,
       project.title, project.description, project.location, project.date
FROM service_project AS project
JOIN organization ON organization.organization_id = project.organization_id
ORDER BY project.organization_id, project.project_id;

SELECT organization.organization_id, organization.name, COUNT(project.project_id) AS project_count
FROM organization
LEFT JOIN service_project AS project ON project.organization_id = organization.organization_id
GROUP BY organization.organization_id, organization.name
ORDER BY organization.organization_id;
