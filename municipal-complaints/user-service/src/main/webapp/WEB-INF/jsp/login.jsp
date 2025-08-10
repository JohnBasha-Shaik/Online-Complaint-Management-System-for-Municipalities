<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .card { max-width: 420px; margin: auto; padding: 24px; border: 1px solid #ddd; border-radius: 8px; }
        input, select { width: 100%; padding: 10px; margin: 8px 0; }
        button { padding: 10px 16px; }
    </style>
</head>
<body>
<div class="card">
    <h2>Login</h2>
    <form method="post" action="/api/users/auth/login-ui">
        <label>Username or Email</label>
        <input type="text" name="usernameOrEmail" required/>
        <label>Password</label>
        <input type="password" name="password" required/>
        <button type="submit">Login</button>
    </form>
    <p>New user? <a href="/ui/register">Register</a></p>
</div>
</body>
</html>