const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(bodyParser.json());

app.post('/login', (req, res) => {
  const { email, password, role } = req.body; // Frontend'den rol bilgisini de alıyoruz

  if (!email || !password || !role) {
    return res.status(400).json({ message: 'E-posta, şifre ve rol alanları zorunludur.' });
  }

  fs.readFile(path.join(__dirname, 'users.json'), 'utf8', (err, data) => {
    if (err) {
      console.error('Kullanıcı verilerini okuma hatası:', err);
      return res.status(500).json({ message: 'Sunucu hatası.' });
    }

    try {
      const usersData = JSON.parse(data);
      let user = null;

      if (role === 'dietitian') {
        user = usersData.dietitians.find(d => d.email === email && d.password === password);
      } else if (role === 'user') {
        user = usersData.users.find(u => u.email === email && u.password === password);
      } else {
        return res.status(400).json({ message: 'Geçersiz rol.' });
      }

      if (user) {
        return res.status(200).json({ message: 'Giriş başarılı!', token: 'gecici_token', role: role }); // Rol bilgisini de geri gönderiyoruz
      } else {
        return res.status(401).json({ message: 'Geçersiz e-posta veya şifre.' });
      }
    } catch (parseError) {
      console.error('Kullanıcı verilerini ayrıştırma hatası:', parseError);
      return res.status(500).json({ message: 'Sunucu hatası.' });
    }
  });
});

app.listen(port, () => {
  console.log(`Sunucu http://localhost:${port} adresinde çalışıyor.`);
});