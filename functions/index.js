import app from "./app.js";

const PORT = 3000;

// checking for working on port - savidya

app.listen(PORT, () => {
  console.log(`Backend running on http://localhost:${PORT}`);
});
