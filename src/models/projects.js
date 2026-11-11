import db from './db.js';

const getAllProjects = async () => {
    const query = `
        SELECT project.project_id, project.organization_id, project.title,
               project.description, project.location, project.date,
               organization.name AS organization_name
        FROM public.service_project AS project
        JOIN public.organization AS organization
            ON project.organization_id = organization.organization_id
        ORDER BY project.project_id;
    `;

    const result = await db.query(query);

    return result.rows;
};



const getProjectsByOrganizationId = async (organizationId) => {
      const query = `
        SELECT
          project_id,
          organization_id,
          title,
          description,
          location,
          date
        FROM public.service_project
        WHERE organization_id = $1
        ORDER BY date;
      `;
      
      const queryParams = [organizationId];
      const result = await db.query(query, queryParams);

      return result.rows;
};

// Export the model functions
export { getAllProjects, getProjectsByOrganizationId };
