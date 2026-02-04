// functions/index.js
import app from "./app.js";

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`\n✅ Server running on http://localhost:${PORT}`);
  console.log(`📱 Ready for Flutter connections\n`);
  console.log(`Available routes:`);
  console.log(`  GET  /`);
  console.log(`  GET  /api/profile (requires auth)`);
  console.log(`\nTest tokens:`);
  console.log(`  Guide:   Bearer MOCK_GUIDE_123`);
  console.log(`  Tourist: Bearer MOCK_TOURIST_456\n`);
});