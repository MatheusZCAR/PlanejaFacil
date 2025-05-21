const jwt = require('jsonwebtoken');
const config = require('../config/config');

const login = (req, res) => {
  const { username, password } = req.body;

  if (username === config.defaultUser.username && password === config.defaultUser.password) {
    const token = jwt.sign({ username }, config.jwtSecret, { expiresIn: '1h' });
    return res.json({ token });
  }

  return res.status(401).json({ message: 'Usuário ou senha inválidos' });
};

module.exports = {
  login
}; 