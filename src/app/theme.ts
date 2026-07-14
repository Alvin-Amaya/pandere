"use client"
import { createTheme } from "@mui/material/styles";

const theme = createTheme({
  palette: {
    mode: "dark",
    background: {
      default: "#060a0e",
      paper: "#102136",
    },
    primary: {
      main: "#9af376",
      contrastText: "#060a0e",
    },
    secondary: {
      main: "#162531",
      contrastText: "#ededed",
    },
    text: {
      primary: "#ededed",
      secondary: "#9af376",
    },
  },
  typography: {
    fontFamily: ["var(--font-geist-sans)", "Arial", "Helvetica", "sans-serif"].join(","),
    button: {
      textTransform: "none",
    },
  },
  components: {
    MuiCssBaseline: {
      styleOverrides: {
        body: {
          margin: 0,
          minHeight: "100vh",
          backgroundColor: "#060a0e",
          color: "#ededed",
        },
      },
    },
  },
});

export default theme;
