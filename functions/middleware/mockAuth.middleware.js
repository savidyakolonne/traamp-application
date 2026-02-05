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

    if (!token.startsWith('MOCK_')) {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Invalid mock token. Must start with MOCK_'
      });
    }

    const tokenParts = token.split('_');

    if (tokenParts.length < 3) {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Invalid token format. Expected: MOCK_ROLE_ID (e.g., MOCK_GUIDE_123)'
      });
    }

    const role = tokenParts[1].toLowerCase();

    if (role !== 'guide' && role !== 'tourist') {
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Invalid role in token. Must be GUIDE or TOURIST'
      });
    }

    req.user = {
      uid: token,
      role: role
    };

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