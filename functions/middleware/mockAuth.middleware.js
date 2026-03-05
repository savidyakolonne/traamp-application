import mockUsers from "../data/mockUsers.js";

const mockAuthMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'No authorization token provided'
      });
    }

    if (!authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Invalid authorization header format. Expected: Bearer <token>'
      });
    }

    const token = authHeader.substring(7);

    const user = mockUsers[token];

    if (!user) {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Invalid token'
      });
    }

    req.user = user;

    console.log(`✅ Auth: ${req.user.uid} (${req.user.role})`);
    next();

  } catch (error) {
    console.error('❌ Mock Auth Error:', error);
    return res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'Authentication failed'
    });
  }
};

export default mockAuthMiddleware;