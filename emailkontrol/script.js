// Kullanıcı verileri (simülasyon amaçlı olarak listede tutuluyor)
const users = [
    { email: "test@example.com", password: "123456" },
    { email: "user@domain.com", password: "password" },
    { email: "admin@site.com", password: "admin123" }
];

// Form ve buton elementlerini seçelim
const form = document.getElementById('loginForm');
const messageElement = document.getElementById('message');

// Formun submit olmasını dinleyelim
form.addEventListener('submit', function (event) {
    event.preventDefault();  // Formun yenilenmesini engelle

    const emailInput = document.getElementById('email').value;
    const passwordInput = document.getElementById('password').value;

    const userFound = users.find(user => user.email === emailInput && user.password === passwordInput);

    if (userFound) {
        messageElement.textContent = "Başarıyla giriş yaptınız!";
        messageElement.style.color = "green";
    } else {
        messageElement.textContent = "Email veya şifre yanlış!";
        messageElement.style.color = "red";
    }
});
