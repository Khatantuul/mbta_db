
-- Main roles/privileges and users 

CREATE ROLE "Admin"
GRANT ALL PRIVILEGES ON mbta_project.* TO "Admin"
CREATE ROLE "Manager"
GRANT SELECT ON mbta_project.ridership_analytics TO "Manager"
CREATE ROLE "User"
GRANT EXECUTE ON PROCEDURE mbta_project.FindClosestStation TO "User"

CREATE USER "admin_user"@"%" IDENTIFIED BY 'adminOfTheDay'
GRANT "Admin" TO "admin_user"

CREATE USER "manager_user"@"%" IDENTIFIED BY 'managerOfTheDay'
GRANT "Manager" TO "manager_user"

CREATE USER "regular_user"@"%" IDENTIFIED BY 'userOfTheDay'
GRANT "User" TO "regular_user"

-- Assigning the roles as default to the users

ALTER USER 'admin_user'@'%' DEFAULT ROLE 'Admin'
ALTER USER 'manager_user'@'%' DEFAULT ROLE 'Manager'
ALTER USER 'regular_user'@'%' DEFAULT ROLE 'User'

