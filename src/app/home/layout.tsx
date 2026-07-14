import { getMenu } from "./actions";
import { Box, Link as MuiLink, Stack, Typography } from "@mui/material";

export default async function myLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const menu = await getMenu();

  return (
    <Box sx={{ display: "flex", minHeight: "100vh", bgcolor: "background.default", color: "text.primary" }}>
      <Box
        component="nav"
        sx={{
          width: { xs: "100%", md: 280 },
          p: 4,
          bgcolor: "secondary.main",
          color: "secondary.contrastText",
        }}
      >
        <Typography variant="h5" gutterBottom>
          Menu
        </Typography>
        <Stack spacing={1}>
          {menu.map((item: { name: string; url: string }) => (
            <MuiLink 
              key={item.name} 
              href={item.url} 
              color="inherit"
              underline="none"
              sx={{
                display: 'inline-block',
                padding: '4px 8px',
                borderRadius: '4px',
                transition: 'background-color 0.3s',
                '&:hover': {
                  backgroundColor: "secondary.light"
                }
              }}>
              {item.name}
            </MuiLink>
          ))}
        </Stack>
      </Box>
      <Box component="main" sx={{ flex: 1, p: 4 }}>
        {children}
      </Box>
    </Box>
  );
}
