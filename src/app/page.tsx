import { Box, Button, Container, Stack, Typography } from "@mui/material";

export default function Page() {
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
        <Stack spacing={4}>
          <Typography variant="h2">Hola</Typography>
          <Button variant="contained" color="primary">
            Hola
          </Button>
          <Button href="/home" variant="outlined" color="secondary">
            Ir a la página de inicio
          </Button>
        </Stack>
      </Container>
    </Box>
  );
}
// alignItems="flex-start"