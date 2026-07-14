import { Box, Container, Paper, Stack, Typography } from "@mui/material";
import { getProjects } from "./actions";

export default async function Dashboard() {
  const projects = await getProjects();

  return (
    <Box
      component="main"
      sx={{
        display: "flex",
        minHeight: "100vh",
        alignItems: "center",
        justifyContent: "center",
        bgcolor: "background.default",
        color: "text.primary",
        p: 2,
      }}
    >
      <Container
        maxWidth="md"
        sx={{
          bgcolor: "background.paper",
          borderRadius: 3,
          p: { xs: 4, md: 6 },
          boxShadow: 6,
        }}
      >
        <Stack spacing={3}>
          <Typography variant="h2">Dashboard</Typography>
          <Typography variant="h4">Projects</Typography>
          <Stack spacing={2}>
            {projects.map((project) => (
              <Paper key={project.id} sx={{ p: 3, bgcolor: "background.default" }}>
                <Typography variant="h6">{project.name}</Typography>
                <Typography>{project.description}</Typography>
              </Paper>
            ))}
          </Stack>
        </Stack>
      </Container>
    </Box>
  );
}
