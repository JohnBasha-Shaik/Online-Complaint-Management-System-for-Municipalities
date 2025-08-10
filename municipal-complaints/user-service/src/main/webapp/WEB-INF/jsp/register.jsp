<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .card { max-width: 520px; margin: auto; padding: 24px; border: 1px solid #ddd; border-radius: 8px; }
        input, select { width: 100%; padding: 10px; margin: 8px 0; }
        button { padding: 10px 16px; }
    </style>
</head>
<body>
<div class="card">
    <h2>Citizen Registration</h2>
    <form method="post" action="/api/users/auth/register-ui">
        <label>Name</label>
        <input type="text" name="name" required/>
        <label>Email</label>
        <input type="email" name="email" required/>
        <label>Username</label>
        <input type="text" name="username" required/>
        <label>Password</label>
        <input type="password" name="password" required/>
        <label>Role</label>
        <select name="role">
            <option value="CITIZEN">Citizen</option>
            <option value="STAFF">Staff</option>
            <option value="ADMIN">Admin</option>
        </select>
        <button type="submit">Register</button>
    </form>
    <p>Already have an account? <a href="/ui/login">Login</a></p>
</div>
</body>
</html>