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

export { getAllProjects };
