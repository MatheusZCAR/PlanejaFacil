require('dotenv').config();

module.exports = {
  port: process.env.PORT || 3000,
  jwtSecret: process.env.JWT_SECRET || 'planeja-facil-secret',
  defaultUser: {
    username: 'admin',
    password: 'admin123'
  }
}; 