const login = (req, res) => {
  const { username, password } = req.body;
  
  console.log('Dados recebidos:', {
    username,
    password,
    body: req.body
  });

  // Verificação das credenciais
  if (username === 'admin' && password === 'admin123') {
    console.log('Login bem-sucedido');
    return res.status(200).json({
      success: true,
      message: 'Login realizado com sucesso',
      user: {
        username: 'admin',
        role: 'admin'
      }
    });
  }

  console.log('Login falhou - Credenciais inválidas');
  return res.status(401).json({
    success: false,
    message: 'Usuário ou senha inválidos'
  });
};

module.exports = {
  login
}; 