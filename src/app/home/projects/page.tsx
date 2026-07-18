import { Grid, Paper, Stack, Typography } from "@mui/material"
import { getProjects } from "../actions"

export default async function Projects() {
    const projects = await getProjects()
    return (
        <Stack spacing={2}>
            <Typography variant="h3">Proyectos</Typography>
            <Typography variant="h5">Todos los proyectos</Typography>
            <Grid container spacing={2}>
                {projects.map((project) => (
                    <Grid key={project.id}>
                        <Paper sx={{ p: 3, bgcolor: "secondary" }}>
                            <Typography variant="h6">{project.name}</Typography>
                            <Typography>{project.description}</Typography>
                            <Typography>
                                Organización: {project.organization?.name ?? "Sin organización"}

                            </Typography>
                        </Paper>
                    </Grid>
                ))}
            </Grid>
        </Stack>
    )
}